import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:video_player/video_player.dart';

enum PlayState { init, playing, finish }

class SacallguideController extends GetxController with WidgetsBindingObserver, RouteAware {
  SacallguideController();

  late ChaterModel role;

  VideoPlayerController? videoPlayerController;
  Future<void>? initializeVideoPlayerFuture;

  var playState = PlayState.init.obs;
  bool _hasCalledPhoneAccept = false; // 添加标志位防止重复调用

  _initData() {
    update(["sacallguide"]);
  }

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    role = args['role'];

    WidgetsBinding.instance.addObserver(this);

    _initVideoPlay();
  }

  void _initVideoPlay() {
    initializeVideoPlayerFuture = _downloadAndInitVideo();
    _hasCalledPhoneAccept = false; // 重置标志位
  }

  Future<void> _downloadAndInitVideo() async {
    try {
      final guide = role.characterVideoChat?.firstWhereOrNull((e) => e.tag == 'guide');
      var url = guide?.url;
      if (url == null) {
        throw Exception('Video URL not found');
      }

      final path = await FileDownloadService.instance.downloadFile(url, fileType: FileType.video);
      if (path == null) {
        throw Exception('Video download failed');
      }

      videoPlayerController = VideoPlayerController.file(File(path));

      await videoPlayerController!.initialize().then((_) {
        videoPlayerController?.addListener(_videoListener);
        _delayedPlay();
      });
    } catch (e) {
      if (!isClosed) {
        SAToast.show(SATextData.someErrorTryAgain);

        Get.back();
      }
    }
  }

  Future _delayedPlay() async {
    // 延迟5秒后开始播放
    await Future.delayed(const Duration(seconds: 5));

    if (!isClosed) {
      videoPlayerController?.play();
      playState.value = PlayState.playing;
    }
  }

  void _videoListener() {
    if (videoPlayerController == null) return;

    final position = videoPlayerController!.value.position;
    final duration = videoPlayerController!.value.duration;
    final timeRemaining = duration - position;

    if (timeRemaining <= const Duration(milliseconds: 500)) {
      videoPlayerController?.pause();
      playState.value = PlayState.finish;

      if (SA.login.vipStatus.value && !_hasCalledPhoneAccept) {
        _hasCalledPhoneAccept = true; // 设置标志位防止重复调用
        phoneAccept();
      }
    }
  }

  void phoneAccept() async {
    final vip = SA.login.vipStatus.value;
    if (vip) {
      if (SA.login.gemBalance.value < ConsumeFrom.call.gems) {
        Get.toNamed(SARouteNames.gems, arguments: ConsumeFrom.call);
        return;
      }
      RoutePages.offPhone(role: role, showVideo: true);
    } else {
      pushVip();
    }
  }

  void pushVip() {
    SAlogEvent('c_unlock_videocall');
    Get.toNamed(SARouteNames.vip, arguments: VipFrom.call);
  }

  //监听权限
  Future<bool?> requestPermission() async {
    var status = await Permission.phone.request();

    switch (status) {
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        return false;
      case PermissionStatus.granted:
        return true;
      default:
        return true;
    }
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void didPushNext() {
    // 页面被其他页面覆盖时调用
    debugPrint('didPushNext');
    videoPlayerController?.pause();
  }

  @override
  void didPopNext() {
    // 页面从其他页面回到前台时调用
    debugPrint('didPopNext');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      videoPlayerController?.pause();
    }
  }

  @override
  void dispose() {
    RoutePages.observer.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    videoPlayerController?.removeListener(_videoListener);
    videoPlayerController?.dispose();
    super.dispose();
  }
}
