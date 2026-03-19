import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/saaiphoto/widgets/sa_mak_widget.dart';

import 'index.dart';

class SaaiimagePage extends GetView<SaaiimageController> {
  const SaaiimagePage({super.key});

  // 主视图
  Widget _buildView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 32.w, right: 32.w),
          child: Stack(
            children: [
              Center(
                child: Text(
                  SATextData.undress,
                  style: TextStyle(
                    fontSize: 32.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Obx(
                () => Row(
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
                            // SAlogEvent('aiphoto_photobalance_click');
                            controller.hanldeSku(ConsumeFrom.aiphoto);
                          },
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
              ),
            ],
          ),
        ),
        SizedBox(height: 32.w),
        Expanded(
          child: SAMakWidget(
            key: ValueKey(controller.type),
            type: controller.type,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaaiimageController>(
      init: SaaiimageController(),
      id: "saaiimage",
      builder: (_) {
        return baseScaffold(body: _buildView());
      },
    );
  }
}
