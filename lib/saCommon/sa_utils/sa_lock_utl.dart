// import 'dart:io';
// import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

// import '../../main.dart';

class SALockUtils {
  static Future request({bool isFisrt = false}) async {
    if (EnvConfig.isDebugMode) {
      // 开发
      SA.storage.setIsSAB(false);
    } else {
      SA.storage.setIsSAB(false);
    }
  }

  // iOS 点击事件请求
  // static Future<void> _requestIos() async {}

  // static Future<void> _requestAnd() async {}
}
