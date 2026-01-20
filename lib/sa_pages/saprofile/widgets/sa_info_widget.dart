import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller.dart';

class InfoWidget extends GetView<SaprofileController> {
  const InfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 32.w),
        margin: EdgeInsets.only(bottom: 32.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(46.r),
          boxShadow: [BoxShadow(color: const Color(0x61C5E7B3), offset: const Offset(0, 8), blurRadius: 8, spreadRadius: 0)],
          color: Colors.white,
        ),
        child: Text(
          controller.role.aboutMe ?? '',
          style: TextStyle(fontSize: 28.sp, color: Color(0xff4D4D4D), fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
