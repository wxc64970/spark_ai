import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/saCommon/sa_widgets/sa_network_error_page.dart';

var log = SA.dio.logger;

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // 广告初始化
      try {
        MobileAds.instance.initialize();

        MobileAds.instance.updateRequestConfiguration(RequestConfiguration());
      } catch (e) {
        print(e.toString());
      }

      // 只允许竖屏
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light));

      // 使用依赖注入初始化所有服务（遵循干净架构原则）
      // 包括：环境配置、网络客户端、存储、网络监控、登录等服务
      // Change to SAEnv.prod for production
      try {
        await SADependencyInjection.init(env: SAEnv.dev);
      } catch (e) {
        // 如果是网络错误，显示错误页面并阻止应用继续
        if (e.toString().contains('Network connection required')) {
          log.e('[Main]: 网络连接失败，显示错误页面');
          runApp(const SANetworkErrorPage());
          return;
        }
        // 其他错误继续抛出
        rethrow;
      }

      /// 控制图片缓存大小
      PaintingBinding.instance.imageCache.maximumSize = 100;
      PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20;

      try {
        final isFirstLaunch = SA.storage.isRestart == false;
        if (isFirstLaunch) {
          SAAppLogEvent().logInstallEvent();
        }
        SAAppLogEvent().logSessionEvent();
      } catch (e, s) {
        log.e('===> main error: $e\n$s');
      }
      runApp(const MyApp());

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details); // 可选：显示错误
        // 上报异常到你的监控服务
        print('Caught Flutter Error: ${details.exception}');
        print('Stack: ${details.stack}');
      };

      // 捕获 Dart 异步异常（如 Future/Stream 未处理错误）
      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        print('Caught Dart Error: $error');
        print('Stack: $stack');
        // 上报异常
        return true; // 返回 true 表示异常已处理
      };
    },
    (Object error, StackTrace stack) {
      // runZonedGuarded 的异常处理器
      print('Caught Global Error: $error');
      print('Stack: $stack');
      // 上报异常
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (_, child) => GetMaterialApp(
        title: SAAppConstants.appName,
        theme: SAAppColors.lightTheme,
        darkTheme: SAAppColors.lightTheme,
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 200),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        // locale: Get.deviceLocale,
        initialRoute: RoutePages.INITIAL,
        getPages: RoutePages.routes,
        navigatorObservers: [RoutePages.observer, FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
      ),
    );
  }
}
