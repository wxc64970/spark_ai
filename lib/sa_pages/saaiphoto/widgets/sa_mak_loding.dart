import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spark_ai/saCommon/index.dart';

class SAMakLoading extends StatelessWidget {
  const SAMakLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF000000).withValues(alpha: 0.85),
      width: double.infinity,
      padding: EdgeInsets.all(30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.hexagonDots(color: Colors.white, size: 40.w),
          SizedBox(height: 16.w),
          Text(
            SATextData.ai_generating,
            style: TextStyle(color: Colors.white70, fontSize: 20.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 40.w),
          Text(
            SATextData.ai_generating_masterpiece,
            style: TextStyle(color: SAAppColors.primaryColor, fontSize: 28.sp, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16.w),
          Text(
            SATextData.ai_art_consumes_power,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
