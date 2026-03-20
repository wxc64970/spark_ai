import 'package:get/get.dart';

import 'controller.dart';

class SachoosevideoBinding implements Bindings {
  @override
  void dependencies() {
    // 该页面视频预览会占用较多解码资源，保持控制器常驻，避免反复销毁重建
    Get.put<SachoosevideoController>(
      SachoosevideoController(),
      permanent: true,
    );
  }
}
