import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spark_ai/saCommon/index.dart';

class _TipsStyle {
  _TipsStyle._();

  static double fontSize = 20.sp;
  static double borderRadius = 66.r;
  static EdgeInsets padding = EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w);
  static const Color backgroundColor = Color(0x60000000);
  static const FontWeight fontWeight = FontWeight.w400;
  static const Color textColor = Colors.white;

  static TextStyle textStyle = TextStyle(color: textColor, fontSize: fontSize, fontWeight: fontWeight);

  static BorderRadius borderRadiusGeometry = BorderRadius.all(Radius.circular(borderRadius));
}

/// Tips内容组件
class SATipItem extends StatelessWidget {
  const SATipItem({super.key, required this.msg});

  final SAMessageModel msg;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: _TipsStyle.padding,
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          decoration: BoxDecoration(color: _TipsStyle.backgroundColor, borderRadius: _TipsStyle.borderRadiusGeometry),

          child: Text(
            msg.answer ?? '',
            textAlign: TextAlign.center,
            style: _TipsStyle.textStyle, // 使用缓存的样式对象
          ),
        ),
      ],
    );
  }
}
