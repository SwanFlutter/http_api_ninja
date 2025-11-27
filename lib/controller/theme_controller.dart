import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';
import 'package:get_x_storage/get_x_storage.dart';

enum AvailableTheme { light, dark, system }

class ThemeController extends GetXController {
  var appThemeMode = AvailableTheme.dark.obs;
  final _storage = GetXStorage();

  // Load saved theme and return ThemeMode
  ThemeMode loadSavedTheme() {
    String? savedTheme = _storage.read(key: 'theme');

    if (savedTheme != null) {
      switch (savedTheme) {
        case 'light':
          appThemeMode.value = AvailableTheme.light;
          return ThemeMode.light;
        case 'dark':
          appThemeMode.value = AvailableTheme.dark;
          return ThemeMode.dark;
        case 'system':
          appThemeMode.value = AvailableTheme.system;
          return ThemeMode.system;
      }
    }

    // Default to dark
    appThemeMode.value = AvailableTheme.dark;
    return ThemeMode.dark;
  }

  void setLight() {
    appThemeMode.value = AvailableTheme.light;
    _storage.write(key: 'theme', value: 'light');
    Get.changeThemeMode(ThemeMode.light);
  }

  void setDark() {
    appThemeMode.value = AvailableTheme.dark;
    _storage.write(key: 'theme', value: 'dark');
    Get.changeThemeMode(ThemeMode.dark);
  }

  void setSystem() {
    appThemeMode.value = AvailableTheme.system;
    _storage.write(key: 'theme', value: 'system');
    Get.changeThemeMode(ThemeMode.system);
  }

  // Getter for checking if dark mode is active
  bool get isDark => appThemeMode.value == AvailableTheme.dark;

  // Getter for ThemeMode
  ThemeMode get themeMode {
    switch (appThemeMode.value) {
      case AvailableTheme.light:
        return ThemeMode.light;
      case AvailableTheme.dark:
        return ThemeMode.dark;
      case AvailableTheme.system:
        return ThemeMode.system;
    }
  }

  // Set theme by ThemeMode
  void setTheme(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        setLight();
        break;
      case ThemeMode.dark:
        setDark();
        break;
      case ThemeMode.system:
        setSystem();
        break;
    }
  }
}
