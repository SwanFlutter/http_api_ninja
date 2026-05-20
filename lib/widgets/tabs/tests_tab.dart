import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../controller/http_controller.dart';

class TestsTab extends StatelessWidget {
  const TestsTab({super.key});

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
              Expanded(
                flex: 2,
                child: Text(
                  'Condition',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Text(
                  'Operator',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Text(
                  'Expected Value',
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

        // Tests List
        Expanded(
          child: Obx(() {
            final tests = controller.testsList;

            if (tests.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No tests defined',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: tests.length,
              itemBuilder: (context, index) {
                final test = tests[index];
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
                        child: DropdownButtonFormField<String>(
                          initialValue: test['condition'],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items:
                              [
                                    'Status Code',
                                    'Response Time',
                                    'Response Body',
                                    'Header Contains',
                                    'JSON Path',
                                  ]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: context.textTheme.bodySmall,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            controller.updateTestCondition(index, value!);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          initialValue: test['operator'],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items:
                              [
                                    'equals',
                                    'not equals',
                                    'contains',
                                    'greater than',
                                    'less than',
                                  ]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: context.textTheme.bodySmall,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            controller.updateTestOperator(index, value!);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: TextEditingController(
                            text: test['value'],
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Expected value',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          style: context.textTheme.bodySmall,
                          onChanged: (value) {
                            controller.updateTestValue(index, value);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        color: Colors.red,
                        onPressed: () {
                          controller.removeTest(index);
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
              onPressed: () => controller.addTest(),
              icon: const Icon(Icons.add, size: 18),
              label: Text('Add Test', style: context.textTheme.bodyMedium),
            ),
          ),
        ),
      ],
    );
  }
}
