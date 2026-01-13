import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';

class SalaunchscreenPage extends GetView<SalaunchscreenController> {
  const SalaunchscreenPage({super.key});

  // 主视图
  Widget _buildView() {
    return Stack(
      children: [
        SizedBox(width: Get.width, height: Get.height),
        Image.asset("assets/images/sa_01.png", width: Get.width, height: 600.w, fit: BoxFit.contain),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 360.w),
              Image.asset("assets/images/sa_60.png", width: 200.w, fit: BoxFit.contain),
              SizedBox(height: 32.w),
              Image.asset("assets/images/sa_61.png", width: 226.w, fit: BoxFit.contain),
              SizedBox(height: 60.w),
              Center(child: LoadingAnimationWidget.halfTriangleDot(color: SAAppColors.primaryColor, size: 30)),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalaunchscreenController>(
      init: SalaunchscreenController(),
      id: "salaunchscreen",
      builder: (_) {
        return Scaffold(body: _buildView());
      },
    );
  }
}
