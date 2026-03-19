import 'package:get/get.dart';

import 'controller.dart';

class SachoosevideoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SachoosevideoController>(() => SachoosevideoController());
  }
}
