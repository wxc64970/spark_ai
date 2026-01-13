import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';

/// hello
class OptionSheet extends GetView<SaprofileController> {
  const OptionSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SizedBox(width: 32.w),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Image.asset("assets/images/close.png", width: 48.w, fit: BoxFit.contain),
            ),
            Expanded(child: SizedBox.shrink()),
          ],
        ),
        SizedBox(height: 32.w),
        Container(
          padding: EdgeInsets.symmetric(vertical: 40.w, horizontal: 32.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32.w), topRight: Radius.circular(32.w)),
            gradient: LinearGradient(colors: [Color(0xffEBFFCC), Color(0xffFFFFFF)], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0, 0.3]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  SATextData.more,
                  style: TextStyle(fontSize: 32.sp, color: Color(0xff222222), fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 32.w),
              GestureDetector(
                onTap: controller.clearHistory,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 32.w),
                  decoration: BoxDecoration(color: const Color(0xffF4F7F0), borderRadius: BorderRadius.circular(24.r)),
                  child: Row(
                    children: [
                      Image.asset("assets/images/sa_58.png", width: 40.w, fit: BoxFit.contain),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Text(
                          SATextData.clearHistory,
                          style: TextStyle(color: const Color(0xFF666666), fontSize: 28.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Image.asset("assets/images/sa_51.png", width: 40.w, fit: BoxFit.contain),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.w),
              GestureDetector(
                onTap: controller.handleReport,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 32.w),
                  decoration: BoxDecoration(color: const Color(0xffF4F7F0), borderRadius: BorderRadius.circular(24.r)),
                  child: Row(
                    children: [
                      Image.asset("assets/images/sa_55.png", width: 40.w, fit: BoxFit.contain),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Text(
                          SATextData.report,
                          style: TextStyle(color: const Color(0xFF666666), fontSize: 28.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Image.asset("assets/images/sa_51.png", width: 40.w, fit: BoxFit.contain),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.w),
              ButtonGradientWidget(
                height: 96,
                width: Get.width,
                onTap: controller.deleteChat,
                gradientColors: [Color(0xffFD4A32), Color(0xffFD4A32)],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/sa_59.png", width: 48.w, fit: BoxFit.contain),
                    SizedBox(width: 20.w),
                    Text(
                      SATextData.deleteChat,
                      style: TextStyle(fontSize: 32.sp, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60.w),
            ],
          ),
        ),
      ],
    );
  }
}
