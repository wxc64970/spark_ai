import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SAGemTagWidgets extends StatelessWidget {
  const SAGemTagWidgets({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: const Alignment(0, -0.5), end: const Alignment(1, 0.5), colors: const [Color(0xFFFF7B52), Color(0xFFFFFC64)]),
                borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(24.r), bottomEnd: Radius.circular(24.r)),
              ),
              child: Center(
                child: Text(
                  tag,
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600, color: Color(0xff222222)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
