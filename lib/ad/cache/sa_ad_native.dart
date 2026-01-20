import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:spark_ai/ad/sa_ad_loader.dart';
import 'package:spark_ai/main.dart';

import '../models/sa_ad_load_result.dart';
import '../sa_ad_cache_config.dart';
import '../sa_ad_type.dart';
import '../sa_my_ad.dart';
import '../sa_my_ad_callback.dart';

class ADNative with MyAdEventHandler {
  NativeAd? _nativeAd;
  bool _isLoadingAd = false;
  DateTime? _nativeAdLoadTime;
  Timer? _refreshTimer;
  LoadAdError? _lastLoadError;

  final loader = AdLoader();

  /// 检查广告是否已过期
  bool get isAdExpired {
    return AdCacheConfig().isAdExpired(AdType.native, _nativeAdLoadTime);
  }

  /// 检查广告是否可用
  bool get isAdAvailable {
    return _nativeAd != null && !isAdExpired;
  }

  /// 设置广告刷新定时器
  void _setupRefreshTimer() {
    _refreshTimer?.cancel();
    if (_nativeAdLoadTime != null) {
      const refreshTime = Duration(minutes: 40);
      final now = DateTime.now();
      final timeSinceLoad = now.difference(_nativeAdLoadTime!);
      if (timeSinceLoad < refreshTime) {
        final timeUntilRefresh = refreshTime - timeSinceLoad;
        _refreshTimer = Timer(timeUntilRefresh, () {
          if (!_isLoadingAd) {
            loadAd(placement: PlacementType.homelist);
          }
        });
      } else {
        loadAd(placement: PlacementType.homelist);
      }
    }
  }

  /// 加载原生广告
  Future<bool> loadAd({required PlacementType placement}) async {
    if (isAdAvailable) {
      log.d('[ad] native: 当前广告缓存可用，无需重新加载');
      return true;
    }

    if (_isLoadingAd) {
      log.d('[ad] native: 广告正在加载中，跳过本次加载请求');
      return false;
    }

    try {
      _isLoadingAd = true;
      handleAdLoadRequest(AdType.native, placement: placement);
      log.d('[ad] native: 开始加载广告');

      final completer = Completer<bool>();

      final list = MyAd().adConfig?.homelist;
      if (list == null || list.isEmpty) {
        log.d('[ad] native: 未配置广告');
        handleAdFailedToLoad(AdType.native, AdError(99, '', 'noconfig'), placement: placement);
        return false;
      }

      final sortList = list.where((e) => e.id?.isNotEmpty ?? false).toList()..sort((a, b) => (b.level ?? 0).compareTo(a.level ?? 0));

      AdLoadResult result = await AdLoader().loadAd(placement, sortList);
      _lastLoadError = result.error;

      if (result.ad != null) {
        _nativeAd = result.ad as NativeAd;
        _nativeAdLoadTime = DateTime.now();
        handleAdLoadSuccess(AdType.native, placement: placement, adid: _nativeAd!.adUnitId);
        log.d('[ad] native: 广告加载成功');
        _setupRefreshTimer();
        completer.complete(true);
      } else {
        handleAdFailedToLoad(AdType.native, _lastLoadError ?? AdError(5, '', 'timeout'), placement: placement);
        log.d('[ad] native: 所有广告加载失败');
        completer.complete(false);
      }

      return await completer.future;
    } catch (e) {
      log.d('[ad] native: 加载广告异常: $e');
      return false;
    } finally {
      _isLoadingAd = false;
    }
  }

  /// 获取当前加载的原生广告
  NativeAd? get nativeAd {
    if (_nativeAd != null) {
      handleAdShow(AdType.native, placement: PlacementType.homelist, adid: _nativeAd!.adUnitId);
    }
    return _nativeAd;
  }

  /// 释放广告资源
  void dispose() {
    _refreshTimer?.cancel();
    _nativeAd?.dispose();
    _nativeAd = null;
  }
}
