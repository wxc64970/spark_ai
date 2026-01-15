import 'package:get/get.dart';

class SaaiphotoController extends GetxController {
  SaaiphotoController();

  _initData() {
    update(["saaiphoto"]);
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
