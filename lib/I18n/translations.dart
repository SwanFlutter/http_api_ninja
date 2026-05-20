import 'package:get_x_master/get_x_master.dart';

import 'ar.dart';
import 'de.dart';
import 'en.dart';
import 'fa.dart';
import 'fr.dart';

abstract class AppTranslationsKeys {
  Map<String, String> get keys;
}

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': English().keys,
    'fa_IR': Farsi().keys,
    'ar_SA': Arabic().keys,
    'de_DE': German().keys,
    'fr_FR': French().keys,
  };
}
