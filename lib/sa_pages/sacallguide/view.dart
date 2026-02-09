import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/sacallguide/widgets/sa_call_title.dart';
import 'package:video_player/video_player.dart';

import 'index.dart';
import 'widgets/sa_call_button.dart';

class SacallguidePage extends StatefulWidget {
  const SacallguidePage({Key? key}) : super(key: key);

  @override
  State<SacallguidePage> createState() => _SacallguidePageState();
}

class _SacallguidePageState extends State<SacallguidePage> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// 路由订阅
    RoutePages.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    /// 取消路由订阅
    RoutePages.observer.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const _SacallguideViewGetX();
  }
}

class _SacallguideViewGetX extends GetView<SacallguideController> {
  const _SacallguideViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(child: SAImageWidget(url: controller.role.avatar)),
          FutureBuilder(
            future: controller.initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  controller.videoPlayerController != null) {
                return Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller.videoPlayerController?.value.size.width,
                      height:
                          controller.videoPlayerController?.value.size.height,
                      child: VideoPlayer(controller.videoPlayerController!),
                    ),
                  ),
                );
              } else {
                // 在加载时显示进度指示器
                return Center(child: SALoading.activityIndicator());
              }
            },
          ),
          Positioned.fill(
            child: Container(
              width: Get.width,
              height: Get.height,
              color: Colors.black38,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Obx(() {
              // if (controller.playState.value == PlayState.playing) {

              // }
              if (controller.playState.value == PlayState.finish) {
                return SACallTitle(
                  role: controller.role,
                  onTapClose: () {
                    Get.back();
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Obx(() {
              final vip = SA.login.vipStatus.value;

              switch (controller.playState.value) {
                case PlayState.init:
                case PlayState.playing:
                  return _playingView();

                case PlayState.finish:
                  return vip ? _playingView() : _playedView1();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _playingView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 72.w,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 24.w),
          decoration: BoxDecoration(
            color: const Color(0xff212121).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(42.r),
          ),
          child: Text(
            SATextData.invitesYouToVideoCall,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SACallButton(
              icon: 'assets/images/call_hangup.png',
              bgColor: Color(0xffEB5C46),
              onTap: () => Get.back(),
            ),
            if (controller.playState.value == PlayState.finish)
              SACallButton(
                icon: 'assets/images/call_answer.png',
                bgColor: SAAppColors.primaryColor,
                onTap: controller.phoneAccept,
              ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _playedView1() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xffEBFFCC), const Color(0xffFFFFFF)],
          stops: [0.0, 0.3],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            SATextData.activateBenefits,
            style: TextStyle(
              fontFamily: "Montserrat",
              color: Colors.black,
              fontSize: 40.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 24.w),
          Text(
            SATextData.getAiInteractiveVideoChat,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 56.w),
          ButtonGradientWidget(
            height: 88,
            onTap: controller.pushVip,
            hasShadow: true,
            margin: EdgeInsets.symmetric(horizontal: 75.w),
            child: Center(
              child: Text(
                SATextData.unlockNow,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 28.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 80.w),
        ],
      ),
    );
  }

  // Widget _playedView() {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Container(
  //         padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 32.w),
  //         margin: EdgeInsets.symmetric(horizontal: 30.w),
  //         decoration: BoxDecoration(color: const Color(0xff000000).withValues(alpha: 0.6), borderRadius: BorderRadius.circular(32.r)),
  //         child: Column(
  //           children: [
  //             Text(
  //               SATextData.activateBenefits,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(color: Colors.white, fontSize: 30.sp, fontWeight: FontWeight.w500),
  //             ),
  //             Text(
  //               SATextData.getAiInteractiveVideoChat,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w400, color: Colors.white),
  //             ),
  //           ],
  //         ),
  //       ),

  //       SizedBox(height: 40.w),
  //       ButtonGradientWidget(
  //         height: 96,
  //         onTap: controller.pushVip,
  //         hasShadow: true,
  //         margin: const EdgeInsets.symmetric(horizontal: 40),
  //         child: Center(
  //           child: Text(
  //             SATextData.btnContinue,
  //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 32.sp),
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 80.w),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SacallguideController>(
      init: SacallguideController(),
      id: "sacallguide",
      builder: (_) {
        return Scaffold(body: _buildView());
      },
    );
  }
}
