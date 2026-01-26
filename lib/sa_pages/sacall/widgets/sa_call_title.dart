import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

class SACallTitle extends StatelessWidget {
  const SACallTitle({super.key, required this.role, this.onTapClose});

  final ChaterModel role;
  final VoidCallback? onTapClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 32.w, right: 32.w, top: Get.mediaQuery.padding.top + 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: onTapClose,
                child: Image.asset("assets/images/close.png", width: 48.w, fit: BoxFit.contain),
              ),
            ],
          ),
          SizedBox(height: 226.w),
          SizedBox(
            width: Get.width,
            child: Column(
              spacing: 24.w,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: SAAppColors.primaryColor,
                    borderRadius: BorderRadius.circular(110.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2.w), // 边框厚度
                    child: SAImageWidget(
                      url: role.avatar,
                      width: 220.w,
                      height: 220.w,
                      shape: BoxShape.circle,
                      cacheWidth: 220,
                      cacheHeight: 220,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16.w,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 300.w),
                      child: Text(
                        role.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                    if (role.age != null)
                      // Text(
                      //   StringData.ageYearsOlds(role.age.toString()),
                      //   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFFDEDEDE)),
                      // )
                      Container(
                        constraints: BoxConstraints(maxWidth: 70.w),
                        padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.r),
                          gradient: LinearGradient(
                            begin: Alignment(math.cos(164 * math.pi / 180), math.sin(-100 * math.pi / 180)),
                            end: Alignment(
                              math.cos(164 * math.pi / 180 + math.pi),
                              math.sin(-100 * math.pi / 180 + math.pi),
                            ),
                            colors: [SAAppColors.primaryColor, SAAppColors.yellowColor],
                          ),
                        ),
                        child: Text(
                          '${role.age}',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 18.sp,
                            color: Colors.black,
                            height: 1,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
