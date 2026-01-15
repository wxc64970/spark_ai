import 'package:get/get.dart';

class SamomentsController extends GetxController {
  SamomentsController();

  _initData() {
    update(["samoments"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
