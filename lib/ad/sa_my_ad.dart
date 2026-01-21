// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:convert';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:spark_ai/ad/cache/sa_ad_native.dart';
import 'package:spark_ai/ad/sa_ad_type.dart';
import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'models/sa_ad_config.dart';
import 'sa_app_lifecycle_reactor.dart';
import 'sa_my_ad_callback.dart';

class MyAd {
  static final MyAd _instance = MyAd._internal();
  factory MyAd() => _instance;

  MyAd._internal() {
    _initManagers();
  }

  // 开屏广告管理
  // final ADOpen _openAd = ADOpen();
  // ADOpen get openAd => _openAd;

  // 插页广告管理
  // final ADChat _chatAd = ADChat();
  // 激励广告管理
  // final ADGems _gemsAd = ADGems();
  // 原生广告管理
  final ADNative _nativeAd = ADNative();
  final isVip = SA.login.vipStatus.value;

  // 应用生命周期监听
  late final AppLifecycleReactor _appLifecycleReactor = AppLifecycleReactor();
  // AppLifecycleReactor getter
  AppLifecycleReactor get appLifecycleReactor => _appLifecycleReactor;
  // 广告事件回调
  MyAdCallback adEventCallback = const MyAdCallback();

  void _initManagers() {
    // 初始化各个广告管理器的事件回调
    // _openAd.setAdEventCallback(adEventCallback);
    // _chatAd.setAdEventCallback(adEventCallback);
    // _gemsAd.setAdEventCallback(adEventCallback);
    _nativeAd.setAdEventCallback(adEventCallback);
    // 初始化应用生命周期监听
    appLifecycleReactor.listenToAppStateChanges();
  }

  /// 广告 cd 时间配置 默认 120s
  int minDisplayTime = 120000;

  /// 全屏广告展示时间
  // int _fullScreenAdShowTime = 0;

  /// 是否有全屏广告正在展示
  // bool _isFullScreenAdShowing = false;

  /// 更新广告展示时间
  // Future<void> updateFullScreenAdShowTime(String timeKey) async {
  //   // if (timeKey.isEmpty) return;
  //   // final prefs = await SharedPreferences.getInstance();
  //   // await prefs.setInt(timeKey, DateTime.now().millisecondsSinceEpoch);
  //   _fullScreenAdShowTime = DateTime.now().millisecondsSinceEpoch;
  //   _isFullScreenAdShowing = false;
  // }

  /// 设置全屏广告正在展示
  // void setFullScreenAdShowing(bool isShowing) {
  //   _isFullScreenAdShowing = isShowing;
  // }

  /// 检查是否可以展示全屏广告
  // Future<bool> _canShowAd(PlacementType placement) async {
  //   // if (timeKey.isEmpty) return true;
  //   // final prefs = await SharedPreferences.getInstance();
  //   // final lastShowTime = prefs.getInt(timeKey) ?? 0;
  //   // final currentTime = DateTime.now().millisecondsSinceEpoch;
  //   // final timeDiff = currentTime - lastShowTime;
  //   // final res = timeDiff >= minDisplayTime;
  //   // log.d('[ad] 广告时间检查: $timeKey, 时间差 $timeDiff ms, 是否显示: $res');
  //   // return res;

  //   if (_isFullScreenAdShowing) {
  //     log.d('[ad] 有全屏广告正在展示中，跳过本次广告展示');
  //     return false;
  //   }

  //   final currentTime = DateTime.now().millisecondsSinceEpoch;
  //   final timeDiff = currentTime - _fullScreenAdShowTime;
  //   final res = timeDiff >= minDisplayTime;
  //   log.d('[ad] 广告时间检查: ${placement.timeKey}, 时间差 $timeDiff ms, 是否显示: $res');
  //   return res;
  // }

  /// 广告配置
  AdConfig? adConfig;

  Future<void> initAdConfig() async {
    String? adConfigStr = SAThirdPartyService.adConfig;

    Map<String, dynamic> jsonMap = {};

    if (adConfigStr != null && adConfigStr.isNotEmpty) {
      jsonMap = jsonDecode(adConfigStr);
    } else {
      jsonMap = EnvConfig.isDebugMode
          ? {
              "interval": 15,
              "homelist": [
                {"source": "admob", "level": 0, "type": "native", "id": "ca-app-pub-3940256099942544/3986624511"},
              ],
            }
          : {
              "interval": 15,
              "homelist": [
                {"source": "admob", "level": 0, "type": "native", "id": "ca-app-pub-2215944226039228/3818295153"},
              ],
            };
      ;
    }

    adConfig = AdConfig.fromJson(jsonMap);
    var interval = adConfig?.interval;
    if (interval != null && interval > 0) {
      minDisplayTime = interval * 1000;
    }
  }

  Future<bool> loadOpenAd() async {
    if (isVip) {
      return false;
    }
    if (adConfig == null) {
      await initAdConfig();
    }
    if (adConfig?.homelist == null || adConfig?.homelist?.isEmpty == true) {
      log.d('[ad] AdConfig: 原生广告配置为空');
      return false;
    }
    return await _nativeAd.loadAd(placement: PlacementType.open);
  }

  // Future<bool> showOpenAd() async {
  //   if (isVip) {
  //     return false;
  //   }
  //   log.d('[ad] AppOpenAd: 开始检查是否可以展示广告');
  //   if (!await _canShowAd(PlacementType.open)) {
  //     log.d('[ad] AppOpenAd: 广告展示时间间隔不足，跳过展示');
  //     return false;
  //   }
  //   try {
  //     final reslut = await _openAd.showAdIfAvailable();
  //     return reslut;
  //   } catch (e, stackTrace) {
  //     log.d('[ad] AppOpenAd catch : 广告展示失败: $e stackTrace: $stackTrace');
  //     return false;
  //   }
  // }

  // Future<void> loadChatAd({required PlacementType placement}) async {
  //   if (AccountUtil().isVip.value) {
  //     return;
  //   }
  //   await _chatAd.loadAd(placement: placement);
  // }

  // Future<bool> showChatAd({required PlacementType placement}) async {
  //   if (AccountUtil().isVip.value) {
  //     return false;
  //   }
  //   if (!await _canShowAd(placement)) return false;
  //   if (!_chatAd.isAdAvailable) {
  //     _chatAd.loadAd(placement: placement);
  //     await Future.delayed(const Duration(seconds: 1));
  //   }
  //   try {
  //     final result = await _chatAd.showAdIfAvailable(placement);
  //     if (result) {
  //       loadChatAd(placement: placement); // 预加载下一个广告
  //     }
  //     return result;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // 激励广告
  // Future<void> loadGemsAd({required PlacementType placement}) async {
  //   await _gemsAd.loadAd(placement: placement);
  // }

  // Future<bool> showGemsAd({required PlacementType placement}) async {
  //   try {
  //     final result = await _gemsAd.showAdIfAvailable();
  //     return result;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // 原生广告
  Future<bool> loadNativeAd({required PlacementType placement}) async {
    if (isVip) {
      return false;
    }
    return await _nativeAd.loadAd(placement: placement);
  }

  NativeAd? get nativeAd => _nativeAd.nativeAd;

  /// 预加载所有类型的广告
  Future<void> preloadAds() async {
    if (isVip) {
      return;
    }
    log.d('[ad] 开始预加载所有类型的广告');
    try {
      await loadNativeAd(placement: PlacementType.open);
      // await Future.wait([loadChatAd(placement: PlacementType.open), loadGemsAd(placement: PlacementType.open), loadNativeAd(placement: PlacementType.open)]);
      log.d('[ad] 所有类型广告预加载完成');
    } catch (e) {
      log.d('[ad] 广告预加载失败: $e');
    }
  }

  /// 释放所有广告资源
  void dispose() {
    // _openAd.dispose();
    // _chatAd.dispose();
    // _gemsAd.dispose();
    _nativeAd.dispose();
  }
}
