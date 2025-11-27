import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../controller/http_controller.dart';

class HeadersTab extends StatelessWidget {
  const HeadersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.smartFind<HttpController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  style: context.textTheme.labelSmall?.copyWith(
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
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),

        // Headers List
        Expanded(
          child: Obx(() {
            final headersList = controller.headersList;

            if (headersList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.http, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No headers',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: headersList.length,
              itemBuilder: (context, index) {
                final header = headersList[index];
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
                        value: header['enabled'],
                        onChanged: (value) {
                          controller.toggleHeader(index);
                        },
                      ),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: TextEditingController(
                            text: header['key'],
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Header name',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          style: context.textTheme.bodySmall,
                          onChanged: (value) {
                            controller.updateHeaderKey(index, value);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: TextEditingController(
                            text: header['value'],
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Header value',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          style: context.textTheme.bodySmall,
                          onChanged: (value) {
                            controller.updateHeaderValue(index, value);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        color: Colors.red,
                        onPressed: () {
                          controller.removeHeader(index);
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
              onPressed: () => controller.addHeader(),
              icon: const Icon(Icons.add, size: 18),
              label: Text('Add Header', style: context.textTheme.bodyMedium),
            ),
          ),
        ),
      ],
    );
  }
}
