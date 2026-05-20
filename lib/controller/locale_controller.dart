import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';
import 'package:get_x_storage/get_x_storage.dart';

class LocaleController extends GetXController {
  final storage = GetXStorage();
  final Rx<Locale> currentLocale = const Locale('en', 'US').obs;

  final List<Map<String, dynamic>> supportedLocales = [
    {'code': 'en_US', 'name': 'English', 'locale': const Locale('en', 'US')},
    {'code': 'fa_IR', 'name': 'فارسی', 'locale': const Locale('fa', 'IR')},
    {'code': 'ar_SA', 'name': 'العربية', 'locale': const Locale('ar', 'SA')},
    {'code': 'de_DE', 'name': 'Deutsch', 'locale': const Locale('de', 'DE')},
    {'code': 'fr_FR', 'name': 'Français', 'locale': const Locale('fr', 'FR')},
  ];

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  void _loadLocale() {
    final savedLocale = storage.read<String>(key: 'locale');
    if (savedLocale != null) {
      final locale = supportedLocales.firstWhere(
        (l) => l['code'] == savedLocale,
        orElse: () => supportedLocales[0],
      );
      currentLocale.value = locale['locale'];
    }
  }

  void changeLocale(Locale locale) {
    currentLocale.value = locale;
    final localeCode = supportedLocales.firstWhere(
      (l) => l['locale'] == locale,
      orElse: () => supportedLocales[0],
    )['code'];
    storage.write(key: 'locale', value: localeCode);
    Get.updateLocale(locale);
  }
}
