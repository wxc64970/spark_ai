import 'package:get/get.dart';

import 'controller.dart';

class SaaigeneratehistoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaaigeneratehistoryController>(() => SaaigeneratehistoryController());
  }
}
