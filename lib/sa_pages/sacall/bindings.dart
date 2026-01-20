import 'package:get/get.dart';

import 'controller.dart';

class SacallBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SacallController>(() => SacallController());
  }
}
