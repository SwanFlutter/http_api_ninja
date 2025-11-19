import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';
import 'package:get_x_storage/get_x_storage.dart';

import 'I18n/translations.dart';
import 'bindings/http_ninja_bindings.dart';
import 'theme/theme.dart';
import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetXStorage.init();
  runApp(const HttpApiNinjaApp());
}

class HttpApiNinjaApp extends StatelessWidget {
  const HttpApiNinjaApp({super.key});

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
      themeMode: ThemeMode.dark,
      initialBinding: HttpNinjaBindings(),
      home: const HomeView(),
    );
  }
}
