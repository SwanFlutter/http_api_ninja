import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../controller/http_controller.dart';
import 'response_empty_state.dart';

class ResponseResultsTab extends StatelessWidget {
  final HttpController controller;
  final bool isDark;

  const ResponseResultsTab({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.testsList.isEmpty) {
      return const ResponseEmptyState(
        icon: Icons.check_circle_outline,
        message: 'No tests defined',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.testsList.length,
      itemBuilder: (context, index) {
        final test = controller.testsList[index];
        return _buildTestItem(context, test);
      },
    );
  }

  Widget _buildTestItem(BuildContext context, Map<String, dynamic> test) {
    // TOD O: Implement actual test logic based on response
    final passed = test['passed'] as bool? ?? true;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: passed
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        border: Border.all(color: passed ? Colors.green : Colors.red),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(
            passed ? Icons.check_circle : Icons.cancel,
            color: passed ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${test['condition']} ${test['operator']} ${test['value']}',
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  passed ? 'Test passed' : 'Test failed',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
