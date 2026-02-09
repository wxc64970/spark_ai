import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:spark_ai/saCommon/index.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    this.child,
    this.borderRadius,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.height = 48.0,
    this.width,
    this.constraints,
    this.onTap,
    this.padding,
    this.margin,
    this.color = const Color(0x33FFFFFF),
    this.hasShadow = false,
  });

  final Widget? child;
  final BorderRadius? borderRadius;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final double? height;
  final double? width;
  final BoxConstraints? constraints;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color color;
  // 新增阴影开关参数（可选）
  final bool hasShadow;

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(100.r);

    // 预计算颜色，避免在InkWell中重复计算
    final interactionColor = color.withValues(alpha: 0.5);

    // // 预定义阴影效果，避免每次build时创建
    // final boxShadow = hasShadow
    //     ? [
    //         const BoxShadow(
    //           color: _shadowColor,
    //           offset: _shadowOffset,
    //           blurRadius: _shadowBlurRadius,
    //           spreadRadius: _shadowSpreadRadius,
    //         ),
    //       ]
    //     : null;

    Widget buttonChild = Container(
      height: height,
      width: width,
      constraints: constraints,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: br,
        boxShadow: null,
      ),
      child: child ?? const SizedBox.shrink(),
    );

    // 如果没有点击事件，直接返回容器，避免InkWell开销
    if (onTap == null) {
      return margin != null
          ? Padding(padding: margin!, child: buttonChild)
          : buttonChild;
    }

    buttonChild = InkWell(
      onTap: onTap,
      focusColor: focusColor ?? interactionColor,
      hoverColor: hoverColor ?? interactionColor,
      highlightColor: highlightColor ?? interactionColor,
      borderRadius: br,
      child: buttonChild,
    );

    return margin != null
        ? Padding(padding: margin!, child: buttonChild)
        : buttonChild;
  }
}

class ButtonGradientWidget extends StatelessWidget {
  const ButtonGradientWidget({
    super.key,
    this.child,
    this.borderRadius,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.height = 96.0,
    this.width,
    this.onTap,
    this.padding,
    this.margin,
    this.gradientColors = const [
      SAAppColors.primaryColor,
      SAAppColors.yellowColor,
    ],
    this.hasShadow = false,
  });

  final Widget? child;
  final BorderRadius? borderRadius;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  // 新增阴影开关参数（可选）
  final bool hasShadow;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(100.r);

    // 预计算颜色，避免在InkWell中重复计算
    final interactionColor = Colors.transparent;

    Widget buttonChild = Container(
      height: height?.w,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: br,
        gradient: LinearGradient(
          colors: gradientColors,
          // begin: Alignment(-0.2, -3),
          // end: Alignment(0.2, 3),
          // stops: const [0.3, 0.6, 0.9],
          // 4. 渐变超出范围时的填充模式（确保底部完全是目标色）
          tileMode: TileMode.clamp,
        ),
        boxShadow: null,
      ),
      child: child ?? const SizedBox.shrink(),
    );

    // 如果没有点击事件，直接返回容器，避免InkWell开销
    if (onTap == null) {
      return margin != null
          ? Padding(padding: margin!, child: buttonChild)
          : buttonChild;
    }

    buttonChild = Center(
      child: InkWell(
        onTap: onTap,
        focusColor: focusColor ?? interactionColor,
        hoverColor: hoverColor ?? interactionColor,
        highlightColor: highlightColor ?? interactionColor,
        splashColor: interactionColor,
        borderRadius: br,
        child: buttonChild,
      ),
    );

    return margin != null
        ? Padding(padding: margin!, child: buttonChild)
        : buttonChild;
  }
}

class ButtonGradientWidget2 extends StatelessWidget {
  const ButtonGradientWidget2({
    super.key,
    this.child,
    this.borderRadius,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.height = 96.0,
    this.width,
    this.onTap,
    this.padding,
    this.margin,
    this.gradientColors = const [
      SAAppColors.primaryColor,
      SAAppColors.yellowColor,
    ],
    this.hasShadow = false,
  });

  final Widget? child;
  final BorderRadius? borderRadius;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  // 新增阴影开关参数（可选）
  final bool hasShadow;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(100.r);

    // 预计算颜色，避免在InkWell中重复计算
    final interactionColor = Colors.transparent;

    Widget buttonChild = Container(
      height: height?.w,
      width: width,
      padding: padding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: br,
        gradient: LinearGradient(
          colors: gradientColors,
          begin: const Alignment(-0.9563, 0.2924),
          end: const Alignment(0.9563, -0.2924),
          stops: const [0.6312, 1.1721],
        ),
      ),
      child: Shimmer(child: child ?? const SizedBox.shrink()),
    );

    // 如果没有点击事件，直接返回容器，避免InkWell开销
    if (onTap == null) {
      return margin != null
          ? Padding(padding: margin!, child: buttonChild)
          : buttonChild;
    }

    buttonChild = Center(
      child: InkWell(
        onTap: onTap,
        focusColor: focusColor ?? interactionColor,
        hoverColor: hoverColor ?? interactionColor,
        highlightColor: highlightColor ?? interactionColor,
        splashColor: interactionColor,
        borderRadius: br,
        child: buttonChild,
      ),
    );

    return margin != null
        ? Padding(padding: margin!, child: buttonChild)
        : buttonChild;
  }
}
