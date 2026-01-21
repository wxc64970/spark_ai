import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

/// 依赖注入配置类
/// 采用干净架构原则，统一管理所有服务
class SADependencyInjection {
  SADependencyInjection._();

  static bool _isInitialized = false;

  /// 初始化依赖注入
  ///
  /// 按照分层架构的原则初始化：
  /// 0. 环境配置（SAEnv Configuration）
  /// 1. 基础设施层（Infrastructure Layer）
  /// 2. 领域层（Domain Layer）
  /// 3. 应用层（Application Layer）
  /// 4. 第三方服务（Third Party Services）
  ///
  /// [env] 环境配置，默认为开发环境
  static Future<void> init({SAEnv env = SAEnv.dev}) async {
    if (_isInitialized) return;

    // ============ 环境配置 ============
    await _initEnvironment(env);

    // ============ 基础设施层 ============
    await _initInfrastructure();

    // ============ 应用层服务 ============
    await _initApplicationServices();

    // ============ 第三方服务 ============
    await _initThirdPartyServices();

    // ============ 延迟加载服务 ============
    _initLazyServices();

    _isInitialized = true;
  }

  /// 初始化环境配置和网络客户端
  static Future<void> _initEnvironment(SAEnv env) async {
    // 1. 加载环境配置
    await EnvConfig.initialize(env);

    // 2. 初始化网络客户端
    SADioClient.instance.init(baseUrl: EnvConfig.baseUrl);
  }

  /// 初始化基础设施层
  /// 包含：存储、网络、本地化等底层服务
  static Future<void> _initInfrastructure() async {
    // 1. 存储服务
    await Get.putAsync<SALocalStorage>(() async {
      final storage = SALocalStorage();
      await storage.initialize();
      return storage;
    }, permanent: true);

    // 2. 本地化服务
    await Get.putAsync<SALocaleService>(() async {
      final localeService = SALocaleService();
      await localeService.initialize();
      return localeService;
    }, permanent: true);

    // 3. 网络监控服务
    await Get.putAsync<SANetworkMonitorService>(() async {
      final networkService = SANetworkMonitorService();
      await networkService.initialize();
      return networkService;
    }, permanent: true);
  }

  /// 初始化应用层服务
  /// 这些服务依赖于基础设施层
  static Future<void> _initApplicationServices() async {
    // 登录服务（依赖于 LocalStorage）
    await Get.putAsync<SALoginService>(() async {
      final loginService = SALoginService();
      return loginService;
    }, permanent: true);

    // 设置业务相关的全局请求头
    await _setupBusinessHeaders();
  }

  /// 设置业务相关的全局请求头
  /// 依赖于基础设施层的服务（storage, locale等）
  static Future<void> _setupBusinessHeaders() async {
    final storage = Get.find<SALocalStorage>();
    final locale = Get.find<SALocaleService>();

    // 获取设备ID
    final deviceId = await storage.getDeviceId();
    final encryptedDeviceId = SACryptoUtil.encrypt(deviceId);

    // 获取应用版本
    final version = await SAInfoUtils.version();

    // 获取语言设置
    final lang = locale.locale.toString();

    // 获取平台信息
    final platform = EnvConfig.platform;

    // 批量设置全局请求头
    SADioClient.instance.setHeaders({
      'pppdgb7roqqonqzcp': platform,
      'pppdgb7roqqonqzc': encryptedDeviceId,
      // "Platform": platform,
      // "device-id": deviceId,
      'version': version,
      'lang': lang,
    });
  }

  /// 初始化第三方服务
  /// 包含：Firebase、Adjust 等第三方 SDK
  static Future<void> _initThirdPartyServices() async {
    try {
      SAThirdPartyService.init();
    } catch (e) {
      // 第三方服务初始化失败不应该阻塞应用启动
      debugPrint('[DI]: 第三方服务初始化失败，但不影响应用启动: $e');
    }
  }

  /// 初始化延迟加载服务
  /// 这些服务在首次使用时才会创建
  static void _initLazyServices() {
    Get.lazyPut<SAAudioPlayerService>(() => SAAudioPlayerService());
  }

  /// 重置所有依赖（主要用于测试）
  static Future<void> reset() async {
    await Get.deleteAll(force: true);
    _isInitialized = false;
  }
}

/// 依赖注入便捷访问类
/// 提供类型安全的服务访问
class SA {
  SA._();
  // 基础设施层
  static SALocalStorage get storage => Get.find<SALocalStorage>();
  static SALocaleService get locale => Get.find<SALocaleService>();
  static SANetworkMonitorService get network => Get.find<SANetworkMonitorService>();

  // 应用层
  static SALoginService get login => Get.find<SALoginService>();

  // 延迟加载
  static SAAudioPlayerService get audio => Get.find<SAAudioPlayerService>();

  // 单例服务
  static SADioClient get dio => SADioClient.instance;
}
