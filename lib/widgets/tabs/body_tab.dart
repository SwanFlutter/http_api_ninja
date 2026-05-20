import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../controller/http_controller.dart';

class BodyTab extends StatefulWidget {
  const BodyTab({super.key});

  @override
  State<BodyTab> createState() => _BodyTabState();
}

class _BodyTabState extends State<BodyTab> {
  late final HttpController _controller;
  late final TextEditingController _jsonController;
  late final TextEditingController _xmlController;
  late final TextEditingController _textController;
  late final TextEditingController _graphqlQueryController;
  late final TextEditingController _graphqlVariablesController;

  @override
  void initState() {
    super.initState();
    _controller = Get.smartFind<HttpController>();
    _jsonController = TextEditingController(text: _controller.body.value);
    _xmlController = TextEditingController(text: _controller.body.value);
    _textController = TextEditingController(text: _controller.body.value);
    _graphqlQueryController = TextEditingController();
    _graphqlVariablesController = TextEditingController();

    // Sync controller body changes to text controllers
    ever(_controller.body, (value) {
      if (_jsonController.text != value) {
        _jsonController.text = value;
      }
      if (_xmlController.text != value) {
        _xmlController.text = value;
      }
      if (_textController.text != value) {
        _textController.text = value;
      }
    });
  }

  @override
  void dispose() {
    _jsonController.dispose();
    _xmlController.dispose();
    _textController.dispose();
    _graphqlQueryController.dispose();
    _graphqlVariablesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Body Type Selector
        Container(
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
                    final isSelected = _controller.bodyType.value == type;
                    return ChoiceChip(
                      label: Text(type, style: context.textTheme.labelMedium),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          _controller.bodyType.value = type;
                        }
                      },
                    );
                  })
                  .toList(),
            ),
          ),
        ),

        // Body Content
        Expanded(
          child: Obx(() {
            switch (_controller.bodyType.value) {
              case 'None':
                return _buildNoneBody();
              case 'JSON':
                return _buildJsonBody(isDark);
              case 'XML':
                return _buildXmlBody(isDark);
              case 'Text':
                return _buildTextBody(isDark);
              case 'Form Data':
                return _buildFormDataBody(isDark);
              case 'GraphQL':
                return _buildGraphQLBody(isDark);
              default:
                return _buildNoneBody();
            }
          }),
        ),
      ],
    );
  }

  Widget _buildNoneBody() {
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

  Widget _buildJsonBody(bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  try {
                    final formatted = const JsonEncoder.withIndent(
                      '  ',
                    ).convert(jsonDecode(_jsonController.text));
                    _jsonController.text = formatted;
                    _controller.body.value = formatted;
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid JSON format'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.format_align_left, size: 16),
                label: Text('Format', style: context.textTheme.bodySmall),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _jsonController,
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
              onChanged: (value) => _controller.body.value = value,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildXmlBody(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _xmlController,
        decoration: InputDecoration(
          hintText: '<root>\n  <element>value</element>\n</root>',
          border: const OutlineInputBorder(),
          fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          filled: true,
        ),
        maxLines: null,
        expands: true,
        style: const TextStyle(fontFamily: 'Courier', fontSize: 13),
        onChanged: (value) => _controller.body.value = value,
      ),
    );
  }

  Widget _buildTextBody(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          hintText: 'Enter text content...',
          border: const OutlineInputBorder(),
          fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          filled: true,
        ),
        maxLines: null,
        expands: true,
        style: const TextStyle(fontSize: 13),
        onChanged: (value) => _controller.body.value = value,
      ),
    );
  }

  Widget _buildFormDataBody(bool isDark) {
    return Column(
      children: [
        // Header
        Container(
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
        ),

        // Form Fields List
        Expanded(
          child: Obx(() {
            final formData = _controller.formDataList;

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
                final field = formData[index];
                return _FormDataRow(
                  key: ValueKey('form_data_$index'),
                  field: field,
                  isDark: isDark,
                  onToggle: () => _controller.toggleFormData(index),
                  onKeyChanged: (value) =>
                      _controller.updateFormDataKey(index, value),
                  onValueChanged: (value) =>
                      _controller.updateFormDataValue(index, value),
                  onTypeChanged: (value) =>
                      _controller.updateFormDataType(index, value),
                  onDelete: () => _controller.removeFormData(index),
                );
              },
            );
          }),
        ),

        // Add Button
        Container(
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
              onPressed: () => _controller.addFormData(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Field'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGraphQLBody(bool isDark) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                    controller: _graphqlQueryController,
                    decoration: InputDecoration(
                      hintText: 'query {\n  user(id: 1) {\n    name\n  }\n}',
                      border: const OutlineInputBorder(),
                      fillColor: isDark
                          ? const Color(0xFF1E1E1E)
                          : Colors.white,
                      filled: true,
                    ),
                    maxLines: null,
                    expands: true,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                    controller: _graphqlVariablesController,
                    decoration: InputDecoration(
                      hintText: '{\n  "id": 1\n}',
                      border: const OutlineInputBorder(),
                      fillColor: isDark
                          ? const Color(0xFF1E1E1E)
                          : Colors.white,
                      filled: true,
                    ),
                    maxLines: null,
                    expands: true,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontFamily: 'Courier',
                    ),
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

/// Separate StatefulWidget for FormData rows to maintain their own TextEditingControllers
class _FormDataRow extends StatefulWidget {
  final Map<String, dynamic> field;
  final bool isDark;
  final VoidCallback onToggle;
  final ValueChanged<String> onKeyChanged;
  final ValueChanged<String> onValueChanged;
  final ValueChanged<String> onTypeChanged;
  final VoidCallback onDelete;

  const _FormDataRow({
    super.key,
    required this.field,
    required this.isDark,
    required this.onToggle,
    required this.onKeyChanged,
    required this.onValueChanged,
    required this.onTypeChanged,
    required this.onDelete,
  });

  @override
  State<_FormDataRow> createState() => _FormDataRowState();
}

class _FormDataRowState extends State<_FormDataRow> {
  late final TextEditingController _keyController;
  late final TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(text: widget.field['key'] ?? '');
    _valueController = TextEditingController(text: widget.field['value'] ?? '');
  }

  @override
  void didUpdateWidget(_FormDataRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controllers if the field data changed externally
    if (widget.field['key'] != _keyController.text) {
      _keyController.text = widget.field['key'] ?? '';
    }
    if (widget.field['value'] != _valueController.text) {
      _valueController.text = widget.field['value'] ?? '';
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
            value: widget.field['enabled'],
            onChanged: (value) => widget.onToggle(),
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
              onChanged: widget.onKeyChanged,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: widget.field['type'] == 'file'
                ? ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.attach_file, size: 16),
                    label: Text(widget.field['value'] ?? 'Choose File'),
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
                    onChanged: widget.onValueChanged,
                  ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: widget.field['type'],
            items: [
              'text',
              'file',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) => widget.onTypeChanged(value!),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 18),
            color: Colors.red,
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}
