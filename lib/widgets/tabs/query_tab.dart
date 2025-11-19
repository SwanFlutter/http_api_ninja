import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../controller/http_controller.dart';

class QueryTab extends StatelessWidget {
  const QueryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HttpController>();
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
              const SizedBox(width: 40),
            ],
          ),
        ),

        // Query Parameters List
        Expanded(
          child: Obx(() {
            final params = controller.queryParams.entries.toList();

            if (params.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No query parameters',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: params.length,
              itemBuilder: (context, index) {
                final entry = params[index];
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
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: TextEditingController(text: entry.key),
                          decoration: const InputDecoration(
                            hintText: 'parameter',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          style: const TextStyle(fontSize: 13),
                          onChanged: (value) {
                            controller.updateQueryParam(
                              entry.key,
                              value,
                              entry.value,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: TextEditingController(text: entry.value),
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
                            controller.queryParams[entry.key] = value;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        color: Colors.red,
                        onPressed: () {
                          controller.removeQueryParam(entry.key);
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
              onPressed: () => controller.addQueryParam(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Parameter'),
            ),
          ),
        ),
      ],
    );
  }
}
