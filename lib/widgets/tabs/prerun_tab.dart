import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../controller/http_controller.dart';

class PreRunTab extends StatelessWidget {
  const PreRunTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.smartFind<HttpController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Info Bar
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Write JavaScript code to run before the request',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Code Editor
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: TextEditingController(
                text: controller.preRunScript.value,
              ),
              decoration: InputDecoration(
                hintText: '''// Write JavaScript code to run before the request
// Example:
// env.set('timestamp', Date.now());
// env.set('randomId', Math.random().toString(36));
//
// Available objects:
// - env: Environment variables
// - request: Current request object
// - console: For logging''',
                border: const OutlineInputBorder(),
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: null,
              expands: true,
              style: context.textTheme.bodySmall?.copyWith(
                fontFamily: 'Courier',
              ),
              onChanged: (value) => controller.preRunScript.value = value,
            ),
          ),
        ),

        // Helper Buttons
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              ),
            ),
          ),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  controller.preRunScript.value = '''// Set timestamp
env.set('timestamp', Date.now());

// Set random ID
env.set('requestId', Math.random().toString(36).substring(7));''';
                },
                icon: const Icon(Icons.code, size: 16),
                label: Text(
                  'Insert Example',
                  style: context.textTheme.bodySmall,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  controller.preRunScript.value = '';
                },
                icon: const Icon(Icons.clear, size: 16),
                label: Text('Clear', style: context.textTheme.bodySmall),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
