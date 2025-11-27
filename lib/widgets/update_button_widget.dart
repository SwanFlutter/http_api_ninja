import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../config/constant.dart';
import '../controller/http_controller.dart';
import '../controller/update_controller.dart';

class UpdateButtonWidget extends StatelessWidget {
  const UpdateButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final updateController = Get.find<UpdateController>();

    return Obx(() {
      final hasUpdate = updateController.updateAvailable.value;
      final isChecking = updateController.isChecking.value;

      return Stack(
        children: [
          IconButton(
            icon: isChecking
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey[400],
                    ),
                  )
                : Icon(
                    Icons.system_update_outlined,
                    size: 20,
                    color: hasUpdate ? Colors.green : Colors.grey[400],
                  ),
            onPressed: isChecking ? null : () => _checkAndShowDialog(context),
            tooltip: hasUpdate ? 'Update Available!' : 'Check for Updates',
          ),
          if (hasUpdate)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      );
    });
  }

  void _checkAndShowDialog(BuildContext context) async {
    final updateController = Get.find<UpdateController>();
    final httpController = Get.find<HttpController>();

    await updateController.checkForUpdates();

    if (!context.mounted) return;

    if (updateController.updateAvailable.value) {
      _showUpdateAvailableDialog(context, updateController, httpController);
    } else {
      _showNoUpdateDialog(context);
    }
  }

  void _showUpdateAvailableDialog(
    BuildContext context,
    UpdateController updateController,
    HttpController httpController,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.system_update, color: Colors.green),
            const SizedBox(width: AppConstants.paddingSmall),
            Text('Update Available', style: context.textTheme.titleMedium),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A new version is available!',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text('Current', style: context.textTheme.labelSmall),
                        Text(
                          'v${UpdateController.currentVersion}',
                          style: context.textTheme.titleSmall,
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward, color: Colors.grey[400]),
                    Column(
                      children: [
                        Text('Latest', style: context.textTheme.labelSmall),
                        Obx(
                          () => Text(
                            'v${updateController.latestVersion.value}',
                            style: context.textTheme.titleSmall?.copyWith(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              Text('Release Notes:', style: context.textTheme.labelLarge),
              const SizedBox(height: AppConstants.paddingSmall),
              Container(
                constraints: const BoxConstraints(maxHeight: 120),
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Obx(
                    () => Text(
                      updateController.releaseNotes.value,
                      style: context.textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Later', style: context.textTheme.labelMedium),
          ),
          ElevatedButton.icon(
            onPressed: () {
              updateController.openDownloadPage();
              Get.back();
            },
            icon: const Icon(Icons.download),
            label: Text(
              'Download',
              style: context.textTheme.labelMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNoUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: AppConstants.paddingSmall),
            Text('Up to Date', style: context.textTheme.titleMedium),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You are using the latest version.',
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              'Version ${UpdateController.currentVersion}',
              style: context.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('OK', style: context.textTheme.labelMedium),
          ),
        ],
      ),
    );
  }
}
