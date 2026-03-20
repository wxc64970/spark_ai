import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';

/// hello
class SASheetVideoWidget extends GetView<SachoosevideoController> {
  const SASheetVideoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SizedBox(width: 32.w),
            InkWell(
              onTap: () {
                Get.back();
                controller.playAllPlayers();
              },
              child: Image.asset(
                "assets/images/close.png",
                width: 48.w,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        SizedBox(height: 32.w),
        Container(
          width: Get.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/sa_10.png"),
              fit: BoxFit.fitWidth,
              alignment: AlignmentGeometry.topCenter,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.w),
              topRight: Radius.circular(32.w),
            ),
            color: Colors.white,
          ),
          child: Obx(
            () => Container(
              padding: EdgeInsets.symmetric(vertical: 48.w, horizontal: 32.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          controller
                                  .videoListData[controller
                                      .videoDetailIndex
                                      .value]
                                  .name ??
                              '',
                          style: TextStyle(
                            fontSize: 32.sp,
                            color: Color(0xff222222),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: () {
                          controller.state.isShowHelp =
                              !controller.state.isShowHelp;
                        },
                        child: Image.asset(
                          "assets/images/sa_91.png",
                          width: 48.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.w),
                  Text(
                    SATextData.ai_image_to_video,
                    style: TextStyle(fontSize: 28.sp, color: Color(0xff4D4D4D)),
                  ),
                  SizedBox(height: 32.w),
                  Stack(
                    children: [
                      Row(
                        spacing: 14.w,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              controller.imagePath.value.isEmpty
                                  ? SAImageWidget(
                                      width: 336.w,
                                      height: 448.w,
                                      url: controller
                                          .videoListData[controller
                                              .videoDetailIndex
                                              .value]
                                          .icon,
                                      borderRadius: BorderRadius.circular(16.r),
                                    )
                                  : Container(
                                      width: 336.w,
                                      height: 448.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                      ),
                                      child: Image.file(
                                        File(controller.imagePath.value),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.6),
                                        Colors.black.withValues(alpha: 0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                bottom: 24.w,
                                width: 336.w,
                                child: Center(
                                  child: ButtonGradientWidget(
                                    onTap: () => controller.onTapUpload(),
                                    width: 280.w,
                                    height: 64,
                                    borderRadius: BorderRadius.circular(100.r),
                                    child: Center(
                                      child: Text(
                                        SATextData.uploadAPhoto,
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 24.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              SizedBox(
                                width: 336.w,
                                height: 448.w,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.r),
                                  child:
                                      controller
                                          .videoControllers[controller
                                              .videoDetailIndex
                                              .value]
                                          .value
                                          .isInitialized
                                      ? FittedBox(
                                          fit: BoxFit.cover,
                                          child: SizedBox(
                                            width: controller
                                                .videoControllers[controller
                                                    .videoDetailIndex
                                                    .value]
                                                .value
                                                .size
                                                .width,
                                            height: controller
                                                .videoControllers[controller
                                                    .videoDetailIndex
                                                    .value]
                                                .value
                                                .size
                                                .height,
                                            child: VideoPlayer(
                                              controller
                                                  .videoControllers[controller
                                                  .videoDetailIndex
                                                  .value],
                                            ),
                                          ),
                                        )
                                      : SAImageWidget(
                                          url: controller
                                              .videoListData[controller
                                                  .videoDetailIndex
                                                  .value]
                                              .icon,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.6),
                                        Colors.black.withValues(alpha: 0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                bottom: 24.w,
                                width: 336.w,
                                child: Center(
                                  child: Text(
                                    controller
                                            .videoListData[controller
                                                .videoDetailIndex
                                                .value]
                                            .name ??
                                        '',
                                    style: TextStyle(
                                      fontSize: 32.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        left: 320.w,
                        top: 200.w,
                        width: 40.w,
                        height: 40.w,
                        child: Center(
                          child: Image.asset(
                            "assets/images/sa_90.png",
                            width: 40.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  controller.state.isShowHelp
                      ? Container(
                          width: Get.width,
                          margin: EdgeInsets.symmetric(vertical: 16.w),
                          padding: EdgeInsets.symmetric(
                            vertical: 16.w,
                            horizontal: 24.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: const Color(0xffF7F7F7),
                          ),
                          child: Text(
                            SATextData.videoHelp,
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Color(0xff4D4D4D),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),

                  SizedBox(height: 32.w),
                  Center(
                    child: ButtonWidget(
                      width: 462.w,
                      height: 88.w,
                      onTap: () => controller.onTapGen(),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(134.r),
                          color: Colors.black,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 8.w,
                          children: [
                            Text(
                              SATextData.ai_generate,
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.white,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Image.asset(
                              "assets/images/sa_89.png",
                              width: 32.w,
                              fit: BoxFit.contain,
                            ),
                            Text(
                              SA.login.priceConfig?.i2v.toString() ?? '0',
                              style: TextStyle(
                                color: SAAppColors.yellowColor,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.mediaQuery.padding.bottom + 20.w),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
