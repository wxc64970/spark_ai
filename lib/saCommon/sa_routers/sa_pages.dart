import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/saCommon/sa_widgets/sa_video_screen.dart';
import 'package:spark_ai/sa_pages/index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import 'sa_observers.dart';

class RoutePages {
  static const INITIAL = SARouteNames.launch;
  static final RouteObservers<Route> observer = RouteObservers();
  static List<String> history = [];
  // 列表
  static List<GetPage> routes = [
    GetPage(name: SARouteNames.launch, page: () => const SalaunchscreenPage()),
    GetPage(
      name: SARouteNames.application,
      page: () => const SaapplicationPage(),
      binding: SaapplicationBinding(),
    ),
    GetPage(
      name: SARouteNames.search,
      page: () => const SasearchPage(),
      binding: SasearchBinding(),
    ),
    GetPage(
      name: SARouteNames.message,
      page: () => const MessagePage(),
      binding: MessageBinding(),
    ),
    GetPage(
      name: SARouteNames.profile,
      page: () => const SaprofilePage(),
      binding: SaprofileBinding(),
    ),
    GetPage(
      name: SARouteNames.mask,
      page: () => const SamaskPage(),
      binding: SamaskBinding(),
    ),
    GetPage(
      name: SARouteNames.gems,
      page: () => const SagemsPage(),
      binding: SagemsBinding(),
    ),
    GetPage(
      name: SARouteNames.editMask,
      page: () => const SaeditmaskPage(),
      binding: SaeditmaskBinding(),
    ),
    GetPage(
      name: SARouteNames.language,
      page: () => const SalanguagePage(),
      binding: SalanguageBinding(),
    ),
    GetPage(
      name: SARouteNames.undr,
      page: () => const SaundrPage(),
      binding: SaundrBinding(),
    ),
    GetPage(
      name: SARouteNames.aiGenerateImage,
      page: () => const SaaigenerateimagePage(),
      binding: SaaigenerateimageBinding(),
    ),
    GetPage(
      name: SARouteNames.imagePreview,
      page: () => const ImagePreviewScreen(),
      transition: Transition.zoom,
      fullscreenDialog: true,
      preventDuplicates: true,
    ),
    GetPage(
      name: SARouteNames.aiGenerateLoading,
      page: () => const SaaigenerateloadingPage(),
    ),
    GetPage(name: SARouteNames.aiImage, page: () => const SaaiimagePage()),
    GetPage(
      name: SARouteNames.aiGenerateResult,
      page: () => const SaaigenerateresultPage(),
      binding: SaaigenerateresultBinding(),
    ),
    GetPage(
      name: SARouteNames.aiGenerateHistory,
      page: () => const SaaigeneratehistoryPage(),
      binding: SaaigeneratehistoryBinding(),
    ),
    GetPage(
      name: SARouteNames.vip,
      page: () => const PopScope(
        canPop: false, // 禁止返回键
        child: SasubscribePage(),
      ),
      popGesture: false, // 禁用 iOS 侧滑返回
      preventDuplicates: true,
      binding: SasubscribeBinding(),
    ),
    GetPage(
      name: SARouteNames.videoPreview,
      page: () => const SAVideoPreviewScreen(),
      fullscreenDialog: true,
      preventDuplicates: true,
    ),

    GetPage(
      name: SARouteNames.phone,
      page: () => const SacallPage(),
      transition: Transition.downToUp,
      popGesture: false,
      preventDuplicates: true,
      fullscreenDialog: true,
      binding: SacallBinding(),
    ),
    GetPage(
      name: SARouteNames.phoneGuide,
      page: () => const SacallguidePage(),
      transition: Transition.downToUp,
      popGesture: false,
      preventDuplicates: true,
      fullscreenDialog: true,
    ),
    GetPage(
      name: SARouteNames.countSku,
      page: () => const SaaiskuPage(),
      transition: Transition.downToUp,
      popGesture: false,
      preventDuplicates: true,
      fullscreenDialog: true,
      binding: SaaiskuBinding(),
    ),
  ];

  static Future<void> pushChat(
    String? roleId, {
    bool showLoading = true,
  }) async {
    if (roleId == null) {
      SAToast.show('roleId is null, please check!');
      return;
    }

    try {
      if (showLoading) {
        SALoading.show();
      }

      // 使用 Future.wait 来同时执行查角色和查会话
      var results = await Future.wait([
        Api.loadRoleById(roleId), // 查角色
        Api.addSession(roleId), // 查会话
      ]);

      var role = results[0];
      var session = results[1];

      // 检查角色和会话是否为 null
      if (role == null) {
        _dismissAndShowErrorToast('role is null');
        return;
      }
      if (session == null) {
        _dismissAndShowErrorToast('session is null');
        return;
      }

      SALoading.close();
      Get.toNamed(
        SARouteNames.message,
        arguments: {'role': role, 'session': session},
      );
    } catch (e) {
      SALoading.close();
      SAToast.show(e.toString());
    }
  }

  static Future<T?>? pushPhone<T>({
    required int sessionId,
    required ChaterModel role,
    required bool showVideo,
    CallState callState = CallState.calling,
  }) async {
    // 检查 Mic 权限 和 语音权限
    if (!await checkPermissions()) {
      showNoPermissionDialog();
      return null;
    }

    return Get.toNamed(
      SARouteNames.phone,
      arguments: {
        'sessionId': sessionId,
        'role': role,
        'callState': callState,
        'showVideo': showVideo,
      },
    );
  }

  static Future<T?>? offPhone<T>({
    required ChaterModel role,
    required bool showVideo,
    CallState callState = CallState.calling,
  }) async {
    // 检查 Mic 权限 和 语音权限
    if (!await checkPermissions()) {
      showNoPermissionDialog();
      return null;
    }
    var seesion = await Api.addSession(role.id ?? ''); // 查会话
    final sessionId = seesion?.id;
    if (sessionId == null) {
      SAToast.show('sessionId is null, please check!');
      return null;
    }

    return Get.offNamed(
      SARouteNames.phone,
      arguments: {
        'sessionId': sessionId,
        'role': role,
        'callState': callState,
        'showVideo': showVideo,
      },
    );
  }

  /// 检查麦克风和语音识别权限，返回是否已授予所有权限
  static Future<bool> checkPermissions() async {
    PermissionStatus status = await Permission.microphone.request();
    PermissionStatus status2 = await Permission.speech.request();
    return status.isGranted && status2.isGranted;
  }

  // 没有权限提示
  static Future<void> showNoPermissionDialog() async {
    DialogWidget.alert(
      message: SATextData.micPermission,
      onConfirm: () async {
        await openAppSettings();
      },
      cancelText: SATextData.cancel,
      confirmText: SATextData.openSettings,
    );
  }

  static void _dismissAndShowErrorToast(String message) {
    SALoading.close();
    SAToast.show(message);
  }

  static void report() {
    Get.bottomSheet(SAReportSheet(), isScrollControlled: true);
  }

  static void _showError(String message) {
    SAToast.show(message);
  }

  static Future<void> openAppStoreReview() async {
    if (Platform.isIOS) {
      String appId = EnvConfig.appId;
      final Uri url = Uri.parse(
        'https://apps.apple.com/app/id$appId?action=write-review',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showError('Could not launch $url');
      }
    } else if (Platform.isAndroid) {
      String packageName = await SAInfoUtils.packageName();
      final Uri url = Uri.parse(
        'https://play.google.com/store/apps/details?id=$packageName',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showError('Could not launch $url');
      }
    } else {
      _showError('Unsupported platform');
    }
  }

  static Future<void> openAppStore() async {
    try {
      if (Platform.isIOS) {
        String appId = EnvConfig.appId;
        final Uri url = Uri.parse('https://apps.apple.com/app/id$appId');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          _showError('Could not launch $url');
        }
      } else if (Platform.isAndroid) {
        String packageName = await SAInfoUtils.packageName();
        final Uri url = Uri.parse(
          'https://play.google.com/store/apps/details?id=$packageName',
        );

        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          _showError('Could not launch $url');
        }
      } else {
        _showError('Unsupported platform');
      }
    } catch (e) {
      _showError('Could not launch ${e.toString()}');
    }
  }

  static void toEmail() async {
    final version = await SAInfoUtils.version();
    final device = await SA.storage.getDeviceId();
    final uid = SA.login.currentUser?.id;

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: EnvConfig.email, // 收件人
      query:
          "subject=Feedback&body=version: $version\ndevice: $device\nuid: $uid\nPlease input your problem:\n", // 设置默认主题和正文内容
    );

    if (await canLaunchUrl(emailUri)) {
      launchUrl(emailUri);
    } else {
      _showError('Could not launch email client');
    }
  }
}
