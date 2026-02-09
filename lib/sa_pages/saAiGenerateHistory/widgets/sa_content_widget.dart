import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';
import 'sa_aigeneratehistory_tabbar.dart';

/// hello
class SAContextWidget extends GetView<SaaigeneratehistoryController> {
  const SAContextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: Get.width,
        height: Get.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 32.w, right: 32.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 64.w,
                            child: Text(
                              SATextData.creations,
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
                                  onTap: () {
                                    controller.toggleEditMode();
                                  },
                                  child: Image.asset(
                                    "assets/images/sa_39.png", // 编辑图标
                                    width: 48.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 32.w),
                    Expanded(child: SaAiGenerateHistoryTabbar()),
                  ],
                ),
              ),
            ),
            !controller.isEdit.value
                ? SizedBox.shrink()
                : Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 40.w,
                    ),
                    width: Get.width,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ButtonWidget(
                              width: 334.w,
                              height: 88.w,
                              onTap: () => controller.deleteHistory(),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(134.r),
                                  border: Border.all(
                                    width: 2.w,
                                    color: Colors.black,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 8.w,
                                  children: [
                                    Image.asset(
                                      "assets/images/sa_85.png",
                                      width: 48.w,
                                      fit: BoxFit.contain,
                                    ),
                                    Text(
                                      '${SATextData.delete} (${controller.selectedIDs.length})',
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ButtonGradientWidget(
                                  width: 334.w,
                                  height: 88,
                                  onTap: () {
                                    //下载选中图片或视频
                                    controller.downloadSelected();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 8.w,
                                    children: [
                                      Image.asset(
                                        "assets/images/sa_86.png",
                                        width: 48.w,
                                        fit: BoxFit.contain,
                                      ),
                                      Text(
                                        SATextData.save,
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: -24.w,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadiusDirectional.only(
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
                          ],
                        ),
                        SizedBox(height: Get.mediaQuery.padding.bottom),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
