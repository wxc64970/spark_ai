import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:spark_ai/saCommon/index.dart';

/// 全局视频初始化管理服务
/// 职责：
/// 1. app 启动时在后台初始化所有视频资源（无主线程阻碍）
/// 2. 所有视频循环播放并缓存控制器
/// 3. 提供统一的视频控制器访问接口
class VideoInitService extends GetxService {
  static VideoInitService get instance => Get.find<VideoInitService>();

  // 缓存所有初始化的视频控制器
  final RxList<VideoPlayerController> cachedVideoControllers =
      <VideoPlayerController>[].obs;

  // 初始化状态标志
  final isInitialized = false.obs;

  // 视频URL列表缓存
  List<String> _videoUrls = [];

  /// 初始化视频服务（app 启动时调用）
  /// 在后台异步初始化，不阻碍主线程
  Future<void> initVideoService() async {
    if (isInitialized.value) {
      debugPrint('📺 视频服务已初始化，跳过重复初始化');
      return;
    }

    debugPrint('📺 启动视频初始化服务...');

    try {
      // 获取视频配置数据
      if (SA.login.imageToVideo.isEmpty) {
        await SA.login.getStyleConfig();
      }

      // 提取视频 URL 列表
      _videoUrls = SA.login.imageToVideo
          .where(
            (item) => item != null && item.url != null && item.url!.isNotEmpty,
          )
          .map((item) => item!.url!)
          .toList();

      debugPrint('🎬 获取到 ${_videoUrls.length} 个视频资源');

      // 后台异步初始化所有视频（不阻碍主线程）
      _initAllVideosInBackground();

      isInitialized.value = true;
    } catch (e) {
      debugPrint('❌ 视频初始化失败：$e');
    }
  }

  /// 后台异步初始化所有视频
  /// 使用异步任务队列，每个视频独立初始化
  void _initAllVideosInBackground() {
    Future.microtask(() async {
      for (int i = 0; i < _videoUrls.length; i++) {
        try {
          final url = _videoUrls[i];
          debugPrint('🎥 初始化视频 ${i + 1}/${_videoUrls.length}：$url');

          final controller = VideoPlayerController.networkUrl(Uri.parse(url));

          // 初始化控制器
          await controller.initialize();
          controller.setLooping(true);
          controller.setVolume(0);
          controller.play();

          cachedVideoControllers.add(controller);

          debugPrint('✅ 视频 ${i + 1} 初始化完成，开始循环播放');
        } catch (e) {
          debugPrint('⚠️ 视频 ${i + 1} 初始化失败：$e');
        }
      }

      debugPrint('🎉 所有视频初始化完成，共 ${cachedVideoControllers.length} 个');
    });
  }

  /// 获取缓存的视频控制器列表
  List<VideoPlayerController> getVideoControllers() {
    return cachedVideoControllers;
  }

  /// 获取单个视频控制器
  VideoPlayerController? getVideoController(int index) {
    if (index >= 0 && index < cachedVideoControllers.length) {
      return cachedVideoControllers[index];
    }
    return null;
  }

  /// 暂停所有视频
  void pauseAllVideos() {
    for (var controller in cachedVideoControllers) {
      if (controller.value.isInitialized) {
        controller.pause();
      }
    }
    debugPrint('⏸️ 所有视频已暂停');
  }

  /// 播放所有视频
  void playAllVideos() {
    for (var controller in cachedVideoControllers) {
      if (controller.value.isInitialized) {
        controller.play();
      }
    }
    debugPrint('▶️ 所有视频开始播放');
  }

  /// 播放指定索引的视频
  void playSingleVideo(int index) {
    if (index >= 0 && index < cachedVideoControllers.length) {
      final controller = cachedVideoControllers[index];
      if (controller.value.isInitialized) {
        controller.play();
        debugPrint('▶️ 播放视频 $index');
      }
    }
  }

  /// 暂停指定索引的视频
  void pauseSingleVideo(int index) {
    if (index >= 0 && index < cachedVideoControllers.length) {
      final controller = cachedVideoControllers[index];
      if (controller.value.isInitialized) {
        controller.pause();
        debugPrint('⏸️ 暂停视频 $index');
      }
    }
  }

  /// 清理视频资源（app 关闭时调用）
  void disposeAllVideos() {
    for (var controller in cachedVideoControllers) {
      controller.dispose();
    }
    cachedVideoControllers.clear();
    isInitialized.value = false;
    debugPrint('🗑️ 所有视频资源已释放');
  }

  @override
  void onClose() {
    disposeAllVideos();
    super.onClose();
  }
}
