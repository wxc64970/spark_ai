import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';
import 'widgets.dart';

/// hello
class BuildVideoWidget extends GetView<SachoosevideoController> {
  const BuildVideoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.videoControllers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              spacing: 24.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Get.width,
                  height: 914.w,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: Stack(
                    clipBehavior: Clip.antiAlias,
                    children: [
                      SizedBox(
                        width: Get.width,
                        height: 914.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32.r),
                          child:
                              controller.videoControllers[0].value.isInitialized
                              ? FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: controller
                                        .videoControllers[0]
                                        .value
                                        .size
                                        .width,
                                    height: controller
                                        .videoControllers[0]
                                        .value
                                        .size
                                        .height,
                                    child: VideoPlayer(
                                      controller.videoControllers[0],
                                    ),
                                  ),
                                )
                              : SAImageWidget(
                                  url: controller.videoListData[0].icon,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          width: Get.width,
                          height: Get.height,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.0),
                                Colors.black.withValues(alpha: 0.6),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 24.w,
                        top: 24.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 4.w,
                            horizontal: 16.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xffFF7B52), Color(0xffFFFC64)],
                            ),
                          ),
                          child: Text(
                            SATextData.news,
                            style: TextStyle(
                              fontSize: 32.sp,
                              color: Colors.black,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        width: Get.width,
                        bottom: 32.w,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Center(
                            child: Text(
                              controller.videoListData[0].name ?? '',
                              style: TextStyle(
                                fontSize: 40.sp,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            SAlogEvent(
                              'i2v_template_click',
                              parameters: {
                                "id": controller.videoListData[0].name ?? '',
                              },
                            );
                            controller.playSingleVideo(0);
                            controller.videoDetailIndex.value = 0;
                            Get.bottomSheet(
                              SASheetVideoWidget(),
                              isScrollControlled: true,
                            ).then((value) {
                              controller.playAllPlayers();
                              controller.state.isShowHelp = false;
                              controller.imagePath.value = '';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.w,
                  mainAxisSpacing: 14.w,
                  childAspectRatio: 336 / 448,
                  children: List.generate(
                    controller.videoControllers.length - 1,
                    (index) {
                      var videoItem = controller.videoControllers[index + 1];
                      var item = controller.videoListData[index + 1];
                      return Container(
                        width: 336.w,
                        height: 448.w,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        child: Stack(
                          clipBehavior: Clip.antiAlias,
                          children: [
                            SizedBox(
                              width: 336.w,
                              height: 448.w,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32.r),
                                child: videoItem.value.isInitialized
                                    ? FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width: videoItem.value.size.width,
                                          height: videoItem.value.size.height,
                                          child: VideoPlayer(videoItem),
                                        ),
                                      )
                                    : SAImageWidget(
                                        url: item.icon,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                width: Get.width,
                                height: Get.height,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.0),
                                      Colors.black.withValues(alpha: 0.6),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              width: 336.w,
                              bottom: 24.w,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 32.w),
                                child: Center(
                                  child: Text(
                                    item.name ?? '',
                                    style: TextStyle(
                                      fontSize: 32.sp,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: GestureDetector(
                                onTap: () {
                                  SAlogEvent(
                                    'i2v_template_click',
                                    parameters: {"id": item.name ?? ''},
                                  );
                                  controller.playSingleVideo(index + 1);
                                  controller.videoDetailIndex.value = index + 1;
                                  Get.bottomSheet(
                                    SASheetVideoWidget(),
                                    isScrollControlled: true,
                                  ).then((value) {
                                    controller.playAllPlayers();
                                    controller.state.isShowHelp = false;
                                    controller.imagePath.value = '';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: Get.mediaQuery.padding.bottom + 24.w),
              ],
            );
    });
  }
}
