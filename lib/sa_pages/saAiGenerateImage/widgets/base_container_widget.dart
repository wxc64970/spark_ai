import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BaseContainerWidget extends StatelessWidget {
  final List<Widget> child;
  const BaseContainerWidget({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.only(bottom: 24.w),
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24.w,
        children: [...child],
      ),
    );
  }
}
