import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/sagems/widgets/sa_tag_widget.dart';
import 'package:video_player/video_player.dart';

import '../index.dart';

/// hello
class SAContentWidget extends StatefulWidget {
  const SAContentWidget({Key? key}) : super(key: key);

  @override
  State<SAContentWidget> createState() => _SAContentWidgetState();
}

class _SAContentWidgetState extends State<SAContentWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 每3秒触发一次抖动
    _startShakeAnimation();
  }

  void _startShakeAnimation() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _animationController.forward().then((_) {
          _animationController.reverse().then((_) {
            _startShakeAnimation();
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  SaaiskuController get controller => Get.find<SaaiskuController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      // fit: StackFit.expand,
      children: [
        GetBuilder<SaaiskuController>(
          builder: (controller) {
            return Positioned.fill(
              child: (controller.videoController?.value.isInitialized ?? false)
                  ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller.videoController!.value.size.width,
                        height: controller.videoController!.value.size.height,
                        child: VideoPlayer(controller.videoController!),
                      ),
                    )
                  : SAImageWidget(
                      url: controller.videoFirstFrameUrl,
                      width: double.infinity,
                      height: double.infinity,
                    ),
            );
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBar(),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 686.w,
                  margin: EdgeInsets.only(left: 32.w),
                  height: controller.isVideo ? 182.w : 266.w,
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: controller.isVideo
                          ? AssetImage("assets/images/sa_81.png")
                          : AssetImage("assets/images/sa_80.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Obx(
                    () => SARichTextPlaceholder(
                      textKey: controller.contentText.value,
                      placeholders: {
                        'icon': WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Image.asset(
                            'assets/images/sa_47.png',
                            width: 32.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      },
                      style: TextStyle(
                        color: Color(0xff808080),
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.w),
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    itemCount: controller.aiSkuList.length,
                    itemBuilder: (_, index) {
                      final model = controller.aiSkuList[index];
                      var count = 1;
                      var countUni = '';
                      var uniPart = '';

                      if (controller.from == ConsumeFrom.aiphoto) {
                        count = model.createImg ?? 1;
                        // countUni = SATextData.ai_photos.toUpperCase();
                        countUni = SATextData.ai_photos;
                        uniPart = SATextData.ai_photo_label;
                      } else if (controller.from == ConsumeFrom.img2v) {
                        count = model.createVideo ?? 1;
                        // countUni = SATextData.ai_videos.toUpperCase();
                        countUni = SATextData.ai_videos;
                        uniPart = SATextData.ai_video_label;
                      }

                      var rawPrice = model.productDetails?.rawPrice ?? 0;
                      var oneRawPrice = rawPrice / count;
                      double truncated =
                          (oneRawPrice * 100).truncateToDouble() / 100;
                      String formattedNumber = truncated.toStringAsFixed(2);
                      var onePrice =
                          '${model.productDetails?.currencySymbol}$formattedNumber/$uniPart';

                      List<Widget>? tags;
                      if (model.tag == 1) {
                        tags = [SAGemTagWidgets(tag: SATextData.bestChoice)];
                      }
                      if (model.tag == 2) {
                        tags = [
                          SAGemTagWidgets(tag: SATextData.ai_most_popular),
                        ];
                      }
                      return Obx(
                        () => InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            controller.selectedModel.value = model;
                            controller.updateContentText();
                            controller.buy();
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 24.w),
                                width: Get.width,
                                // margin: EdgeInsets.only(bottom: 16.w),
                                padding: EdgeInsets.symmetric(
                                  vertical: 24.w,
                                  horizontal: 32.w,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.r),
                                  border: Border.all(
                                    width: 2.w,
                                    color:
                                        controller.selectedModel.value == model
                                        ? Color(0xffDF9A44)
                                        : Color(
                                            0xffFFFFFF,
                                          ).withValues(alpha: 0.15),
                                  ),
                                  color: controller.selectedModel.value == model
                                      ? Color(0xffDF9A44).withValues(alpha: 0.4)
                                      : Color(
                                          0xffFFFFFF,
                                        ).withValues(alpha: 0.15),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Column(
                                    //   spacing: 4.w,
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.start,
                                    //   children: [
                                    //     Row(
                                    //       spacing: 8.w,
                                    //       children: [
                                    //         Text(
                                    //           'Bonus:${model.number ?? 0}',
                                    //           style: TextStyle(
                                    //             fontSize: 28.sp,
                                    //             fontWeight: FontWeight.w600,
                                    //             color: Colors.black,
                                    //           ),
                                    //         ),
                                    //         Image.asset(
                                    //           "assets/images/sa_20.png",
                                    //           width: 40.w,
                                    //           fit: BoxFit.contain,
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ],
                                    // ),
                                    Column(
                                      spacing: 4.w,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          model.productDetails?.price ?? '--',
                                          style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Text(
                                          onePrice,
                                          style: TextStyle(
                                            fontSize: 32.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      spacing: 6.w,
                                      children: [
                                        Text(
                                          count.toString(),
                                          style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 36.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Text(
                                          countUni,
                                          style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 36.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (tags != null) ...tags,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 80.w),
            _buildPurchaseButton(),
            SizedBox(height: 16.w),
            PolicyWidget(
              type: SA.storage.isSAB
                  ? SAPolicyBottomType.vip2
                  : SAPolicyBottomType.vip1,
            ),
            SizedBox(height: Get.mediaQuery.padding.bottom + 16.w),
            // Container(
            //   padding: EdgeInsets.only(
            //     top: 40.w,
            //     bottom: Get.mediaQuery.padding.bottom + 20.w,
            //   ),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(24.r),
            //       topRight: Radius.circular(24.r),
            //     ),
            //     boxShadow: [
            //       BoxShadow(
            //         color: const Color(0x1000001a),
            //         offset: const Offset(0, -2),
            //         blurRadius: 8,
            //         spreadRadius: 0,
            //       ),
            //     ],
            //     color: Colors.white,
            //   ),
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 144.w),
            //     child: ButtonGradientWidget(
            //       height: 88,
            //       onTap: controller.buy,
            //       child: Center(
            //         child: Text(
            //           SATextData.btnContinue,
            //           style: TextStyle(
            //             fontFamily: "Montserrat",
            //             fontSize: 28.sp,
            //             fontWeight: FontWeight.w600,
            //             color: Colors.black,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  /// 构建购买按钮
  Widget _buildPurchaseButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 112.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ButtonGradientWidget2(
            height: 88,
            width: Get.width,
            onTap: controller.buy,
            gradientColors: const [Color(0xFFDF9A44), Color(0xFFDF9A44)],
            child: Center(
              child: Text(
                SA.storage.isSAB
                    ? SATextData.btnContinue
                    : SATextData.subscribe,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 28.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            right: 130.w,
            child: SizedBox(
              width: 40.w,
              height: 88.w,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_animation.value, 0),
                    child: Image.asset(
                      "assets/images/sa_82.png",
                      width: 40.w,
                      fit: BoxFit.contain,
                    ),
                    // child: SizedBox(
                    //   width: 88.w,
                    //   height: 88.w,
                    //   child: Lottie.asset("assets/json/right_arrow.json"),
                    // ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 24.w,
            top: -20.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(16.r),
                  topEnd: Radius.circular(16.r),
                  bottomEnd: Radius.circular(16.r),
                ),
                color: Color(0xffFFD9FE),
              ),
              child: Obx(
                () => Row(
                  spacing: 8.w,
                  children: [
                    Text(
                      '+${controller.selectedModel.value.number ?? 0}',
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Color(0xFF000000),
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Image.asset(
                      "assets/images/sa_20.png",
                      width: 32.w,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appBar() {
    return Padding(
      padding: EdgeInsets.only(
        top: Get.mediaQuery.padding.top + 16.w,
        left: 32.w,
        right: 32.w,
      ),
      child: InkWell(
        onTap: () {
          Get.back();
        },
        child: Image.asset(
          "assets/images/close.png",
          width: 48.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
