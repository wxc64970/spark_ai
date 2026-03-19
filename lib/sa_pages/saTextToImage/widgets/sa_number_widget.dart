import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/index.dart';

import '../index.dart';

/// hello
class BuildNumberWidget extends GetView<SatexttoimageController> {
  const BuildNumberWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          SATextData.numberOfImages,
          style: TextStyle(
            fontSize: 28.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          width: 240.w,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
          ),
          child: Row(
            children: [
              _buildMinusWidget(),
              Expanded(
                child: Obx(
                  () => Center(
                    child: Text(
                      controller.state.numberOfImages.toString(),
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: Color(0xff1A1A1A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              _buildPlusWidget(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMinusWidget() {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.handleNumberOfImages(0),
        child: Container(
          height: 32.w,
          width: 32.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: controller.state.numberOfImages == 1
                ? Color(0xff1A1A1A).withValues(alpha: 0.6)
                : const Color(0xff1A1A1A),
          ),
          child: Center(
            child: Icon(
              Icons.remove,
              color: Colors.white,
              size: 28.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlusWidget() {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.handleNumberOfImages(1),
        child: Container(
          height: 32.w,
          width: 32.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: controller.state.numberOfImages == 6
                ? Color(0xff1A1A1A).withValues(alpha: 0.6)
                : const Color(0xff1A1A1A),
          ),
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 28.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
