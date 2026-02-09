import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/ad/sa_my_ad.dart';
import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';

class SalaunchscreenController extends GetxController {
  SalaunchscreenController();

  double _progressValue = 0.0;
  Timer? _progressTimer;
  bool _isProgressComplete = false;
  bool isAdLoaded = false;

  _initData() {
    EasyRefresh.defaultHeaderBuilder = () =>
        const MaterialHeader(color: SAAppColors.primaryColor);
    EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(
      showText: false,
      showMessage: false,
      iconTheme: IconThemeData(color: SAAppColors.primaryColor),
    );
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
      // 检查系统语言和地区
      bool isChineseRegion = SAInfoUtils().isChineseInChina();

      // 检查时区
      bool isChinaTimeZone = await SAInfoUtils.isChinaTimeZone();

      // 检查运营商（异步）
      // bool isChineseOperator = await SAInfoUtils.isChineseCarrier();
      // if (isChineseRegion || isChinaTimeZone) {
      //   return SAToast.show("Abnormal server request,please try again later.");
      // }

      await SA.login.performRegister();

      await Future.wait([
        SALockUtils.request(isFisrt: true),
        SAPayUtils().query(),
        SAFBUtils.initializeWithRemoteConfig(),
        SA.login.loadAppLangs(),
      ]).timeout(const Duration(seconds: 7));

      await SA.login.fetchUserInfo();

      await MyAd().initAdConfig();

      var startTimer = DateTime.now().millisecondsSinceEpoch;
      // await _preloadAd().timeout(
      //   const Duration(seconds: 7),
      //   onTimeout: () {
      //     log.d('Ad preload timeout');
      //   },
      // );
      await _preloadAd();
      var endTimer = DateTime.now().millisecondsSinceEpoch;
      var adTimer = (endTimer - startTimer) / 1000;
      log.d('启动加载广告时间：$adTimer秒');

      _completeSetup();
    } catch (e) {
      log.e('Splash setup error: $e');
      _completeSetup();
    }
  }

  Future<void> _preloadAd() async {
    try {
      MyAd().preloadAds();
      isAdLoaded = await MyAd().loadOpenAd();
      // log.d('Ad preload _isAdLoaded: $_isAdLoaded');
    } catch (e) {
      isAdLoaded = false;
      log.d('Ad preload error: $e');
    }
  }

  void _completeSetup() {
    _progressValue = 1.0;
    _isProgressComplete = true;
    _progressTimer?.cancel();
    _navigateToMain();
  }

  Future<void> _navigateToMain() async {
    // 设置最多重试 20 次（每次间隔 800ms，总共约 8 秒）
    int maxRetries = 10;
    int retryCount = 0;

    // 持续尝试加载广告直到成功或达到重试限制
    while (!isAdLoaded && retryCount < maxRetries) {
      isAdLoaded = await MyAd().loadOpenAd();
      if (isAdLoaded) {
        log.d('广告加载成功，跳转主页');
        break;
      }
      retryCount++;
      if (retryCount < maxRetries) {
        await Future.delayed(const Duration(milliseconds: 700));
      }
    }

    // 无论广告是否加载成功，都跳转到主页
    log.d('广告加载完成 (成功: $isAdLoaded)，跳转到主页');
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
