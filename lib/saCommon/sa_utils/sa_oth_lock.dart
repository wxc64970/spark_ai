import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'dart:io';

import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';

class SAOtherBlock {
  static void _log(dynamic msg) {
    log.d('[OtherCheck]: $msg');
  }

  //白名单
  static Future<(bool, String)> check() async {
    var localAllows = FirebaseRemoteConfig.instance.getString("Qw2k9X7");
    final deviceId = await SA.storage.getDeviceId();
    if (localAllows.contains(deviceId)) {
      return (true, 'whitelist');
    }

    // 判断是否所有用户走判断
    var userMode = FirebaseRemoteConfig.instance.getBool("Zn5sG1r");
    if (userMode == false) {
      return (false, 'user_mode_close');
    }

    //默认为open, 全部走判断
    var interceptMode = FirebaseRemoteConfig.instance.getBool("Kf2dM8w");
    if (interceptMode == false) {
      return (true, 'intercept_mode_close');
    }

    //判断vpn
    var listC = await Connectivity().checkConnectivity();
    if (listC.contains(ConnectivityResult.vpn) || listC.contains(ConnectivityResult.other)) {
      return (false, 'vpn_detected');
    }

    //判断是否模拟器
    bool isPhysicalDevice = true;
    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      isPhysicalDevice = iosInfo.isPhysicalDevice;
    } else if (Platform.isAndroid) {
      var androiSAnfo = await DeviceInfoPlugin().androidInfo;
      isPhysicalDevice = androiSAnfo.isPhysicalDevice;
    }

    if (!isPhysicalDevice) {
      return (false, 'simulator_detected');
    }

    //判断是否有sim卡
    var hasSim = await SASimBook.saHasSimCard();
    _log('hasSim status: $hasSim');
    if (!hasSim) {
      return (false, 'no_sim_card');
    }

    return (true, 'passed');
  }
}
