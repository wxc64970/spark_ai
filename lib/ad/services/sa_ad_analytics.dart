import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';
import '../sa_ad_type.dart';

class AdAnalytics {
  // 广告点击统计
  void trackAdClick(AdType type, {PlacementType? placement}) {
    log.d('[AdAnalytics] 广告点击: $type${placement != null ? ", 广告位: ${placement.name}" : ""}');
    // logEvent('ad_click');
  }

  // 广告收入统计
  void trackAdRevenue({PlacementType? placement, required AdType type, required double value, required String currency, required String adid}) {
    log.d('[AdAnalytics] 广告收入: $type${placement != null ? ", 广告位: ${placement.name}" : ""}, 价值: $value $currency');
    SAlogEvent('ad_income', parameters: {"value": value.toString(), "currency": currency});
    SAAppLogEvent().logAdEvent(adid: adid, placement: placement?.name ?? '', adType: type.name, value: value, currency: currency);
  }

  // 激励广告奖励统计
  void trackRewardEarned(RewardItem reward, {PlacementType? placement}) {
    log.d('[AdAnalytics] 获得激励广告奖励: ${reward.amount} ${reward.type}${placement != null ? ", 广告位: ${placement.name}" : ""}');
    // logEvent('ad_reward_${placement?.name}', parameters: {"parameters": reward.amount.toString()});
  }

  // 广告开始展示统计
  void trackAdShow(AdType type, {PlacementType? placement, required String adid}) {
    log.d('[AdAnalytics] 广告开始展示: $type${placement != null ? ", 广告位: ${placement.name}" : ""}');
    SAlogEvent('ad_onshow', parameters: {"value": placement?.name ?? '', "code": adid});
    SAAppLogEvent().logAdEvent(adid: adid, placement: placement?.name ?? '', adType: type.name);
  }

  // 广告已经展示统计
  void trackAdOpened(AdType type, {PlacementType? placement, required String adid}) {
    log.d('[AdAnalytics] 广告开始展示: $type${placement != null ? ", 广告位: ${placement.name}" : ""}');
    SAlogEvent('ad_factshow', parameters: {"value": placement?.name ?? '', "code": adid});
  }

  // 广告展示失败统计
  void trackAdShowFailed(AdType type, AdError error, {PlacementType? placement, required String adid}) {
    log.d('[AdAnalytics] 广告展示失败: $type${placement != null ? ", 广告位: ${placement.name}" : ""}, 错误: ${error.message}');
    SAlogEvent('failtoshow', parameters: {"value": placement?.name ?? '', "code": "${error.code}", "msg": error.message, "type": type.name, "adid": adid});
  }

  // 广告关闭统计
  void trackAdClosed(AdType type, {PlacementType? placement}) {
    log.d('[AdAnalytics] 广告关闭: $type${placement != null ? ", 广告位: ${placement.name}" : ""}');
  }

  // 广告加载请求统计
  void trackAdLoadRequest(AdType type, {PlacementType? placement}) {
    log.d('[AdAnalytics] 广告加载请求: $type${placement != null ? ", 广告位: ${placement.name}" : ""}');
    SAlogEvent('adreq', parameters: {"value": placement?.name ?? ''});
  }

  // 广告加载成功统计
  void trackAdLoadSuccess(AdType type, {PlacementType? placement, required String adid}) {
    log.d('[AdAnalytics] 广告加载成功: $type${placement != null ? ", 广告位: ${placement.name}" : ""}');
    SAlogEvent('adreq_succ', parameters: {"value": placement?.name ?? '', "code": adid});
  }

  // 广告加载失败统计
  void trackAdLoadFailed(AdType type, AdError error, {PlacementType? placement, required String adid}) {
    log.d('[AdAnalytics] 广告加载失败: $type${placement != null ? ", 广告位: ${placement.name}" : ""}, 错误: ${error.message}');
    SAlogEvent('failadreq', parameters: {"value": placement?.name ?? '', "code": "${error.code}", "msg": error.message, "type": type.name, "ad": adid});
  }
}
