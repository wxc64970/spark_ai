import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/message/index.dart';

class ImageToVideoWidget extends StatefulWidget {
  const ImageToVideoWidget({super.key});

  @override
  State<ImageToVideoWidget> createState() => _ImageToVideoWidgetState();
}

class _ImageToVideoWidgetState extends State<ImageToVideoWidget> {
  final MessageController ctr = Get.find<MessageController>();

  // 统一缓存逻辑，避免多次进入时重复请求视频流
  static final RxList<VideoPlayerController> _cachedVideoControllers =
      <VideoPlayerController>[].obs;
  static bool _hasCachedControllers = false;

  var price = SA.login.priceConfig?.i2v;
  List<StyleConfigItem> videoListData = [];
  final RxList<VideoPlayerController> videoControllers =
      <VideoPlayerController>[].obs;
  late SimpleThrottler throttler = SimpleThrottler();
  @override
  void initState() {
    super.initState();
    _initData();
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

    // 缓存存在时直接复用
    if (_hasCachedControllers && _cachedVideoControllers.isNotEmpty) {
      videoControllers.assignAll(_cachedVideoControllers);
      playAllPlayers();
      setState(() {});
      SALoading.close();
      return;
    }

    await _initAllPlayers();
    setState(() {});
    SALoading.close();
  }

  Future<void> _initAllPlayers() async {
    if (_hasCachedControllers && _cachedVideoControllers.isNotEmpty) {
      videoControllers.assignAll(_cachedVideoControllers);
      return;
    }

    for (StyleConfigItem item in videoListData) {
      if (item.url == null || item.url!.isEmpty) {
        continue;
      }
      final controller = VideoPlayerController.network(item.url!);
      await controller.initialize();
      controller.setLooping(true);
      controller.setVolume(0);
      controller.play();
      videoControllers.add(controller);
    }

    // 直接让全量视频播放，满足“所有视频同时循环播放”
    playAllPlayers();

    _cachedVideoControllers.clear();
    _cachedVideoControllers.addAll(videoControllers);
    _hasCachedControllers = true;
  }

  // 暂停所有视频
  void pauseAllPlayers() {
    for (var controller in videoControllers) {
      if (controller.value.isInitialized) {
        controller.pause();
      }
    }
  }

  // 播放所有视频（全视频同时循环）
  void playAllPlayers() {
    for (var controller in videoControllers) {
      if (controller.value.isInitialized) {
        controller.play();
      }
    }
  }

  void playSingleVideo(int targetIndex) {
    if (targetIndex >= 0 && targetIndex < videoControllers.length) {
      if (videoControllers[targetIndex].value.isInitialized) {
        videoControllers[targetIndex].play();
      }
    }
  }

  @override
  void dispose() {
    // 如果已经缓存等待复用，则不要释放播放器实例
    if (!_hasCachedControllers) {
      for (final controller in videoControllers) {
        controller.dispose();
      }
      videoControllers.clear();
    }
    throttler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: videoListData.length + 1,
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10.w,
        crossAxisSpacing: 10.w,
        childAspectRatio: 164 / 218,
      ),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildCustomItem();
        }
        var item = videoListData[index - 1];
        return _buildItem(item, index - 1);
      },
    );
  }

  Widget _buildCustomItem() {
    return Obx(
      () => GestureDetector(
        onTap: () {
          ctr.state.selectedStyle.value = '';
        },
        child: Container(
          width: 164.w,
          height: 218.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/sa_92.png"),
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              width: 2.w,
              color: ctr.state.selectedStyle.value.isEmpty
                  ? SAAppColors.pinkColor
                  : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Center(
                  child: Text(
                    SATextData.custom,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(StyleConfigItem? item, int index) {
    return GestureDetector(
      onTap: () async {
        int userCoins = SA.login.starCount.value;
        if (SA.login.priceConfig == null) {
          await SA.login.getPriceConfigs();
        }
        int price = SA.login.priceConfig!.i2v!;

        if (userCoins < price) {
          SASheetBottom.show(ConsumeFrom.creaimg);
          return;
        }
        setState(() {
          ctr.state.selectedStyle.value = item.name!;
        });

        playSingleVideo(index);

        ctr.sendMsgUndress(
          styleName: ctr.state.selectedStyle.value,
          genType: ctr.state.genType.value,
        );
        ctr.state.isUndress.value = false;
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child:
                  index >= videoControllers.length ||
                      !videoControllers[index].value.isInitialized
                  ? SAImageWidget(
                      url: item?.icon,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: videoControllers[index].value.size.width,
                        height: videoControllers[index].value.size.height,
                        child: VideoPlayer(videoControllers[index]),
                      ),
                    ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  width: 2.w,
                  color: ctr.state.selectedStyle.value == item!.name!
                      ? SAAppColors.pinkColor
                      : Colors.transparent,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Center(
                      child: Text(
                        item.name!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
