import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';

/// hello
class SAContentWidget extends GetView<SaaigenerateresultController> {
  const SAContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(width: Get.width, height: Get.height),
        Positioned.fill(
          child: Obx(
            () => SAImageWidget(
              url: controller.state.imageUrls[controller.state.selectedIndex],
            ),
          ),
        ),
        SafeArea(
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Get.back();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 32.w),
              child: Image.asset(
                "assets/images/sa_21.png",
                width: 48.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [imageListWidget(), bottomWidget()],
          ),
        ),
      ],
    );
  }

  Widget imageListWidget() {
    return Container(
      width: Get.width,
      height: 212.w,
      margin: EdgeInsets.symmetric(horizontal: 32.w, vertical: 84.w),
      child: ListView.separated(
        itemCount: controller.state.imageUrls.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => SizedBox(width: 40.w),
        itemBuilder: (context, index) {
          return Obx(
            () => GestureDetector(
              onTap: () {
                controller.state.selectedIndex = index;
              },
              child: Stack(
                children: [
                  SAImageWidget(
                    url: controller.state.imageUrls[index],
                    width: 160.w,
                    height: 212.w,
                    cacheWidth: 80 * 2,
                    cacheHeight: 106 * 2,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: index == controller.state.selectedIndex
                          ? SAAppColors.primaryColor
                          : Colors.transparent,
                      width: 4.w,
                    ),
                  ),
                  index == controller.state.selectedIndex
                      ? Container(
                          width: 160.w,
                          height: 212.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: SAAppColors.primaryColor.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget bottomWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Color(0xB3000000), Color(0xF5000000)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        spacing: 32.w,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () async {
              await SA.login.fetchUserInfo();
              if (SA.login.vipStatus.value) {
                SAlogEvent('imageresult_save_click');
                controller.downloadImageToGallery();
              } else {
                Get.toNamed(SARouteNames.vip, arguments: VipFrom.downloadimage);
              }
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 96.w,
                  height: 96.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: Colors.white24,
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/sa_79.png",
                      width: 48.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: -30.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(16.w),
                        topEnd: Radius.circular(16.w),
                        bottomEnd: Radius.circular(16.w),
                      ),
                      color: Color(0xffFFD9FE),
                    ),
                    child: Text(
                      'Pro',
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Color(0xFF000000),
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ButtonGradientWidget(
              onTap: () {
                SAlogEvent('imageresult_createmore_click');
                Get.until(
                  (route) =>
                      route.settings.name == SARouteNames.aiGenerateImage,
                );
              },
              width: 558.w,
              height: 88,
              child: Center(
                child: Text(
                  SATextData.createMore,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 28.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
