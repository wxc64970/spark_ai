import 'package:get/get.dart';

import 'controller.dart';

class SaprofileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaprofileController>(() => SaprofileController());
  }
}
