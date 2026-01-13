import 'package:get/get.dart';

import 'controller.dart';

class SasubscribeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SasubscribeController>(() => SasubscribeController());
  }
}
