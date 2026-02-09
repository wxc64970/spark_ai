import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spark_ai/saCommon/sa_values/index.dart';

/// AI写作按钮组件
class SaAiWriteWidget extends StatelessWidget {
  final VoidCallback onTap;
  final int gemCost;

  const SaAiWriteWidget({super.key, required this.onTap, this.gemCost = 80});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: SAAppColors.pinkColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4.w,
          children: [
            Image.asset(
              "assets/images/sa_39.png",
              width: 40.w,
              fit: BoxFit.contain,
            ),
            Text(
              SATextData.aiWrite,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4.w),
            Image.asset(
              "assets/images/sa_20.png",
              width: 32.w,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 4.w),
            Text(
              '$gemCost',
              style: TextStyle(
                fontFamily: "Montserrat",
                color: SAAppColors.pinkColor,
                fontSize: 26.sp,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
