import 'package:get/get.dart';

import 'controller.dart';

class SaeditmaskBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaeditmaskController>(() => SaeditmaskController());
  }
}
