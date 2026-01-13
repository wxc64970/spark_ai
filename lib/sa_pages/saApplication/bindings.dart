import 'package:get/get.dart';

import 'controller.dart';

class SaapplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaapplicationController>(() => SaapplicationController());
  }
}
