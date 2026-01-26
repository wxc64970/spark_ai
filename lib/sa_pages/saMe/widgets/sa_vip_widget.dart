import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/saMe/controller.dart';

class VipWidget extends GetView<SameController> {
  const VipWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40.w, left: 48.w),
      width: Get.width,
      height: 184.w,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/sa_50.png'), fit: BoxFit.contain),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            SATextData.vipMember,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 40.sp,
              color: Color(0xffDF9A44),
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8.w),
          Obx(() {
            SA.login.vipStatus.value;
            final timer = SA.login.currentUser?.subscriptionEnd ?? DateTime.now().millisecondsSinceEpoch;
            final date = formatTimestamp(timer);
            return Text.rich(
              style: TextStyle(fontSize: 28.sp, color: Color(0xff4D4D4D), fontWeight: FontWeight.w400),
              TextSpan(
                children: [
                  TextSpan(text: SATextData.deadline('')),
                  TextSpan(
                    text: date,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontFamily: "Montserrat",
                      color: Color(0xff2F2E35),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
