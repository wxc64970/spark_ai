import 'package:get/get.dart';

import 'controller.dart';

class SalanguageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalanguageController>(() => SalanguageController());
  }
}
