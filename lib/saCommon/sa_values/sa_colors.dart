import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SAAppColors {
  static const Color primaryColor = Color(0xffADFD32);
  //黄色
  static const Color yellowColor = Color(0xffFDFA32);
  //粉色
  static const Color pinkColor = Color(0xFFF77DF3);

  // 浅色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // fontFamily: "Montserrat",
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Color(0xffF6F7FB),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 24.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  // 暗色主题
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: "Montserrat",
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Color(0xffF6F7FB),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 24.sp, fontWeight: FontWeight.w600),
      ),
    );
  }
}
