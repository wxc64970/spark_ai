import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:spark_ai/saCommon/index.dart' hide Media;
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
  final List<Player> _players = [];
  final List<VideoController> videoControllers = <VideoController>[];
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
    await _initAllPlayers();
    setState(() {});
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
      setState(() {
        videoControllers.add(controller);
      });
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

  @override
  void dispose() {
    for (final player in _players) {
      player.dispose();
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
              child: videoControllers.length < videoListData.length
                  ? SizedBox.shrink()
                  : Video(
                      controller: videoControllers[index],
                      controls: NoVideoControls,
                      fit: BoxFit.cover,
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
