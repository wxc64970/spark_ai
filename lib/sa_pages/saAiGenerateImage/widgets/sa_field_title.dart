import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../index.dart';

class SaFieldTitle extends GetView<SaaigenerateimageController> {
  final String title;
  final bool isRequired;
  final String? subtitle;
  final Widget? trailing;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? titleColor;
  const SaFieldTitle({
    super.key,
    required this.title,
    this.isRequired = false,
    this.subtitle,
    this.trailing,
    this.fontSize = 26,
    this.fontWeight = FontWeight.w500,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize.sp,
            fontWeight: fontWeight,
            color: Colors.black,
          ),
        ),
        if (isRequired)
          Text(
            '*',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xffFF5182),
            ),
          ),
        if (subtitle != null && subtitle!.isNotEmpty)
          Text(
            subtitle ?? "",
            style: TextStyle(fontSize: 22.sp, color: Color(0xff808080)),
          ),
      ],
    );
  }
}
