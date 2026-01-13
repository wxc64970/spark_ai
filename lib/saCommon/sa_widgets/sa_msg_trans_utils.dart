import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

class SAMessageTransUtils {
  static final SAMessageTransUtils _instance = SAMessageTransUtils._internal();

  factory SAMessageTransUtils() => _instance;

  SAMessageTransUtils._internal();

  int _clickCount = 0; // 点击次数
  DateTime? _firstClickTime; // 第一次点击的时间

  bool shouldShowDialog() {
    final now = DateTime.now();

    if (_firstClickTime == null || now.difference(_firstClickTime!).inMinutes > 1) {
      // 超过1分钟，重置计数器
      _firstClickTime = now;
      _clickCount = 1;
      return false;
    }

    _clickCount += 1;

    if (_clickCount >= 3) {
      _clickCount = 0; // 重置计数
      return true;
    }

    return false;
  }

  Future<void> handleTranslationClick() async {
    final hasShownDialog = SA.storage.hasShownTranslationDialog;

    if (SAMessageTransUtils().shouldShowDialog() && !hasShownDialog && !SA.login.vipStatus.value) {
      // 弹出提示弹窗
      showTranslationDialog();

      SA.storage.setShownTranslationDialog(true);
    }
  }

  void showTranslationDialog() {
    DialogWidget.alert(
      message: SATextData.autoTrans,
      confirmText: SATextData.confirm,
      onConfirm: () {
        SmartDialog.dismiss();
        toVip();
      },
    );
  }

  void toVip() {
    Get.toNamed(SARouteNames.vip, arguments: VipFrom.trans);
  }
}
