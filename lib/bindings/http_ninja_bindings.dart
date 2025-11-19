import 'package:get_x_master/get_x_master.dart';

import '../controller/http_controller.dart';
import '../controller/locale_controller.dart';
import '../controller/theme_controller.dart';

class HttpNinjaBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HttpController());
    Get.lazyPut(() => ThemeController());
    Get.lazyPut(() => LocaleController());
  }
}
