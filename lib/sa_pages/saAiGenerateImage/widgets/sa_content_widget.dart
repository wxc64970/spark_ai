import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';
import 'ai_generate_image_tabbar.dart';

/// hello
class SAContentWidget extends GetView<SaaigenerateimageController> {
  const SAContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 32.w, right: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          height: 64.w,
                          child: Text(
                            SATextData.aiGenerateImage,
                            style: TextStyle(
                              fontSize: 32.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset(
                              "assets/images/sa_06.png",
                              width: 48.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Row(
                            spacing: 24.w,
                            children: [
                              InkWell(
                                onTap: () =>
                                    controller.hanldeSku(ConsumeFrom.aiphoto),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 6.w,
                                    horizontal: 16.w,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.r),
                                    color: SAAppColors.primaryColor,
                                  ),
                                  child: Row(
                                    spacing: 8.w,
                                    children: [
                                      Image.asset(
                                        "assets/images/sa_75.png",
                                        width: 32.w,
                                        fit: BoxFit.contain,
                                      ),
                                      Text(
                                        SA.login.imgCreationCount.value
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Image.asset(
                                        "assets/images/sa_76.png",
                                        width: 32.w,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.w),
                Expanded(child: AiGenerateImageTabbar()),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 144.w, vertical: 32.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x1000001a),
                offset: const Offset(0, -2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
            color: Colors.white,
          ),

          child: Column(
            children: [
              Obx(
                () => ButtonGradientWidget(
                  onTap: controller.state.isClick
                      ? controller.createImage
                      : null,
                  height: 96,
                  borderRadius: BorderRadius.circular(100.r),
                  gradientColors: !controller.state.isClick
                      ? [Color(0xffF7F7F7), Color(0xffF7F7F7)]
                      : [SAAppColors.primaryColor, SAAppColors.yellowColor],
                  child: Center(
                    child: Text(
                      SATextData.createImage,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.black,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.mediaQuery.padding.bottom),
            ],
          ),
        ),
      ],
    );
  }
}
