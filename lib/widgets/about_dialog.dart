import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/update_controller.dart';

class AppAboutDialog extends StatelessWidget {
  const AppAboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.http,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('HTTP API Ninja', style: context.textTheme.titleSmall),
              Text(
                'v${UpdateController.currentVersion}',
                style: context.textTheme.labelSmall?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Version Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Version ${UpdateController.currentVersion}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'A powerful and modern HTTP client built with Flutter',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow(context, 'Developer', 'SwanFlutter', isDark),
            const SizedBox(height: 10),
            _buildInfoRow(context, 'Framework', 'Flutter & GetX', isDark),
            const SizedBox(height: 10),
            _buildInfoRow(context, 'License', 'MIT License', isDark),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.code, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'github.com/SwanFlutter/http_api_ninja',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.open_in_new,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    onPressed: () => _openGitHub(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            showLicensePage(
              context: context,
              applicationName: 'HTTP API Ninja',
              applicationVersion: 'v${UpdateController.currentVersion}',
              applicationIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.http,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          },
          child: Text('View Licenses', style: context.textTheme.labelSmall),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Close', style: context.textTheme.labelSmall),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Future<void> _openGitHub() async {
    final uri = Uri.parse('https://github.com/SwanFlutter/http_api_ninja');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
