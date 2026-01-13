import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/saMe/controller.dart';

import 'sa_content.dart';

class SaContentWidget extends GetView<SameController> {
  const SaContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Padding(
        padding: EdgeInsets.only(left: 32.w, right: 32.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/images/sa_48.png", width: 192.w, fit: BoxFit.contain),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed(SARouteNames.gems, arguments: ConsumeFrom.home);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.w),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r), color: Colors.white),
                        child: Row(
                          children: [
                            Image.asset("assets/images/sa_09.png", width: 40.w, fit: BoxFit.contain),
                            SizedBox(width: 8.w),
                            Obx(
                              () => Text(
                                SA.login.gemBalance.toString(),
                                style: TextStyle(fontFamily: "Montserrat", fontSize: 32.sp, color: SAAppColors.pinkColor, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 36.w),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 200.w),
                child: ContentWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
