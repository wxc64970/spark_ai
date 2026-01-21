import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'models/sa_ad_config.dart';
import 'models/sa_ad_load_result.dart';
import 'sa_ad_type.dart';

class AdLoader {
  static const Duration timeout = Duration(seconds: 30);

  Future<AdLoadResult> loadAd(PlacementType placement, List<AdData> adList) async {
    LoadAdError? lastError;
    for (final ad in adList) {
      final adUnitId = ad.id;
      if (adUnitId == null || adUnitId.isEmpty) continue;

      final type = _resolveAdType(ad); // 从 AdData 解析类型

      try {
        final result = await _loadByType(placement, type, adUnitId);
        if (result.ad != null) {
          return result;
        }
        lastError = result.error;
      } catch (e) {
        log.e('[ad] loader: 加载失败 type=$type id=$adUnitId, error=$e');
        continue;
      }
    }
    return AdLoadResult(error: lastError);
  }

  Future<AdLoadResult> _loadByType(PlacementType placement, AdType type, String adUnitId) async {
    log.d('[ad] _loadByType: placement = $placement, type=$type id=$adUnitId');
    switch (type) {
      case AdType.open:
        return await _loadAppOpenAd(adUnitId);

      case AdType.interstitial:
        return await _loadInterstitialAd(adUnitId);

      case AdType.rewarded:
        return await _loadRewardedAd(adUnitId);

      case AdType.native:
        return await _loadNativeAd(adUnitId);
    }
  }

  AdType _resolveAdType(AdData data) {
    switch (data.type?.toLowerCase()) {
      case 'open':
        return AdType.open;
      case 'rewarded':
        return AdType.rewarded;
      case 'interstitial':
        return AdType.interstitial;
      case 'native':
        return AdType.native;
      default:
        return AdType.open;
    }
  }

  Future<AdLoadResult> _loadNativeAd(String adUnitId) async {
    final completer = Completer<AdLoadResult>();

    var ad = NativeAd(
      adUnitId: adUnitId,
      factoryId: 'SAdiscoverNativeAd',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          completer.complete(AdLoadResult(ad: ad as NativeAd));
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          completer.complete(AdLoadResult(error: error));
        },
        onAdImpression: (ad) {
          log.d('[ad] native: 广告展示');
          SAlogEvent('ad_factshow', parameters: {"value": PlacementType.homelist.name});
        },
        onAdClicked: (ad) {
          log.d('[ad] native: 广告点击');
        },
        onAdClosed: (ad) {
          log.d('[ad] native: 广告关闭');
        },
        onAdOpened: (ad) {
          log.d('[ad] native: 广告打开');
        },
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {
          log.d('[ad] native: 广告收入: $valueMicros $currencyCode');
          SAAppLogEvent().logAdEvent(adid: ad.adUnitId, placement: PlacementType.homelist.name, adType: AdType.native.name, value: valueMicros, currency: currencyCode);
        },
      ),
    );

    await ad.load();

    return await completer.future;
  }

  Future<AdLoadResult> _loadAppOpenAd(String adUnitId) async {
    final completer = Completer<AdLoadResult>();

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          completer.complete(AdLoadResult(ad: ad));
        },
        onAdFailedToLoad: (error) {
          completer.complete(AdLoadResult(error: error));
        },
      ),
    );

    return await completer.future;
  }

  Future<AdLoadResult> _loadInterstitialAd(String adUnitId) async {
    final completer = Completer<AdLoadResult>();

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          completer.complete(AdLoadResult(ad: ad));
        },
        onAdFailedToLoad: (error) {
          completer.complete(AdLoadResult(error: error));
        },
      ),
    );

    return await completer.future;
  }

  Future<AdLoadResult> _loadRewardedAd(String adUnitId) async {
    final completer = Completer<AdLoadResult>();

    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          completer.complete(AdLoadResult(ad: ad));
        },
        onAdFailedToLoad: (error) {
          completer.complete(AdLoadResult(error: error));
        },
      ),
    );

    return await completer.future;
  }
}
