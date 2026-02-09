import 'package:get/get.dart';

import 'controller.dart';

class SaaigenerateresultBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaaigenerateresultController>(() => SaaigenerateresultController());
  }
}
