import 'package:get/get.dart';

import 'controller.dart';

class SaundrBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaundrController>(() => SaundrController());
  }
}
