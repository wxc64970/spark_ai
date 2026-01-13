import 'package:get/get.dart';

import 'controller.dart';

class SamaskBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SamaskController>(() => SamaskController());
  }
}
