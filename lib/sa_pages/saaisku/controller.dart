import 'dart:io';

import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/saCommon/sa_utils/sa_cry.dart';
import 'package:video_player/video_player.dart';

import 'index.dart';

class SaaiskuController extends GetxController {
  SaaiskuController();

  final state = SaaiskuState();

  final aiSkuList = <SASkModel>[].obs;

  Rx<SASkModel> selectedModel = SASkModel().obs;
  var isVideo = false;
  late ConsumeFrom from;
  // 视频背景（加密）
  VideoPlayerController? videoController;
  String? _localVideoPath;
  static const String _videoBgUrlEncrypted =
      'c5e01e092b4ded2c537fc0690bc2371eec6b52ac36a1a5e589c6481816c120b9f7c1d216df8330d468bf478a2651a3772012f6f53ad728ee85c4d84f6954c955';
  // 视频首帧图片（加密），用于占位，避免视频加载时的跳动
  static const String _videoFirstFrameUrlEncrypted =
      'c5e01e092b4ded2c537fc0690bc2371eec6b52ac36a1a5e589c6481816c120b9f7c1d216df8330d468bf478a2651a377a79d18bdaf038ae7d518ffb6c0d876ba6dfefd82e8e7c68837b7ff6bf4507a9c74ce7da2a60cc7713c76e55df7283ef2ff74bb0cfd3a61963ec1dbef5c38862ddb4a2f3954502cdf966d10eb4c0859fa';

  // 获取解密后的视频背景 URL
  static String get _videoBgUrl => SACryptoUtil.decrypt(_videoBgUrlEncrypted);

  // 获取解密后的视频首帧 URL
  String get videoFirstFrameUrl =>
      SACryptoUtil.decrypt(_videoFirstFrameUrlEncrypted);
  final RxString contentText = ''.obs;

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    var arg = Get.arguments;
    if (arg != null && arg is ConsumeFrom) {
      from = arg;
    }
    isVideo = from == ConsumeFrom.img2v;
    SAlogEvent(isVideo ? 't_buyvideos' : 't_buyphotos');
    _loadData();

    _initVideoBg();

    ever(SAPayUtils().iapEvent, (event) async {
      if (event?.$1 == IAPEvent.goldSucc && event?.$2 != null) {
        await SA.login.fetchUserInfo();
        // Get.back(result: true);
      }
    });
  }

  void _initVideoBg() {
    FileDownloadService.instance
        .downloadFile(_videoBgUrl, fileType: FileType.video)
        .then((localPath) {
          if (localPath != null) {
            _localVideoPath = localPath;
            _initVideoPlayer();
          }
        });
    if (_localVideoPath != null) {
      _initVideoPlayer();
    }
  }

  void _initVideoPlayer() {
    videoController = VideoPlayerController.file(File(_localVideoPath!));
    videoController
        ?.initialize()
        .then((_) {
          videoController?.setLooping(true);
          videoController?.setVolume(0);
          videoController?.play();
          update();
        })
        .catchError((error) {
          // LogUtils.e('Video initialize error: $error');
        });
  }

  Future<void> _loadData() async {
    SALoading.show();
    await SAPayUtils().query();

    var products = SAPayUtils().consumableList;

    if (!isVideo) {
      aiSkuList.assignAll(
        products.where((e) => e.createImg != null && e.createImg! > 0).toList(),
      );
    } else {
      aiSkuList.assignAll(
        products
            .where((e) => e.createVideo != null && e.createVideo! > 0)
            .toList(),
      );
    }

    selectedModel.value = aiSkuList.firstWhereOrNull(
      (e) => e.id == aiSkuList.last.id,
    )!;
    updateContentText();
    SALoading.close();
    update();
  }

  /// 更新内容文本
  void updateContentText() {
    final gems = selectedModel.value.number ?? 150;
    if (isVideo) {
      contentText.value = SATextData.skuGetVideo(gems.toString());
    } else {
      contentText.value = SATextData.skuGetImage(gems.toString());
    }
  }

  String photoText(int count) {
    if (count == 1) {
      return 'photo_one'.tr;
    } else {
      return 'photo_count'.trParams({'count': count.toString()});
    }
  }

  String videoText(int count) {
    if (count == 1) {
      return 'video_one'.tr;
    } else {
      return 'video_count'.trParams({'count': count.toString()});
    }
  }

  void buy() async {
    SAlogEvent(
      isVideo ? 'buyvideo_continue_click' : 'buyphoto_continue_click',
      parameters: {'sku': selectedModel.value.productDetails?.price ?? '--'},
    );
    await SAPayUtils().buy(selectedModel.value, consFrom: from);
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
