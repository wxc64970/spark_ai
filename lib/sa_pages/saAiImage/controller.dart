import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/saaiphoto/widgets/sa_mak_widget.dart';

class SaaiimageController extends GetxController {
  SaaiimageController();

  late SAAiViewType type;

  _initData() {
    update(["saaiimage"]);
  }

  void hanldeSku(ConsumeFrom from) {
    Get.toNamed(SARouteNames.countSku, arguments: from);
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      type = Get.arguments;
    }
  }

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
