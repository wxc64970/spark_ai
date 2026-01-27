import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget baseScaffold({Widget? body}) {
  return Scaffold(
    resizeToAvoidBottomInset: true, // 确保键盘弹出时正确调整布局
    body: Stack(
      children: [
        Image.asset('assets/images/sa_01.png', width: Get.width, fit: BoxFit.contain),
        SizedBox(
          width: Get.width,
          height: Get.height,
          child: Padding(
            padding: EdgeInsets.only(top: Get.mediaQuery.padding.top + 14.w),
            child: body,
          ),
        ),
      ],
    ),
  );
}
