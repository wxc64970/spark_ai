import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:spark_ai/saCommon/index.dart';

class SALoading {
  static Future show() async {
    await SmartDialog.showLoading(msg: "加载中...");
  }

  static void showText(String text) {
    SmartDialog.showLoading(msg: text);
  }

  static Future close() async {
    await SmartDialog.dismiss(status: SmartStatus.loading);
  }

  static CupertinoActivityIndicator activityIndicator() {
    return const CupertinoActivityIndicator(
      radius: 16.0, // 指示器大小（默认10.0）
      color: SAAppColors.primaryColor, // 颜色（默认蓝色）
    );
  }
}
