import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/sa_pages/saMe/controller.dart';

class SettingItem extends GetView<SameController> {
  const SettingItem({Key? key, this.sectionTitle, required this.title, this.onTap, required this.top, this.subtitle, this.subWidget}) : super(key: key);
  final String? sectionTitle;
  final String title;
  final String? subtitle;
  final Function()? onTap;
  final double top;
  final Widget? subWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionTitle != null)
          Padding(
            padding: EdgeInsets.only(top: top.w, bottom: 16.w),
            child: Text(
              sectionTitle!,
              style: TextStyle(fontSize: 28.sp, color: Color(0xff666666), fontWeight: FontWeight.w500),
            ),
          ),
        InkWell(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(top: top.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 28.sp, color: Color(0xff1A1A1A), fontWeight: FontWeight.w500),
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Text(
                      subtitle!,
                      style: TextStyle(fontSize: 28.sp, color: Color(0xffB3B3B3), fontWeight: FontWeight.w500),
                    ),
                  ),
                Image.asset("assets/images/sa_51.png", width: 40.w, fit: BoxFit.contain),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
