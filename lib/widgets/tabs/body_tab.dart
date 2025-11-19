import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../controller/http_controller.dart';

class BodyTab extends StatelessWidget {
  const BodyTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HttpController>();
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
                    final isSelected = controller.bodyType.value == type;
                    return ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          controller.bodyType.value = type;
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
            switch (controller.bodyType.value) {
              case 'None':
                return _buildNoneBody();
              case 'JSON':
                return _buildJsonBody(controller, isDark);
              case 'XML':
                return _buildXmlBody(controller, isDark);
              case 'Text':
                return _buildTextBody(controller, isDark);
              case 'Form Data':
                return _buildFormDataBody(controller, isDark);
              case 'GraphQL':
                return _buildGraphQLBody(controller, isDark);
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
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildJsonBody(HttpController controller, bool isDark) {
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
                    ).convert(jsonDecode(controller.body.value));
                    controller.body.value = formatted;
                  } catch (e) {
                    Get.snackbar('Error', 'Invalid JSON format');
                  }
                },
                icon: const Icon(Icons.format_align_left, size: 16),
                label: const Text('Format'),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: TextEditingController(text: controller.body.value),
              decoration: InputDecoration(
                hintText: '{\n  "key": "value"\n}',
                border: const OutlineInputBorder(),
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                filled: true,
              ),
              maxLines: null,
              expands: true,
              style: const TextStyle(fontFamily: 'Courier', fontSize: 13),
              onChanged: (value) => controller.body.value = value,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildXmlBody(HttpController controller, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: TextEditingController(text: controller.body.value),
        decoration: InputDecoration(
          hintText: '<root>\n  <element>value</element>\n</root>',
          border: const OutlineInputBorder(),
          fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          filled: true,
        ),
        maxLines: null,
        expands: true,
        style: const TextStyle(fontFamily: 'Courier', fontSize: 13),
        onChanged: (value) => controller.body.value = value,
      ),
    );
  }

  Widget _buildTextBody(HttpController controller, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: TextEditingController(text: controller.body.value),
        decoration: InputDecoration(
          hintText: 'Enter text content...',
          border: const OutlineInputBorder(),
          fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          filled: true,
        ),
        maxLines: null,
        expands: true,
        style: const TextStyle(fontSize: 13),
        onChanged: (value) => controller.body.value = value,
      ),
    );
  }

  Widget _buildFormDataBody(HttpController controller, bool isDark) {
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
            final formData = controller.formDataList;

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
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: field['enabled'],
                        onChanged: (value) {
                          controller.toggleFormData(index);
                        },
                      ),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: TextEditingController(text: field['key']),
                          decoration: const InputDecoration(
                            hintText: 'name',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          style: const TextStyle(fontSize: 13),
                          onChanged: (value) {
                            controller.updateFormDataKey(index, value);
                          },
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
                                controller: TextEditingController(
                                  text: field['value'],
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'value',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                style: const TextStyle(fontSize: 13),
                                onChanged: (value) {
                                  controller.updateFormDataValue(index, value);
                                },
                              ),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: field['type'],
                        items: ['text', 'file']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) {
                          controller.updateFormDataType(index, value!);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        color: Colors.red,
                        onPressed: () {
                          controller.removeFormData(index);
                        },
                      ),
                    ],
                  ),
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
              onPressed: () => controller.addFormData(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Field'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGraphQLBody(HttpController controller, bool isDark) {
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
                    style: const TextStyle(fontFamily: 'Courier', fontSize: 13),
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
                    style: const TextStyle(fontFamily: 'Courier', fontSize: 13),
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
