import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../controller.dart';
import 'sa_aiphoto_widget.dart';

class SaContentWidget extends GetView<SaaiphotoController> {
  const SaContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Padding(
        padding: EdgeInsets.only(left: 32.w, right: 32.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 24.w,
                    children: [
                      InkWell(
                        onTap: () {
                          SAlogEvent('aiphoto_photobalance_click');
                          controller.hanldeSku(ConsumeFrom.aiphoto);
                        },
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
                                SA.login.imgCreationCount.value.toString(),
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
                      InkWell(
                        onTap: () {
                          SAlogEvent('aiphoto_videobalance_click');
                          controller.hanldeSku(ConsumeFrom.img2v);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.w,
                            horizontal: 12.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.r),
                            color: SAAppColors.yellowColor,
                          ),
                          child: Row(
                            spacing: 8.w,
                            children: [
                              Image.asset(
                                "assets/images/sa_77.png",
                                width: 32.w,
                                fit: BoxFit.contain,
                              ),
                              Text(
                                SA.login.videoCreationCount.value.toString(),
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
                  InkWell(
                    onTap: () {
                      SAlogEvent('aiphoto_creations_click');
                      controller.handleHistory();
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.r),
                        color: Colors.white,
                      ),
                      child: Row(
                        spacing: 8.w,
                        children: [
                          Image.asset(
                            "assets/images/sa_78.png",
                            width: 48.w,
                            fit: BoxFit.contain,
                          ),
                          Text(
                            SATextData.creations,
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Color(0xffEC9DF7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.w),
            // Expanded(child: SAAIPhotoTabbar()),
            Obx(
              () => Expanded(
                child: controller.aiPhotoList!.isEmpty
                    ? SizedBox()
                    : AiphotoWidget(aiPhotoList: controller.aiPhotoList!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
