import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SASwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color activeColor;
  final Color thumbColor;
  final Color trackColor;

  const SASwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor = Colors.black,
    this.thumbColor = const Color(0xFFFFFFFF),
    this.trackColor = const Color(0xffD9D9D9),
  });

  @override
  State<SASwitch> createState() => _SASwitchState();
}

class _SASwitchState extends State<SASwitch> {
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
        width: 104.w,
        height: 48.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: value ? widget.activeColor : widget.trackColor,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: value ? 60.w : 4.w,
              right: value ? 4.w : 60.w,
              child: Container(
                width: 40.w,
                height: 40.w,
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
