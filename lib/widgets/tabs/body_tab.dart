import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../controller/http_controller.dart';
import '../global/custom_toast.dart';

// --- BodyTabController ---

class BodyTabController extends GetXController {
  final HttpController httpController = Get.smartFind<HttpController>();

  late final TextEditingController jsonController;
  late final TextEditingController xmlController;
  late final TextEditingController textController;
  late final TextEditingController graphqlQueryController;
  late final TextEditingController graphqlVariablesController;

  final RxString jsonError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    jsonController = TextEditingController(text: httpController.jsonBody.value);
    xmlController = TextEditingController(text: httpController.xmlBody.value);
    textController = TextEditingController(text: httpController.textBody.value);
    graphqlQueryController = TextEditingController(
      text: httpController.graphqlQuery.value,
    );
    graphqlVariablesController = TextEditingController(
      text: httpController.graphqlVariables.value,
    );

    // Initial validation
    validateJson(httpController.jsonBody.value);

    // Sync from HttpController to local controllers
    ever(httpController.jsonBody, (String val) {
      if (httpController.bodyType.value == 'JSON' &&
          jsonController.text != val) {
        jsonController.text = val;
      }
    });
    ever(httpController.xmlBody, (String val) {
      if (httpController.bodyType.value == 'XML' && xmlController.text != val) {
        xmlController.text = val;
      }
    });
    ever(httpController.textBody, (String val) {
      if (httpController.bodyType.value == 'Text' &&
          textController.text != val) {
        textController.text = val;
      }
    });
    ever(httpController.graphqlQuery, (String val) {
      if (httpController.bodyType.value == 'GraphQL' &&
          graphqlQueryController.text != val) {
        graphqlQueryController.text = val;
      }
    });
    ever(httpController.graphqlVariables, (String val) {
      if (httpController.bodyType.value == 'GraphQL' &&
          graphqlVariablesController.text != val) {
        graphqlVariablesController.text = val;
      }
    });
  }

  void updateBody(String value) {
    httpController.body.value = value;
  }

  void validateJson(String value) {
    if (value.trim().isEmpty) {
      jsonError.value = '';
      return;
    }
    try {
      jsonDecode(value);
      jsonError.value = '';
    } catch (e) {
      String msg = e.toString();
      if (msg.contains('FormatException:')) {
        msg = msg.split('FormatException:').last.trim();
      }
      jsonError.value = msg;
    }
  }

  void formatJson(BuildContext context) {
    String jsonText = jsonController.text.trim();
    if (jsonText.isEmpty) {
      CustomToast.warning(title: 'JSON body is empty');
      return;
    }

    try {
      // 1. Try standard JSON parse
      final decoded = jsonDecode(jsonText);
      final formatted = const JsonEncoder.withIndent('  ').convert(decoded);
      _applyFormattedText(formatted);
      CustomToast.success(title: 'JSON Formatted Successfully');
      jsonError.value = '';
    } catch (e) {
      // 2. Lenient fix for common mistakes
      try {
        String fixed = jsonText;

        // Wrap in braces if it looks like a list of key-values but missing braces
        if (!fixed.trim().startsWith('{') &&
            !fixed.trim().startsWith('[') &&
            fixed.contains(':')) {
          fixed = '{$fixed}';
        }

        // Wrap unquoted keys in quotes
        fixed = fixed.replaceAllMapped(
          RegExp(r'([{,])\s*([a-zA-Z0-9_\-]+)\s*:'),
          (match) => '${match.group(1)} "${match.group(2)}":',
        );

        // Wrap unquoted values in quotes (more robust)
        fixed = fixed.replaceAllMapped(
          RegExp(r':\s*([^,"{}\[\]\s][^,}\]]*?)\s*([,}\]])'),
          (match) {
            String val = match.group(1)!.trim();
            String suffix = match.group(2)!;

            // Don't quote if already quoted
            if (val.startsWith('"') && val.endsWith('"')) {
              return ': $val$suffix';
            }

            // Don't quote numbers, booleans or null
            if (val == 'true' ||
                val == 'false' ||
                val == 'null' ||
                (double.tryParse(val) != null && !val.startsWith('0')) ||
                val == '0') {
              return ': $val$suffix';
            }
            return ': "$val"$suffix';
          },
        );

        // Remove trailing commas
        fixed = fixed.replaceAll(RegExp(r',\s*([}\]])'), r'$1');

        final decoded = jsonDecode(fixed);
        final formatted = const JsonEncoder.withIndent('  ').convert(decoded);
        _applyFormattedText(formatted);
        CustomToast.info(title: 'JSON Formatted (Auto-corrected)');
        jsonError.value = '';
      } catch (_) {
        // 3. If fix failed, show original error
        String errorMsg = e.toString();
        if (errorMsg.contains('FormatException:')) {
          errorMsg = errorMsg.split('FormatException:').last.trim();
        }
        CustomToast.error(title: 'Invalid JSON', description: errorMsg);
        jsonError.value = errorMsg;
      }
    }
  }

  void clearBody(String type) {
    switch (type) {
      case 'JSON':
        jsonController.clear();
        httpController.jsonBody.value = '';
        jsonError.value = '';
        break;
      case 'XML':
        xmlController.clear();
        httpController.xmlBody.value = '';
        break;
      case 'Text':
        textController.clear();
        httpController.textBody.value = '';
        break;
      case 'GraphQL':
        graphqlQueryController.clear();
        graphqlVariablesController.clear();
        httpController.graphqlQuery.value = '';
        httpController.graphqlVariables.value = '';
        break;
    }
    updateBody('');
  }

  void _applyFormattedText(String formatted) {
    jsonController.text = formatted;
    httpController.jsonBody.value = formatted;
    updateBody(formatted);
  }

  @override
  void onClose() {
    jsonController.dispose();
    xmlController.dispose();
    textController.dispose();
    graphqlQueryController.dispose();
    graphqlVariablesController.dispose();
    super.onClose();
  }
}

// --- BodyTab Main Widget ---

class BodyTab extends StatelessWidget {
  const BodyTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BodyTabController());

    return Column(
      children: [
        const _BodyTypeSelector(),
        Expanded(
          child: Obx(() {
            switch (controller.httpController.bodyType.value) {
              case 'None':
                return const _NoneBody();
              case 'JSON':
                return const _JsonBodyEditor();
              case 'XML':
                return const _XmlBodyEditor();
              case 'Text':
                return const _TextBodyEditor();
              case 'Form Data':
                return const _FormDataEditor();
              case 'GraphQL':
                return const _GraphQLBodyEditor();
              default:
                return const _NoneBody();
            }
          }),
        ),
      ],
    );
  }
}

// --- Internal Widgets ---

class _BodyTypeSelector extends GetView<BodyTabController> {
  const _BodyTypeSelector();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Obx(
        () => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['None', 'JSON', 'XML', 'Text', 'Form Data', 'GraphQL']
              .map((type) {
                final isSelected =
                    controller.httpController.bodyType.value == type;
                return ChoiceChip(
                  label: Text(
                    type,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: isSelected ? Colors.white : null,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: Theme.of(context).primaryColor,
                  checkmarkColor: Colors.white,
                  onSelected: (selected) {
                    if (selected) {
                      controller.httpController.bodyType.value = type;
                    }
                  },
                );
              })
              .toList(),
        ),
      ),
    );
  }
}

class _NoneBody extends StatelessWidget {
  const _NoneBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Body',
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

class _JsonBodyEditor extends GetView<BodyTabController> {
  const _JsonBodyEditor();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => controller.clearBody('JSON'),
                icon: const Icon(Icons.clear, size: 16),
                label: Text('Clear', style: context.textTheme.bodySmall),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => controller.formatJson(context),
                icon: const Icon(Icons.format_align_left, size: 16),
                label: Text('Format', style: context.textTheme.bodySmall),
              ),
            ],
          ),
        ),
        Obx(() {
          if (controller.jsonError.isEmpty) return const SizedBox.shrink();
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.05),
              border: Border.all(color: Colors.red.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.jsonError.value,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: () => controller.formatJson(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child:
                      const Text('Fix', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          );
        }),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller.jsonController,
              decoration: InputDecoration(
                hintText: '{\n  "key": "value"\n}',
                border: const OutlineInputBorder(),
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                filled: true,
              ),
              maxLines: null,
              expands: true,
              style: context.textTheme.bodySmall?.copyWith(
                fontFamily: 'Courier',
              ),
              onChanged: (value) {
                controller.httpController.jsonBody.value = value;
                controller.updateBody(value);
                controller.validateJson(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _XmlBodyEditor extends GetView<BodyTabController> {
  const _XmlBodyEditor();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => controller.clearBody('XML'),
                icon: const Icon(Icons.clear, size: 16),
                label: Text('Clear', style: context.textTheme.bodySmall),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller.xmlController,
              decoration: InputDecoration(
                hintText: '<root>\n  <element>value</element>\n</root>',
                border: const OutlineInputBorder(),
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                filled: true,
              ),
              maxLines: null,
              expands: true,
              style: const TextStyle(fontFamily: 'Courier', fontSize: 13),
              onChanged: (value) {
                controller.httpController.xmlBody.value = value;
                controller.updateBody(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _TextBodyEditor extends GetView<BodyTabController> {
  const _TextBodyEditor();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => controller.clearBody('Text'),
                icon: const Icon(Icons.clear, size: 16),
                label: Text('Clear', style: context.textTheme.bodySmall),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller.textController,
              decoration: InputDecoration(
                hintText: 'Enter text content...',
                border: const OutlineInputBorder(),
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                filled: true,
              ),
              maxLines: null,
              expands: true,
              style: const TextStyle(fontSize: 13),
              onChanged: (value) {
                controller.httpController.textBody.value = value;
                controller.updateBody(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _FormDataEditor extends GetView<BodyTabController> {
  const _FormDataEditor();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final httpController = controller.httpController;

    return Column(
      children: [
        _buildHeader(isDark),
        Expanded(
          child: Obx(() {
            final formData = httpController.formDataList;
            if (formData.isEmpty) {
              return Center(
                child: Text(
                  'No form data',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              );
            }
            return ListView.builder(
              itemCount: formData.length,
              itemBuilder: (context, index) {
                return _FormDataRow(
                  key: ValueKey('form_data_$index'),
                  index: index,
                  isDark: isDark,
                );
              },
            );
          }),
        ),
        _buildAddButton(isDark, httpController),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 40),
          Expanded(
            flex: 2,
            child: Text(
              'Key',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              'Value',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 100),
        ],
      ),
    );
  }

  Widget _buildAddButton(bool isDark, HttpController httpController) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => httpController.addFormData(),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Field'),
        ),
      ),
    );
  }
}

class _GraphQLBodyEditor extends GetView<BodyTabController> {
  const _GraphQLBodyEditor();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => controller.clearBody('GraphQL'),
                icon: const Icon(Icons.clear, size: 16),
                label: Text('Clear', style: context.textTheme.bodySmall),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Query',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TextField(
                    controller: controller.graphqlQueryController,
                    decoration: InputDecoration(
                      hintText: 'query {\n  user(id: 1) {\n    name\n  }\n}',
                      border: const OutlineInputBorder(),
                      fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      filled: true,
                    ),
                    maxLines: null,
                    expands: true,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontFamily: 'Courier',
                    ),
                    onChanged: (value) {
                      controller.httpController.graphqlQuery.value = value;
                      controller.updateBody(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Variables (JSON)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TextField(
                    controller: controller.graphqlVariablesController,
                    decoration: InputDecoration(
                      hintText: '{\n  "id": 1\n}',
                      border: const OutlineInputBorder(),
                      fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      filled: true,
                    ),
                    maxLines: null,
                    expands: true,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontFamily: 'Courier',
                    ),
                    onChanged: (value) =>
                        controller.httpController.graphqlVariables.value =
                            value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FormDataRow extends StatefulWidget {
  final int index;
  final bool isDark;

  const _FormDataRow({super.key, required this.index, required this.isDark});

  @override
  State<_FormDataRow> createState() => _FormDataRowState();
}

class _FormDataRowState extends State<_FormDataRow> {
  late final TextEditingController _keyController;
  late final TextEditingController _valueController;
  late final HttpController _httpController;

  @override
  void initState() {
    super.initState();
    _httpController = Get.smartFind<HttpController>();
    final field = _httpController.formDataList[widget.index];
    _keyController = TextEditingController(text: field['key'] ?? '');
    _valueController = TextEditingController(text: field['value'] ?? '');
  }

  @override
  void didUpdateWidget(_FormDataRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    final field = _httpController.formDataList[widget.index];
    if (field['key'] != _keyController.text) {
      _keyController.text = field['key'] ?? '';
    }
    if (field['value'] != _valueController.text) {
      _valueController.text = field['value'] ?? '';
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final field = _httpController.formDataList[widget.index];
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: widget.isDark ? Colors.grey[800]! : Colors.grey[200]!,
            ),
          ),
        ),
        child: Row(
          children: [
            Checkbox(
              value: field['enabled'],
              onChanged: (value) =>
                  _httpController.toggleFormData(widget.index),
            ),
            Expanded(
              flex: 2,
              child: TextField(
                controller: _keyController,
                decoration: const InputDecoration(
                  hintText: 'name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                style: const TextStyle(fontSize: 13),
                onChanged: (val) =>
                    _httpController.updateFormDataKey(widget.index, val),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: field['type'] == 'file'
                  ? ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file, size: 16),
                      label: Text(field['value'] ?? 'Choose File'),
                    )
                  : TextField(
                      controller: _valueController,
                      decoration: const InputDecoration(
                        hintText: 'value',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      style: const TextStyle(fontSize: 13),
                      onChanged: (val) =>
                          _httpController.updateFormDataValue(
                            widget.index,
                            val,
                          ),
                    ),
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: field['type'],
              items: ['text', 'file']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) =>
                  _httpController.updateFormDataType(widget.index, value!),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 18),
              color: Colors.red,
              onPressed: () => _httpController.removeFormData(widget.index),
            ),
          ],
        ),
      );
    });
  }
}
