import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';
import 'widgets.dart';

/// hello
class SAContentWidget extends GetView<SachoosevideoController> {
  const SAContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      SATextData.chooseVideo,
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
                          onTap: () => controller.hanldeSku(ConsumeFrom.star),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.w,
                              horizontal: 16.w,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.r),
                              color: Colors.white,
                            ),
                            child: Row(
                              spacing: 8.w,
                              children: [
                                Image.asset(
                                  "assets/images/sa_89.png",
                                  width: 32.w,
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  SA.login.starCount.value.toString(),
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
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: const BuildVideoWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
