import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../../../main.dart';

class SAUnLView extends StatelessWidget {
  const SAUnLView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log.d('clicked vip space');
      },
      child: Container(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset("assets/images/sa_34.png", width: Get.width, fit: BoxFit.contain),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 456.w,
                padding: EdgeInsets.symmetric(vertical: 64.w, horizontal: 32.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          SATextData.unlockRole,
                          style: TextStyle(fontFamily: "Montserrat", color: Color(0xff080817), fontSize: 40.sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 24.w),
                        Text(
                          SATextData.unlockRoleDescription,
                          style: TextStyle(color: Color(0xff4D4D4D), fontSize: 28.sp, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 56.w),
                        ButtonGradientWidget(
                          hasShadow: true,
                          gradientColors: [Color(0xffF77DF3), Color(0xffA67DF7)],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                SATextData.unlockNow,
                                style: TextStyle(fontFamily: "Montserrat", color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          onTap: () {
                            Get.toNamed(SARouteNames.vip, arguments: VipFrom.viprole);
                          },
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      top: -150.w,
                      child: Image.asset("assets/images/sa_33.png", fit: BoxFit.cover, width: 200.w),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(color: Colors.transparent, width: 60, height: 44),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
