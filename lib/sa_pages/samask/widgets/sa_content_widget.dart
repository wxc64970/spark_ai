import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';
import 'widgets.dart';

/// hello
class SAContentWidget extends GetView<SamaskController> {
  const SAContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appBar(),
        SizedBox(height: 24.w),
        Expanded(child: BuildContentWidget()),
        Container(
          padding: EdgeInsets.symmetric(vertical: 40.w, horizontal: 144.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
            boxShadow: [BoxShadow(color: const Color(0x1000001a), offset: const Offset(0, -2), blurRadius: 8, spreadRadius: 0)],
          ),

          child: Column(
            children: [
              Obx(
                () => ButtonGradientWidget(
                  onTap: controller.handleChangeMask,
                  height: 88,
                  borderRadius: BorderRadius.circular(100.r),
                  gradientColors: controller.state.maskList.isEmpty || controller.state.selectedMask.value == null ? [Colors.grey, Colors.grey] : [SAAppColors.primaryColor, SAAppColors.yellowColor],
                  child: Center(
                    child: Text(
                      SATextData.pickIt,
                      style: TextStyle(fontFamily: "Montserrat", color: Colors.black, fontSize: 28.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.mediaQuery.padding.bottom),
            ],
          ),
        ),
      ],
    );
  }

  Widget appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 32.w, right: 32.w),
      child: Stack(
        children: [
          SizedBox(
            height: 64.w,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500.w),
                child: Text(
                  SATextData.selectProfileMask,
                  style: TextStyle(fontSize: 32.sp, color: Colors.black, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Image.asset("assets/images/sa_06.png", width: 48.w, fit: BoxFit.contain),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              onTap: () {
                controller.pushEditPage();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 24.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(104.r),
                  gradient: LinearGradient(colors: [SAAppColors.primaryColor, SAAppColors.yellowColor]),
                ),
                child: Icon(Icons.add, size: 48.w, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
