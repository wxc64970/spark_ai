import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/index.dart';

import '../index.dart';

/// hello
class BuildImageRatioWidget extends GetView<SatexttoimageController> {
  const BuildImageRatioWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SATextData.imageRatio,
          style: TextStyle(
            fontSize: 28.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        Wrap(
          direction: Axis.horizontal,
          spacing: 10.w,
          children: [
            ...List.generate(controller.state.imageRatioList.length, (index) {
              var item = controller.state.imageRatioList[index];
              return Obx(
                () => GestureDetector(
                  onTap: () {
                    controller.state.selectImageRatio = item['value'];
                  },
                  child: SizedBox(
                    width: 164.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: Get.width,
                          height: 64.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Colors.white,
                            border: Border.all(
                              width: 2.w,
                              color:
                                  controller.state.selectImageRatio ==
                                      item['value']
                                  ? SAAppColors.pinkColor
                                  : Colors.white,
                            ),
                          ),
                          child: Row(
                            spacing: 16.w,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: getImageWidget(index),
                                height: getImageHeight(index),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.r),
                                  border: Border.all(
                                    width: 2.w,
                                    color: Color(0xffE6E6E6),
                                  ),
                                ),
                              ),
                              Text(
                                item['value'] ?? '',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: Color(0xff1A1A1A),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.w),
                        Text(
                          item['name'] ?? '',
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Color(0xff666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}

double getImageWidget(int index) {
  switch (index) {
    case 0:
      return 28.w;
    case 1:
      return 24.w;
    case 2:
      return 22.w;
    case 3:
      return 26.w;
    default:
      return 28.w;
  }
}

double getImageHeight(int index) {
  switch (index) {
    case 0:
      return 28.w;
    case 1:
      return 30.w;
    case 2:
      return 30.w;
    case 3:
      return 30.w;
    default:
      return 28.w;
  }
}
