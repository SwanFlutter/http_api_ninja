import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../I18n/messages.dart';
import '../controller/locale_controller.dart';
import '../controller/theme_controller.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localeController = Get.find<LocaleController>();

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
                    child: RadioListTile<ThemeMode>(
                      title: Text(Messages.lightMode.tr),
                      value: ThemeMode.light,
                      groupValue: themeController.themeMode.value,
                      onChanged: (value) => themeController.setTheme(value!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<ThemeMode>(
                      title: Text(Messages.darkMode.tr),
                      value: ThemeMode.dark,
                      groupValue: themeController.themeMode.value,
                      onChanged: (value) => themeController.setTheme(value!),
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
                value: localeController.currentLocale.value,
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
}
