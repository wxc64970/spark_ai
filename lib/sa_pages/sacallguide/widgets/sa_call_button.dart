import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pulsator/pulsator.dart';
// import 'package:spark_ai/sa_pages/sacallguide/widgets/sa_water.dart';

// import 'widgets.dart';

class SACallButton extends StatelessWidget {
  const SACallButton({super.key, required this.icon, this.animationColor, this.bgColor, required this.onTap, this.isLinearGradientBg = false});

  final String icon;
  final bool isLinearGradientBg;
  final Color? animationColor;
  final Color? bgColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                if (animationColor != null)
                  Positioned(
                    left: 0,
                    bottom: -69.w,
                    child: SizedBox(
                      width: 334.w,
                      height: 250.w,
                      child: Pulsator(
                        style: PulseStyle(color: animationColor!),
                        count: 5,
                        duration: Duration(seconds: 4),
                        repeat: 0,
                        startFromScratch: false,
                        autoStart: true,
                        fit: PulseFit.contain,
                      ),
                    ),
                  ),
                Container(
                  width: 334.w,
                  height: 112.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.r), color: bgColor),
                ),
                // icon,
                Image.asset(icon, width: 64.w, fit: BoxFit.contain),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
