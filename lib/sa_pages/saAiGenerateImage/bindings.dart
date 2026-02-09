import 'package:get/get.dart';

import 'controller.dart';

class SaaigenerateimageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaaigenerateimageController>(() => SaaigenerateimageController());
  }
}
