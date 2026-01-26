import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spark_ai/saCommon/index.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  final ValueNotifier<Duration> _timeNotifier = ValueNotifier(const Duration(minutes: 30));
  Timer? _timer;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          SATextData.expirationTime,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 4),
        ValueListenableBuilder<Duration>(
          valueListenable: _timeNotifier,
          builder: (context, value, child) {
            final minutesStr = value.inMinutes.toString().padLeft(2, '0');
            final secondsStr = (value.inSeconds % 60).toString().padLeft(2, '0');
            return Row(
              children: [
                _buildDigit(minutesStr),
                SizedBox(width: 4.w),
                Text(
                  ':',
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600,
                    color: SAAppColors.pinkColor,
                  ),
                ),
                SizedBox(width: 4.w),
                _buildDigit(secondsStr),
              ],
            );
          },
        ),
      ],
    );
  }

  Container _buildDigit(String digit) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(8.r)),
      child: Center(
        child: Text(
          digit,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: SAAppColors.pinkColor,
          ),
        ),
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = _timeNotifier.value;
      if (current.inSeconds == 0) {
        timer.cancel();
      } else {
        _timeNotifier.value = Duration(seconds: current.inSeconds - 1);
      }
    });
  }
}
