import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/saaiphoto/widgets/sa_mak_widget.dart';

import '../index.dart';

/// hello
class SaContentWidget extends GetView<SaundrController> {
  const SaContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appBar(),
        SizedBox(height: 20.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: SAMakWidget(key: const ValueKey('page'), role: controller.role, type: SAAiViewType.role),
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
              child: Text(
                SATextData.createProfileMask,
                style: TextStyle(fontSize: 32.sp, color: Colors.black, fontWeight: FontWeight.w600),
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
        ],
      ),
    );
  }
}
