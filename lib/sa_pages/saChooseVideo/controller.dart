import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';

class SachoosevideoController extends GetxController {
  SachoosevideoController();

  final state = SachoosevideoState();

  // 缓存方案：首加载后保留播放器实例，防止多次进入重新拉取网络流
  static final RxList<VideoPlayerController> _cachedVideoControllers =
      <VideoPlayerController>[].obs;
  static bool _hasCachedControllers = false;

  List<StyleConfigItem> videoListData = [];
  final RxList<VideoPlayerController> videoControllers =
      <VideoPlayerController>[].obs;
  late SimpleThrottler throttler = SimpleThrottler();

  final videoDetailIndex = 0.obs;
  final imagePath = ''.obs;
  var price = SA.login.priceConfig?.i2v;

  void hanldeSku(from) {
    SAlogEvent('i2v_coin_click');
    // Get.toNamed(SARouteNames.countSku, arguments: from);
    SASheetBottom.show(from);
  }

  void onTapUpload() async {
    SAlogEvent(
      'i2v_template_page_upload_click',
      parameters: {"id": videoListData[videoDetailIndex.value].name ?? ''},
    );
    SALoading.show();
    var file = await SAImageUtils.pickImageFromGallery();
    SALoading.close();
    if (file == null) return;
    imagePath.value = file.path;
  }

  void onTapGen() async {
    if (imagePath.value.isEmpty) {
      SAToast.show(SATextData.plaseUploadImage);
      return;
    }
    throttler.run(action: onTapGenDebounce);
  }

  void onTapGenDebounce() async {
    SALoading.show();
    await SA.login.fetchUserInfo();
    genVideo();
  }

  void buySku() async {
    // final from = isVideo ? ConsumeFrom.img2v : ConsumeFrom.aiphoto;
    // Get.toNamed(SARouteNames.countSku, arguments: from);
    SASheetBottom.show(ConsumeFrom.star);
  }

  void genVideo() async {
    var starCount = SA.login.starCount.value;
    if (starCount < price!) {
      SALoading.close();
      buySku();
      return;
    }
    SAlogEvent(
      'i2v_template_page_generate_click',
      parameters: {"id": videoListData[videoDetailIndex.value].name ?? ''},
    );
    // 上传图片，开始任务
    try {
      var uploadRes = await ImageAPI.uploadImgToVideoV2(
        imagePath: imagePath.value,
        enText: videoListData[videoDetailIndex.value].name ?? '',
      );
      if (uploadRes == null) {
        SALoading.close();
        SAToast.show(" Generation failed, please try again later.");
        return;
      } else {
        SA.login.fetchUserInfo();
        Get.toNamed(SARouteNames.aiGenerateHistory);
      }
    } finally {
      SALoading.close();
    }
  }

  void _initData() async {
    SALoading.show();
    if (SA.login.textToImage.isEmpty) {
      await SA.login.getStyleConfig();
    }
    if (price == null) {
      await SA.login.getPriceConfigs();
      price = SA.login.priceConfig?.i2v ?? 0;
    }

    videoListData = SA.login.imageToVideo.map((e) => e!).toList();

    // 如果已经缓存，直接复用，避免网络/解码等待
    if (SachoosevideoController._hasCachedControllers &&
        SachoosevideoController._cachedVideoControllers.isNotEmpty) {
      videoControllers.assignAll(
        SachoosevideoController._cachedVideoControllers,
      );
      SALoading.close();
      return;
    }

    await _initAllPlayers();
    SALoading.close();
  }

  Future<void> _initAllPlayers() async {
    if (SachoosevideoController._hasCachedControllers &&
        SachoosevideoController._cachedVideoControllers.isNotEmpty) {
      videoControllers.assignAll(
        SachoosevideoController._cachedVideoControllers,
      );
      return;
    }

    for (StyleConfigItem item in videoListData) {
      if (item.url == null || item.url!.isEmpty) {
        continue;
      }
      final controller = VideoPlayerController.networkUrl(Uri.parse(item.url!));
      await controller.initialize();
      controller.setLooping(true);
      controller.setVolume(0);
      controller.play();
      videoControllers.add(controller);
    }

    // 缓存当前控制器，下一次进入页面直接复用
    SachoosevideoController._cachedVideoControllers.clear();
    SachoosevideoController._cachedVideoControllers.addAll(videoControllers);
    SachoosevideoController._hasCachedControllers = true;
  }

  // 暂停所有视频
  void pauseAllPlayers() {
    for (var controller in videoControllers) {
      if (controller.value.isInitialized) {
        controller.pause();
      }
    }
  }

  // 播放所有视频（全路径同时循环）
  void playAllPlayers() {
    for (var controller in videoControllers) {
      if (controller.value.isInitialized) {
        controller.play();
      }
    }
  }

  void playSingleVideo(int targetIndex) {
    if (targetIndex >= 0 && targetIndex < videoControllers.length) {
      videoDetailIndex.value = targetIndex;
      if (videoControllers[targetIndex].value.isInitialized) {
        videoControllers[targetIndex].play();
      }
    }
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    SAlogEvent('i2v_show');
    _initData();
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    // cache 模式下只暂停，确保进入时仍可直接复用；非 cache 情况下彻底释放
    if (_hasCachedControllers) {
      pauseAllPlayers();
    } else {
      for (var controller in videoControllers) {
        controller.dispose();
      }
      videoControllers.clear();
    }
    throttler.dispose();
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    if (_hasCachedControllers) {
      pauseAllPlayers();
    } else {
      for (var controller in videoControllers) {
        controller.dispose();
      }
      videoControllers.clear();
    }
    throttler.dispose();
    super.dispose();
  }
}
