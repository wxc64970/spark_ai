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
        // Image.asset("assets/images/strat_bg@2x.png", width: Get.width, height: Get.height, fit: BoxFit.cover),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset("assets/images/logo@2x.png", width: 232.w, fit: BoxFit.contain),
              SizedBox(height: 60.w),
              Center(child: LoadingAnimationWidget.dotsTriangle(color: SAAppColors.primaryColor, size: 30)),
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
