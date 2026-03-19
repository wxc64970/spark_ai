import 'package:get/get.dart';

import 'controller.dart';

class SatexttoimageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SatexttoimageController>(() => SatexttoimageController());
  }
}
