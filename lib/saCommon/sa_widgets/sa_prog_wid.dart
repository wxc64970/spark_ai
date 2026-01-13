import 'package:flutter/cupertino.dart';
import 'package:spark_ai/saCommon/index.dart';

class SAAnimationProgress extends StatefulWidget {
  final double progress; // 当前进度，0.0 - 1.0
  final double width;
  final double height;
  final List<Color> gradientColors; // 渐变色列表
  final Color trackColor; // 轨道颜色
  final double borderRadius; // 圆角半径
  final Duration animationDuration; // 动画时长

  const SAAnimationProgress({
    super.key,
    required this.progress,
    this.width = 250,
    this.height = 6,
    this.gradientColors = const [SAAppColors.pinkColor, Color(0xffA67DF7)], // 默认渐变色
    this.trackColor = const Color(0xFF000000), // 默认轨道颜色
    this.borderRadius = 3.0,
    this.animationDuration = const Duration(milliseconds: 300), // 默认动画时长
  }) : assert(progress >= 0.0 && progress <= 1.0, 'Progress must be between 0.0 and 1.0');

  @override
  State<SAAnimationProgress> createState() => _SAAnimationProgressState();
}

class _SAAnimationProgressState extends State<SAAnimationProgress> {
  late double _currentProgress;

  @override
  void initState() {
    super.initState();
    _currentProgress = widget.progress; // 初始化当前进度
  }

  @override
  void didUpdateWidget(covariant SAAnimationProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress) {
      // 如果 progress 值发生变化，更新状态
      setState(() {
        _currentProgress = widget.progress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(color: widget.trackColor.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(widget.borderRadius)),
      child: Stack(
        children: [
          // 使用 AnimatedContainer 为进度条添加动画
          AnimatedContainer(
            duration: widget.animationDuration,
            curve: Curves.easeInOut, // 使用平滑的动画曲线
            width: widget.width * _currentProgress, // 动态调整宽度
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: widget.gradientColors, begin: Alignment.centerLeft, end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
        ],
      ),
    );
  }
}
