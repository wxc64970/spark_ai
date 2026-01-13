import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';

class SalaunchscreenController extends GetxController {
  SalaunchscreenController();

  double _progressValue = 0.0;
  Timer? _progressTimer;
  bool _isProgressComplete = false;

  _initData() {
    EasyRefresh.defaultHeaderBuilder = () => const MaterialHeader(color: SAAppColors.primaryColor);
    EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(showText: false, showMessage: false, iconTheme: IconThemeData(color: SAAppColors.primaryColor));
    if (SA.network.isConnected) {
      setup();
    } else {
      SA.network.waitForConnection().then((v) {
        setup();
      });
    }
    update(["salaunchscreen"]);
  }

  Future<void> setup() async {
    try {
      await SAInfoUtils.getIdfa();

      // 启动进度条动画
      _startProgressAnimation();

      await SA.login.performRegister();

      await Future.wait([SALockUtils.request(isFisrt: true), SAPayUtils().query(), SAFBUtils.initializeWithRemoteConfig(), SA.login.loadAppLangs()]).timeout(const Duration(seconds: 7));

      await SA.login.fetchUserInfo();

      _completeSetup();
    } catch (e) {
      log.e('Splash setup error: $e');
      _completeSetup();
    }
  }

  void _completeSetup() {
    _progressValue = 1.0;
    _isProgressComplete = true;
    _progressTimer?.cancel();
    _navigateToMain();
  }

  Future<void> _navigateToMain() async {
    Get.offAllNamed(SARouteNames.application);
  }

  void _startProgressAnimation() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_progressValue < 0.5) {
        _progressValue += 0.02;
      } else if (_progressValue < 0.9) {
        _progressValue += 0.01;
      } else if (!_isProgressComplete) {
        _progressValue += 0.001;
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }
}
