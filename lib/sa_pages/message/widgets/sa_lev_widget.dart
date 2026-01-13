import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';

/// hello
class SALelWidget extends GetView<MessageController> {
  const SALelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.state.chatLevel.value;
      if (data == null) {
        return const SizedBox();
      }

      var level = data.level ?? 1;
      var progress = (data.progress ?? 0) / 100.0;
      var rewards = '+${data.rewards ?? 0}';

      var value = controller.formatNumber(data.progress);
      // var total = data.upgradeRequirements?.toInt() ?? 0;
      // var proText = '$value/$total';

      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          // AppRoutes.pushProfile(ctr.role);
          Get.toNamed(SARouteNames.profile, arguments: controller.state.role);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 32.w),
          padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 24.w),
          decoration: BoxDecoration(
            border: Border.all(width: 2.w, color: Color(0xffF77DF3).withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(32.r),
            color: Color(0xff212121).withValues(alpha: 0.3),
          ),
          child: Row(
            children: [
              SAImageWidget(
                url: controller.state.role.avatar,
                width: 104.w,
                height: 104.w,
                shape: BoxShape.circle,
                cacheWidth: 104,
                cacheHeight: 104,
                // borderRadius: BorderRadius.circular(10),
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Lv $level',
                              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: "Montserrat"),
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              '$value%',
                              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset("assets/images/sa_20.png", width: 40.w, fit: BoxFit.contain),
                            SizedBox(width: 8.w),
                            Text(
                              rewards,
                              style: TextStyle(fontFamily: "Poppins", fontSize: 28.sp, color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 19.w),
                    SAAnimationProgress(progress: progress, height: 8.w, borderRadius: 24.w, width: Get.width),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
