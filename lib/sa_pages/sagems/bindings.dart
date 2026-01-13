import 'package:get/get.dart';

import 'controller.dart';

class SagemsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SagemsController>(() => SagemsController());
  }
}
