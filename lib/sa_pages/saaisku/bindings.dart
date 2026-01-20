import 'package:get/get.dart';

import 'controller.dart';

class SaaiskuBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaaiskuController>(() => SaaiskuController());
  }
}
