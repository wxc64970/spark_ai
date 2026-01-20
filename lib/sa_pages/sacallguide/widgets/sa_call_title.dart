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
          Stack(
            children: [
              SizedBox(
                width: Get.width,
                child: Column(
                  spacing: 16.w,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(color: SAAppColors.primaryColor, borderRadius: BorderRadius.circular(100.r)),
                      child: Padding(
                        padding: EdgeInsets.all(2.w), // 边框厚度
                        child: SAImageWidget(url: role.avatar, width: 96.w, height: 96.w, shape: BoxShape.circle, cacheWidth: 96, cacheHeight: 96),
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
                            padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 12.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.r),
                              gradient: LinearGradient(colors: [Color(0xff93E278), Color(0xffF8CB69)]),
                            ),
                            child: Text(
                              '${role.age}',
                              style: TextStyle(fontSize: 24.sp, color: Color(0xff080817), height: 1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 32.w,
                top: 0,
                child: InkWell(
                  onTap: onTapClose,
                  child: Image.asset("assets/images/close.png", width: 48.w, fit: BoxFit.contain),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
