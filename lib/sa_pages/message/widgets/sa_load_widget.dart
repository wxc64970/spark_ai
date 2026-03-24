import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/index.dart';

import 'sa_t_item.dart';

class SALoadingWidget extends StatefulWidget {
  const SALoadingWidget({super.key, this.msg});
  final SAMessageModel? msg;

  @override
  State<SALoadingWidget> createState() => _SALoadingWidgetState();
}

class _SALoadingWidgetState extends State<SALoadingWidget>
    with SingleTickerProviderStateMixin {
  static final Map<String, double> _progressCache = {};

  var imageWidth = 200.0;
  var imageHeight = 240.0;
  // 动画控制器（核心：总时长 30 秒）
  late AnimationController _controller;
  // 百分比动画（0 → 0.99 对应 0% → 99%）
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    final messageId = widget.msg?.id;
    final cachedValue = messageId != null ? _progressCache[messageId] : null;
    final startValue = (cachedValue ?? 0.0).clamp(0.0, 0.99);

    // 1. 创建动画控制器：时长 30 秒
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // 🔥 固定 30 秒
      value: startValue,
    );

    // 2. 动画范围：0 → 0.99（对应 0% → 99%）
    _animation =
        Tween<double>(begin: 0, end: 0.99).animate(
          CurvedAnimation(parent: _controller, curve: Curves.linear), // 线性匀速递增
        )..addListener(() {
          final messageId = widget.msg?.id;
          if (messageId != null) {
            _progressCache[messageId] = _animation.value;
          }
        });

    // 3. 自动开始播放
    if (_controller.value < 0.99) {
      _controller.forward(from: _controller.value);
    }

    // 4. 监听动画结束（到 99% 自动停止，并保存完成状态）
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop(); // 到达 99% 停止
        // 动画完成时，明确保存 1.0 到缓存，确保再次进入时不会退回
        final messageId = widget.msg?.id;
        if (messageId != null) {
          _progressCache[messageId] = 1.0;
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant SALoadingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldId = oldWidget.msg?.id;
    final newId = widget.msg?.id;
    if (newId != null && newId != oldId) {
      final cachedValue = _progressCache[newId] ?? 0.0;
      // 如果缓存值已经接近或等于完成状态（>= 0.98），直接设置为 0.99 并停止
      if (cachedValue >= 0.98) {
        _controller.value = 0.99;
        _controller.stop();
      } else {
        _controller.value = cachedValue.clamp(0.0, 0.99);
        if (_controller.value < 0.99) {
          _controller.forward(from: _controller.value);
        } else {
          _controller.stop();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // 释放动画（防内存泄漏）
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SATItem(msg: widget.msg!),
        const SizedBox(height: 8),
        SizedBox(
          width: imageWidth,
          height: imageHeight,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SAImageWidget(
                  url: widget.msg!.imgUrl ?? '',
                  width: imageWidth,
                  height: imageHeight,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              Positioned(
                width: imageWidth,
                height: imageHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24.w, sigmaY: 24.w),
                    child: Container(
                      color: const Color(0xff000000).withValues(alpha: 0.2),
                      child:
                          widget.msg!.generatedStatus ==
                              GenStatus.failed.apiValue
                          ? Center(
                              child: Icon(
                                Icons.error,
                                size: 48.w,
                                color: Colors.red,
                              ),
                            )
                          : Column(
                              spacing: 24.w,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 88.w,
                                  height: 88.w,
                                  child: LoadingAnimationWidget.hexagonDots(
                                    color: Colors.white,
                                    size: 88.w,
                                  ),
                                ),
                                AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    // 计算当前百分比（取整数：0~99）
                                    final int currentPercent =
                                        (_animation.value * 100).toInt();

                                    return Text(
                                      '$currentPercent%',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// class SALoadingWidget extends StatelessWidget {
//   const SALoadingWidget({super.key, this.msg});
//   final SAMessageModel? msg;

//   @override
//   Widget build(BuildContext context) {
//     final isRTL = Directionality.of(context) == TextDirection.rtl;

//     return Align(
//       alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         width: 64.0,
//         height: 44.0,
//         margin: const EdgeInsets.only(top: 16.0),
//         decoration: const BoxDecoration(
//           color: Color(0x801C1C1C),
//           borderRadius: BorderRadius.all(Radius.circular(16.0)),
//         ),
//         child: Center(
//           child: LoadingAnimationWidget.horizontalRotatingDots(
//             color: SAAppColors.primaryColor,
//             size: 28.sp,
//           ),
//         ),
//       ),
//     );
//   }
// }
