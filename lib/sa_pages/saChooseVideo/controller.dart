import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:spark_ai/saCommon/index.dart' hide Media;

import 'index.dart';

class SachoosevideoController extends GetxController {
  SachoosevideoController();

  final state = SachoosevideoState();

  List<StyleConfigItem> videoListData = [];
  final List<Player> _players = [];
  final RxList<VideoController> videoControllers = <VideoController>[].obs;
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
    SAlogEvent('i2v_template_page_upload_click');
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
    SASheetBottom.show(ConsumeFrom.img2v);
  }

  void genVideo() async {
    var starCount = SA.login.starCount.value;
    if (starCount < price!) {
      SALoading.close();
      buySku();
      return;
    }
    SAlogEvent('i2v_template_page_generate_click');
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
    _initAllPlayers();
    SALoading.close();
  }

  Future<void> _initAllPlayers() async {
    for (StyleConfigItem item in videoListData) {
      // 优化配置：硬件解码 + 最小缓存
      final player = Player(
        configuration: const PlayerConfiguration(
          bufferSize: 1024 * 256, // 最小缓存
        ),
      );

      final controller = VideoController(player);

      // 加载视频 + 自动播放 + 循环
      player.setPlaylistMode(PlaylistMode.loop);
      await player.setVolume(0); // 🔥 全部静音（关键！）
      await player.open(Media(item.url!), play: true);

      _players.add(player);
      videoControllers.add(controller);
    }
  }

  // 暂停所有视频
  void pauseAllPlayers() {
    for (var player in _players) {
      player.pause();
    }
  }

  // 播放所有视频
  void playAllPlayers() {
    for (var player in _players) {
      player.play();
    }
  }

  void playSingleVideo(int targetIndex) {
    // 先暂停所有
    pauseAllPlayers();
    // 仅播放指定下标的单个视频
    if (targetIndex >= 0 && targetIndex < _players.length) {
      _players[targetIndex].play();
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
    for (final player in _players) {
      player.dispose();
    }
    throttler.dispose();
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    for (final player in _players) {
      player.dispose();
    }
    throttler.dispose();
    super.dispose();
  }
}
