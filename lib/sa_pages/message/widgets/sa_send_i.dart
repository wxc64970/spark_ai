import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'widgets.dart';

class SASItem extends StatelessWidget {
  const SASItem({super.key, required this.msg});

  final SAMessageModel msg;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sendText = msg.question ?? '';
    final showLoading = _shouldShowLoadingIndicator();
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [_buildMessageContainer(sendText, screenWidth, context), if (showLoading) _buildLoadingIndicator(context)],
    );
  }

  /// 构建消息容器
  Widget _buildMessageContainer(String text, double screenWidth, BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Align(
      alignment: isRTL ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [Color(0xff9376F7), Color(0xffCD78E2), Color(0xffF8CB69)],
          //   begin: Alignment(-0.2, -3),
          //   end: Alignment(0.2, 3),
          //   stops: const [0.3, 0.6, 0.9],
          //   // 4. 渐变超出范围时的填充模式（确保底部完全是目标色）
          //   tileMode: TileMode.clamp,
          // ),
          color: Color(0xffE2FFB4),
          borderRadius: BorderRadius.circular(24.r),
        ),
        constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
        child: RepaintBoundary(child: SATypTItem(text: text, isSend: false, isTypingAnimation: false)),
      ),
    );
  }

  /// 判断是否显示加载指示器
  bool _shouldShowLoadingIndicator() {
    try {
      return msg.onAnswer == true;
    } catch (e) {
      debugPrint('[SendContainer] 检查加载状态失败: $e');
      return false;
    }
  }

  /// 构建加载指示器
  Widget _buildLoadingIndicator(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Align(
      alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 64.0,
        height: 44.0,
        margin: const EdgeInsets.only(top: 16.0),
        decoration: const BoxDecoration(color: Color(0x801C1C1C), borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: Center(
          child: LoadingAnimationWidget.horizontalRotatingDots(color: SAAppColors.primaryColor, size: 28.sp),
        ),
      ),
    );
  }
}
