import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/sacallguide/widgets/sa_call_button.dart';

import '../index.dart';
import 'sa_call_title.dart';

/// hello
class SAContentWidget extends GetView<SacallController> {
  const SAContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SAImageWidget(
            url: controller.guideVideo?.gifUrl ?? controller.role.avatar,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          ),
        ),
        Column(
          children: [
            SACallTitle(role: controller.role, onTapClose: controller.onTapHangup),
            SizedBox(height: 72.w),
            Obx(() => _buildTimer()),
            Expanded(child: Container()),
            Obx(() => _buildLoading()),
            Obx(() => _buildAnswering()),
            SizedBox(height: 56.w),
            Obx(() => Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: _buildButtons())),
            SizedBox(height: 80.w),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildButtons() {
    List<Widget> buttons = [SACallButton(icon: 'assets/images/call_hangup.png', onTap: controller.onTapHangup, bgColor: Color(0xffEB5C46))];

    if (controller.callState.value == CallState.incoming) {
      buttons.add(SACallButton(icon: 'assets/images/call_answer.png', bgColor: SAAppColors.primaryColor, onTap: controller.onTapAccept));
    }

    if (controller.callState.value == CallState.listening) {
      buttons.add(SACallButton(icon: 'assets/images/voice_on.png', bgColor: SAAppColors.primaryColor, animationColor: SAAppColors.primaryColor, onTap: () => controller.onTapMic(false)));
    }

    if (controller.callState.value == CallState.answering || controller.callState.value == CallState.micOff || controller.callState.value == CallState.answered) {
      buttons.add(SACallButton(icon: 'assets/images/voice_off.png', bgColor: Color(0xff000000).withValues(alpha: 0.6), onTap: () => controller.onTapMic(true)));
    }

    return buttons;
  }

  Widget _buildAnswering() {
    final text = controller.callStateDescription(controller.callState.value);
    if (text.isEmpty) {
      return Container();
    }

    return SizedBox(
      width: Get.width - 60,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 24.w),
          decoration: BoxDecoration(color: const Color(0xff212121).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(42.r)),
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white, fontSize: 32.w, fontWeight: FontWeight.w400),
            child: AnimatedTextKit(
              key: ValueKey(controller.callState.value),
              totalRepeatCount: 1,
              animatedTexts: [TypewriterAnimatedText(text, speed: const Duration(milliseconds: 50), cursor: '')],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    if (controller.callState.value == CallState.calling || controller.callState.value == CallState.answering || controller.callState.value == CallState.listening) {
      return LoadingAnimationWidget.progressiveDots(color: Colors.white, size: 40);
    }
    return Container();
  }

  Widget _buildTimer() {
    if (controller.showFormattedDuration.value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 38.w, vertical: 12.w),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40.r), color: Colors.white.withValues(alpha: 0.1)),
            child: Row(
              spacing: 10.w,
              children: [
                Container(
                  decoration: BoxDecoration(color: const Color(0xFFF04A4C), borderRadius: BorderRadius.circular(100.r)),
                  width: 16.w,
                  height: 16.w,
                ),
                Text(
                  controller.formattedDuration(controller.callDuration.value),
                  style: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
