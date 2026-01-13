import 'package:flutter/material.dart';

class GradientUnderlineTabIndicator extends Decoration {
  /// 渐变样式
  final LinearGradient gradient;

  /// 下标粗细
  final double thickness;

  /// 下标位置/宽度控制
  final EdgeInsetsGeometry insets;

  /// 圆角半径（新增参数）
  final double radius;

  const GradientUnderlineTabIndicator({
    required this.gradient,
    this.thickness = 2.0,
    this.insets = EdgeInsets.zero,
    // 默认圆角半径=线条粗细的一半，视觉更协调
    this.radius = 0.0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GradientUnderlinePainter(
      gradient: gradient,
      thickness: thickness,
      insets: insets,
      radius: radius, // 传递圆角参数
      decoration: this,
    );
  }
}

class _GradientUnderlinePainter extends BoxPainter {
  final LinearGradient gradient;
  final double thickness;
  final EdgeInsetsGeometry insets;
  final double radius; // 新增：圆角半径
  final Decoration decoration;

  _GradientUnderlinePainter({required this.gradient, required this.thickness, required this.insets, required this.radius, required this.decoration});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    // 1. 获取Tab尺寸和insets偏移
    final Rect rect = offset & configuration.size!;
    final EdgeInsets resolvedInsets = insets.resolve(configuration.textDirection);
    final Rect indicatorRect = resolvedInsets.deflateRect(rect);

    // 2. 计算下划线绘制区域
    final double indicatorY = indicatorRect.bottom - thickness;
    final Rect underlineRect = Rect.fromLTWH(indicatorRect.left, indicatorY, indicatorRect.width, thickness);

    // 3. 创建渐变画笔
    final Paint paint = Paint()
      ..shader = gradient.createShader(underlineRect)
      ..style = PaintingStyle.fill;

    // 4. 绘制圆角渐变下划线（核心修改：从drawRect改为drawRRect）
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        underlineRect,
        Radius.circular(radius), // 应用圆角半径
      ),
      paint,
    );
  }
}
