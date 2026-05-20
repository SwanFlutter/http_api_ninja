import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';
import 'package:get_x_storage/get_x_storage.dart';

import 'I18n/translations.dart';
import 'bindings/http_ninja_bindings.dart';
import 'controller/theme_controller.dart';
import 'theme/theme.dart';
import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetXStorage.init();

  // Initialize ThemeController and load saved theme
  final themeController = Get.put(ThemeController());
  final savedThemeMode = themeController.loadSavedTheme();

  runApp(HttpApiNinjaApp(initialThemeMode: savedThemeMode));
}

class HttpApiNinjaApp extends StatelessWidget {
  final ThemeMode initialThemeMode;

  const HttpApiNinjaApp({super.key, required this.initialThemeMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HTTP API Ninja',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: initialThemeMode,
      initialBinding: HttpNinjaBindings(),
      home: const HomeView(),
    );
  }
}
