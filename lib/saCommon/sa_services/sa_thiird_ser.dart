import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:spark_ai/saCommon/index.dart';
import '../../main.dart';

class SAThirdPartyService {
  SAThirdPartyService._();

  // Firebase 初始化状态
  static bool isFirebaseInitialized = false;

  // Remote Config 配置值
  static int maxFreeChatCount = 50;
  static int showClothingCount = 5;

  static String? adConfig;

  /// 初始化所有第三方服务
  static Future<void> init() async {
    // Firebase 初始化（如果失败会抛出异常）
    try {
      await _initFirebase();
    } catch (e) {
      // 如果是网络错误，重新抛出以阻止应用启动
      if (e.toString().contains('Network connection required')) {
        log.e('[ThirdParty]: 网络连接失败，无法启动应用');
        rethrow;
      }
      // 其他 Firebase 错误不影响启动
      log.e('[ThirdParty]: Firebase 初始化失败，但不影响启动: $e');
    }

    // Adjust 初始化（失败不影响启动）
    try {
      await _initAdjust();
    } catch (e) {
      log.e('[ThirdParty]: Adjust 初始化失败，但不影响启动: $e');
    }
  }

  /// Adjust 初始化
  static Future<void> _initAdjust() async {
    try {
      final storage = Get.find<SALocalStorage>();
      String deviceId = await storage.getDeviceId(isOrigin: true);
      String appToken = EnvConfig.adJustId;
      AdjustEnvironment env = AdjustEnvironment.production;

      AdjustConfig config = AdjustConfig(appToken, env)
        ..logLevel = AdjustLogLevel.error
        ..externalDeviceId = deviceId;

      Adjust.initSdk(config);
      log.d('[Adjust]: initializing ✅');
    } catch (e) {
      log.e('[Adjust] catch: $e');
    }
  }

  /// Firebase 初始化
  static Future<void> _initFirebase() async {
    try {
      // 检查网络连接状态
      try {
        final networkService = Get.find<SANetworkMonitorService>();

        if (!networkService.isConnected) {
          log.w('[Firebase]: 网络未连接，等待网络连接...');
          // 等待网络连接，最多等待10秒
          final hasNetwork = await networkService.waitForConnection(
            timeout: const Duration(seconds: 10),
          );

          if (!hasNetwork) {
            log.e('[Firebase]: 网络连接失败，无法继续初始化');
            // 抛出网络错误，阻止应用继续运行
            throw Exception('Network connection required. Please check your internet connection and try again.');
          }
        }

        log.d('[Firebase]: 网络已连接，开始初始化...');
      } catch (e) {
        // 如果是网络错误，重新抛出
        if (e.toString().contains('Network connection required')) {
          rethrow;
        }
        // 如果获取网络服务失败，继续尝试初始化 Firebase
        log.w('[Firebase]: 无法获取网络服务状态，继续尝试初始化: $e');
      }

      // 在 release 模式下，添加短暂延迟确保网络准备就绪
      await Future.delayed(const Duration(milliseconds: 500));

      FirebaseApp app = await Firebase.initializeApp();
      isFirebaseInitialized = true;
      log.d('[Firebase]: Initialized ✅ app: ${app.name}');

      // 分步初始化Firebase服务，确保核心服务先启动
      _initFirebaseAnalytics();
      _initRemoteConfig();
    } catch (e) {
      log.e('[Firebase]: 初始化失败 : $e');
      // 如果是网络错误，重新抛出以阻止应用启动
      if (e.toString().contains('Network connection required')) {
        rethrow;
      }
      // 其他错误使用默认配置值
      maxFreeChatCount = 50;
      showClothingCount = 5;
      // 即使Firebase初始化失败，也不应该影响应用启动
      rethrow; // 重新抛出异常，让上层的 catchError 处理
    }
  }

  /// 初始化Firebase Analytics（核心服务）
  static Future<void> _initFirebaseAnalytics() async {
    try {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      log.d('[Firebase]: Analytics initialized ✅');
    } catch (e) {
      log.e('[Firebase]: Analytics 初始化失败: $e');
    }
  }

  /// 初始化 Firebase Remote Config 服务
  static Future<void> _initRemoteConfig() async {
    try {
      // 设置 Remote Config 超时时间为 5 秒
      final remoteConfig = FirebaseRemoteConfig.instance;
      // 配置最小 fetch 时间，减少超时时间
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 3),
          minimumFetchInterval: const Duration(seconds: 30),
        ),
      );

      // 拉取 + 激活远程配置
      await remoteConfig.fetchAndActivate();

      // 获取配置值
      maxFreeChatCount = _getConfigValue('Xj7bP3t', remoteConfig.getInt, 50);
      showClothingCount = _getConfigValue('Tm4gW9n', remoteConfig.getInt, 5);
      // 刷新 Remote Config 后，更新广告配置
      adConfig = remoteConfig.getString('Mg7pR5b');
      log.d('[fb] _refreshRemoteConfig ad_config: $adConfig');
    } catch (e) {
      log.e('[Firebase]: Remote Config 错误: $e');
      // 使用默认值，不影响应用启动
      maxFreeChatCount = 50;
      showClothingCount = 5;
      log.d('[Firebase]: 使用 Remote Config 默认值');
    }
  }

  /// 获取配置值
  static T _getConfigValue<T>(
    String key,
    T Function(String) fetcher,
    T defaultValue,
  ) {
    final value = fetcher(key);
    if ((value is String && value.isNotEmpty) || (value is int && value != 0)) {
      return value;
    }
    return defaultValue;
  }
}
