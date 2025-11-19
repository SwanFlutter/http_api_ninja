import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';
import 'package:get_x_storage/get_x_storage.dart';

class ThemeController extends GetXController {
  final storage = GetXStorage();
  final Rx<ThemeMode> themeMode = ThemeMode.dark.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = storage.read<String>(key: 'theme_mode');
    if (savedTheme != null) {
      themeMode.value = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.dark,
      );
    }
  }

  void toggleTheme() {
    themeMode.value = themeMode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    storage.write(key: 'theme_mode', value: themeMode.value.toString());
    Get.changeThemeMode(themeMode.value);
  }

  void setTheme(ThemeMode mode) {
    themeMode.value = mode;
    storage.write(key: 'theme_mode', value: mode.toString());
    Get.changeThemeMode(mode);
  }

  bool get isDark => themeMode.value == ThemeMode.dark;
}
