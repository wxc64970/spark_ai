import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';

class imageStyleItem extends GetView<SaaigenerateimageController> {
  final ImageStyle data;
  const imageStyleItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => controller.handleSelectStyleImages(data),
        child: Container(
          margin: EdgeInsets.only(right: 32.w),
          child: Column(
            spacing: 8.w,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        width: 2.w,
                        color:
                            data.id == controller.selectImageStyleData.value.id
                            ? SAAppColors.primaryColor
                            : Colors.transparent,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: SAImageWidget(
                        width: 120.w,
                        height: 120.w,
                        url: data.cover,
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ),
                  data.id == controller.selectImageStyleData.value.id
                      ? Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: SAAppColors.primaryColor.withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
              SizedBox(
                width: 120.w,
                child: Text(
                  data.name ?? '',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: data.id == controller.selectImageStyleData.value.id
                        ? Colors.black
                        : Color(0xff808080),
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
