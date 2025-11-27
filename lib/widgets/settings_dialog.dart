import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../I18n/messages.dart';
import '../controller/locale_controller.dart';
import '../controller/theme_controller.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.smartFind<ThemeController>();
    final localeController = Get.smartFind<LocaleController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      title: Text(Messages.settings.tr),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Messages.theme.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _buildThemeButton(
                      context: context,
                      icon: Icons.light_mode,
                      label: Messages.lightMode.tr,
                      isSelected:
                          themeController.appThemeMode.value ==
                          AvailableTheme.light,
                      onTap: () => themeController.setLight(),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildThemeButton(
                      context: context,
                      icon: Icons.dark_mode,
                      label: Messages.darkMode.tr,
                      isSelected:
                          themeController.appThemeMode.value ==
                          AvailableTheme.dark,
                      onTap: () => themeController.setDark(),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              Messages.language.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(
              () => DropdownButtonFormField<Locale>(
                initialValue: localeController.currentLocale.value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: localeController.supportedLocales
                    .map(
                      (locale) => DropdownMenuItem<Locale>(
                        value: locale['locale'],
                        child: Text(locale['name']),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    localeController.changeLocale(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Close')),
      ],
    );
  }

  Widget _buildThemeButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : (isDark ? Colors.grey[600]! : Colors.grey[400]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : null,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
