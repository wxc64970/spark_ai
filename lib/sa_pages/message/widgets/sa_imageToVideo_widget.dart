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
    try {
      if (SA.login.textToImage.isEmpty) {
        await SA.login.getStyleConfig();
      }
      if (price == null) {
        await SA.login.getPriceConfigs();
        price = SA.login.priceConfig?.i2v ?? 0;
      }
      videoListData = SA.login.imageToVideo.map((e) => e!).toList();

      // 从全局视频服务获取缓存的视频控制器
      final videoService = VideoInitService.instance;
      if (videoService.isInitialized.value) {
        videoControllers.assignAll(videoService.getVideoControllers());
        debugPrint('✅ 从全局服务获取 ${videoControllers.length} 个视频控制器');
      } else {
        debugPrint('⏳ 等待视频初始化完成...');
        await Future.delayed(const Duration(seconds: 1));
        if (videoService.isInitialized.value) {
          videoControllers.assignAll(videoService.getVideoControllers());
          debugPrint('✅ 视频初始化完成，获取 ${videoControllers.length} 个控制器');
        } else {
          debugPrint('⚠️ 视频初始化未完成，可能网络延迟');
        }
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('❌ 初始化失败：$e');
    } finally {
      SALoading.close();
    }
  }

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
    // 视频由全局服务管理，这里只清空本地引用
    videoControllers.clear();
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
          ctr.state.selectedStyle.value = 'VideoCustom';
          // 让输入框获得焦点并唤起键盘
          ctr.inputFocusNode.requestFocus();
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
              color: ctr.state.selectedStyle.value == 'VideoCustom'
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
          SASheetBottom.show(ConsumeFrom.star);
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
        ctr.state.selectedStyle.value = '';
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
