// import 'dart:io';
// import 'package:get/get.dart';
import 'dart:io';

import 'package:get/get_connect/connect.dart';
import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';

// import '../../main.dart';

class SALockUtils {
  static Future request({bool isFisrt = false}) async {
    if (EnvConfig.isDebugMode) {
      // 开发
      SA.storage.setIsSAB(true);
    } else {
      /// 正式
      try {
        // 并行执行平台请求和 RometeBook 检查
        final results = await Future.wait([
          // 任务1: 执行平台特定请求
          Platform.isIOS ? _requestIos() : _requestAnd(),
          // 任务2: 执行 SAOtherBlock 检查
          SAOtherBlock.check(),
        ]);

        final isSAB = SA.storage.isSAB;
        final (success, reason) = results[1] as (bool, String);

        // clock b
        if (isSAB) {
          log.d('RometeBook: $success, reason = $reason');
          final allPass = isSAB && success;
          SA.storage.setIsSAB(allPass);
          SAlogEvent(allPass ? "Yc5xL2w_B" : "Bv9gN4s_A", parameters: {"clk_status": "clk_b", "firebase_status": reason});
        } else {
          // clock a
          SAlogEvent("Bv9gN4s_A", parameters: {"clk_status": "clk_a"});
        }
      } catch (e) {
        log.e('---block---Error in requesClk: $e');
        SAlogEvent("Bv9gN4s_A", parameters: {"clk_status": "request_catch"});
      }
    }
  }

  // iOS 点击事件请求
  static Future<void> _requestIos() async {
    try {
      final deviceId = await SA.storage.getDeviceId(isOrigin: true);
      final version = await SAInfoUtils.version();
      final idfa = await SAInfoUtils.getIdfa();
      final idfv = await SAInfoUtils.getIdfv();

      final Map<String, dynamic> body = {
        'bug': EnvConfig.bundleId,
        'surgeon': 'needle',
        'alveoli': version,
        'sailboat': deviceId,
        'hit': DateTime.now().millisecondsSinceEpoch,
        'demitted': idfa,
        'twigging': idfv,
      };

      final client = GetConnect(timeout: const Duration(seconds: 60));

      final response = await client.post('https://knuckle.sparkaiweb.com/forlorn/albumin', body);
      log.i('Response: $body\n ${response.body}');

      var clkStatus = false;
      if (response.isOk && response.body == 'biggs') {
        clkStatus = true;
      }
      await SA.storage.setBool(SAAppConstants.keyClkStatus, clkStatus);
    } catch (e) {
      log.e('Error in _requestIosClk: $e');
    }
  }

  static Future<void> _requestAnd() async {}
}
