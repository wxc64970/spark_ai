import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spark_ai/saCommon/index.dart';

class SettingMessageBackground extends StatelessWidget {
  const SettingMessageBackground({super.key, required this.onTapUpload, required this.onTapUseChat, required this.isUseChater});

  final VoidCallback onTapUpload;
  final VoidCallback onTapUseChat;
  final bool isUseChater;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 55.w),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              DialogWidget.dismiss();
            },
            child: Image.asset("assets/images/close.png", width: 48.w, height: 48.w),
          ),
        ),
        SizedBox(height: 32.w),
        Container(
          padding: EdgeInsets.symmetric(vertical: 48.w, horizontal: 40.w),
          margin: EdgeInsets.symmetric(horizontal: 55.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xffEBFFCC), Colors.white], stops: [0, 0.3]),
            borderRadius: BorderRadius.circular(32.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 16.w,
            children: [
              Text(
                SATextData.setChatBackground,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 34.sp, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              SizedBox(height: 8.w),
              isUseChater ? _buildButton(SATextData.uploadAPhoto, onTapUpload) : _buildSelectButton(SATextData.uploadAPhoto),
              isUseChater ? _buildSelectButton(SATextData.useAvatar) : _buildButton(SATextData.useAvatar, onTapUseChat),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String title, VoidCallback onTap) {
    return ButtonWidget(
      onTap: onTap,
      height: 88.w,
      borderRadius: BorderRadius.circular(24.r),
      color: Color(0xffF4F7F0),
      child: Row(
        children: [
          SizedBox(width: 40.w),
          Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 24.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectButton(String title) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [SAAppColors.primaryColor, SAAppColors.yellowColor]),
        borderRadius: BorderRadius.circular(16.r),
      ),

      child: Padding(
        padding: EdgeInsets.all(4.w), // 边框厚度
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16.r)), color: Colors.white),
          child: Container(
            height: 88.w,
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16.r)), color: SAAppColors.primaryColor.withValues(alpha: 0.13)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 16.w,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 24.sp, fontWeight: FontWeight.w600),
                ),
                Image.asset("assets/images/sa_32.png", width: 40.w, height: 40.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
