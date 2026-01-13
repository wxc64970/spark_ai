import 'package:get/get.dart';

import 'controller.dart';

class SasearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SasearchController>(() => SasearchController());
  }
}
