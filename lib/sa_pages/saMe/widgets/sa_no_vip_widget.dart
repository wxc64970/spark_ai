import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/saMe/controller.dart';

class NonVipWidget extends GetView<SameController> {
  const NonVipWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 48.w, left: 32.w),
          width: Get.width,
          height: 384.w,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/sa_49.png'), fit: BoxFit.contain),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                SATextData.upToVip,
                style: TextStyle(fontFamily: "Montserrat", fontSize: 40.sp, color: Color(0xffDF9A44), fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 16.w),
              SARichTextPlaceholder(
                textKey: SATextData.vipGet1,
                placeholders: {
                  'icon': WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Image.asset('assets/images/sa_47.png', width: 32.w, fit: BoxFit.contain),
                  ),
                },
                style: TextStyle(fontSize: 24.sp, color: Color(0xff808080), fontWeight: FontWeight.w400, height: 1.5),
              ),
            ],
          ),
        ),
        Positioned(
          left: 32.w,
          bottom: 24.w,
          child: ButtonGradientWidget2(
            width: 478.w,
            height: 64,
            gradientColors: [Color(0xffDF9A44), Color(0xffDF9A44).withValues(alpha: 0.5)],
            onTap: controller.onTapExprolreVIP,
            child: Center(
              child: Text(
                SATextData.explore,
                style: TextStyle(fontFamily: "Montserrat", fontSize: 24.sp, color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
