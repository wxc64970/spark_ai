import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/saCommon/sa_models/sa_cha_model.dart';

import '../controller.dart';

class TagWidget extends GetView<SaprofileController> {
  const TagWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tags = controller.role.tags;
    if (tags == null || tags.isEmpty) {
      return const SizedBox();
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 32.w),
      margin: EdgeInsets.only(bottom: 32.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(46.r),
        boxShadow: [BoxShadow(color: const Color(0x61C5E7B3), offset: const Offset(0, 8), blurRadius: 8, spreadRadius: 0)],
        color: Colors.white,
      ),
      child: GridView.builder(
        itemCount: tags.length,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 固定 2 列
          crossAxisSpacing: 14.w, // 列之间的间距
          mainAxisSpacing: 16.w, // 行之间的间距
          childAspectRatio: 148 / 46, // 子项宽高比（宽/高），控制网格项形状
        ),
        itemBuilder: (context, index) {
          Color textColor = SAAppColors.pinkColor;
          String text = tags[index];
          if (text == kNSFW || text == kBDSM) {
            textColor = SAAppColors.primaryColor;
          }
          return Container(
            width: 148.w,
            height: 46.w,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.w), color: Color(0xffFFF1FF)),
            child: Center(
              child: Text(
                text,
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500, color: textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }
}
