import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

class SAModSheet extends StatelessWidget {
  const SAModSheet({super.key, required this.isLong, required this.onTap});

  final bool isLong;
  final Function(bool) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
          ],
        ),
        SizedBox(height: 32.w),
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
              child: Image.asset("assets/images/sa_10.png", height: 460.w, width: Get.width, fit: BoxFit.cover),
            ),
            Container(
              width: Get.width,
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      SATextData.replyMode,
                      style: TextStyle(fontSize: 32.sp, color: Color(0xff080817), fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 32.w),
                  _buildItem(
                    SATextData.shortReply,
                    !isLong,
                    onTap: () {
                      onTap(false);
                    },
                  ),
                  SizedBox(height: 16.w),
                  _buildItem(
                    SATextData.longReply,
                    isLong,
                    onTap: () {
                      onTap(true);
                    },
                  ),
                  SizedBox(height: 60.w),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItem(String title, bool isSelected, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: const Alignment(0, -1), end: const Alignment(0, 1), colors: [SAAppColors.primaryColor, SAAppColors.yellowColor]),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: isSelected ? EdgeInsets.all(4.w) : EdgeInsets.zero,
          // 边框厚度
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
            child: Container(
              width: Get.width,

              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: isSelected ? SAAppColors.primaryColor.withValues(alpha: 0.13) : Color(0xffF4F7F0)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 36.w),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(32.r)),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset("assets/images/sa_31.png", width: 64.w, fit: BoxFit.contain),
                          SizedBox(width: 16.w),
                          Text(
                            title,
                            style: TextStyle(color: const Color(0xFF000000), fontSize: 24.sp, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    isSelected ? Image.asset("assets/images/sa_32.png", width: 40.w, fit: BoxFit.contain) : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
