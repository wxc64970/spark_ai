import 'sa_ad_type.dart';

class AdCacheConfig {
  static final AdCacheConfig _instance = AdCacheConfig._internal();
  factory AdCacheConfig() => _instance;
  AdCacheConfig._internal();

  /// 默认缓存时间
  static const Duration defaultCacheDuration = Duration(minutes: 50);
  static const Duration defaultOpenCacheDuration = Duration(minutes: 230);

  /// 不同广告类型的缓存时间配置
  final Map<AdType, Duration> _cacheDurations = {AdType.open: defaultOpenCacheDuration, AdType.interstitial: defaultCacheDuration, AdType.rewarded: defaultCacheDuration};

  /// 获取指定广告类型的缓存时间
  Duration getCacheDuration(AdType type) {
    return _cacheDurations[type] ?? defaultCacheDuration;
  }

  /// 设置指定广告类型的缓存时间
  void setCacheDuration(AdType type, Duration duration) {
    _cacheDurations[type] = duration;
  }

  /// 检查广告是否过期
  bool isAdExpired(AdType type, DateTime? loadTime) {
    if (loadTime == null) return true;
    final now = DateTime.now();
    return now.difference(loadTime) > getCacheDuration(type);
  }
}
