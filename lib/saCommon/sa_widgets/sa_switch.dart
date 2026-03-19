import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SASwitchGradient extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  // final Color activeColor;
  final Color thumbColor;
  // final Color trackColor;
  final List<Color> activeColor;
  final List<Color> trackColor;
  final String? text;

  const SASwitchGradient({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor = const [Color(0xffADFD32), Color(0xffFDFA32)],
    this.thumbColor = const Color(0xffFFFFFF),
    this.trackColor = const [Color(0xff808080), Color(0xff808080)],
    this.text,
  });

  @override
  State<SASwitchGradient> createState() => _SASwitchState();
}

class _SASwitchState extends State<SASwitchGradient> {
  @override
  Widget build(BuildContext context) {
    bool value = widget.value; // 直接使用传入的 value 控制外观

    return GestureDetector(
      onTap: () {
        setState(() {
          value = !value;
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        });
      },
      child: Container(
        height: 48.w,
        padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          // color: value ? widget.activeColor : widget.trackColor,
          gradient: LinearGradient(
            colors: value ? widget.activeColor : widget.trackColor,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.text != null)
              Padding(
                padding: EdgeInsets.only(
                  right: value ? 40.w : 0,
                  left: value ? 0 : 40.w,
                ),
                child: Center(
                  child: Text(
                    widget.text ?? '',
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      color: value ? Colors.black : Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: value ? 60.w : -36.w,
              right: value ? -36.w : 60.w,
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.thumbColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
