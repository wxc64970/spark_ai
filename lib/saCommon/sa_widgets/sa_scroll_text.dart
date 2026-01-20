import 'package:flutter/material.dart';

class SAAutoHeightScrollText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;

  /// 文本宽度（默认充满父容器）
  final double? width;
  final TextAlign textAlign;
  // 新增：是否启用精准行高计算（默认开启）
  final bool preciseHeight;

  const SAAutoHeightScrollText({super.key, required this.text, this.style, this.maxLines = 3, this.width, this.textAlign = TextAlign.start, this.preciseHeight = true});

  @override
  State<SAAutoHeightScrollText> createState() => _SAAutoHeightScrollTextState();
}

class _SAAutoHeightScrollTextState extends State<SAAutoHeightScrollText> {
  double _maxHeight = 0.0;
  double _actualHeight = 0.0;
  bool _needScroll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTextHeights();
    });
  }

  @override
  void didUpdateWidget(covariant SAAutoHeightScrollText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.style != widget.style ||
        oldWidget.maxLines != widget.maxLines ||
        oldWidget.width != widget.width ||
        oldWidget.preciseHeight != widget.preciseHeight) {
      _calculateTextHeights();
    }
  }

  /// 修复核心：精准计算文本高度（包含行高、行间距、基线）
  void _calculateTextHeights() {
    if (widget.text.isEmpty) {
      setState(() {
        _maxHeight = 0;
        _actualHeight = 0;
        _needScroll = false;
      });
      return;
    }

    // 1. 获取文本显示宽度
    final double textWidth = widget.width ?? (context.findRenderObject() as RenderBox?)?.size.width ?? MediaQuery.of(context).size.width - 32;

    // 2. 构建基础文本样式（默认样式兜底）
    final defaultStyle = TextStyle(
      fontSize: 14,
      color: Colors.black87,
      height: 1.0, // 默认行高倍数
    );
    final TextStyle targetStyle = widget.style ?? defaultStyle;

    // 3. 初始化TextPainter（关键：匹配Text的所有样式参数）
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: targetStyle),
      textDirection: TextDirection.ltr,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      // 关键：启用strutStyle，匹配Text的行支撑样式（解决行高偏差）
      strutStyle: StrutStyle(fontSize: targetStyle.fontSize, height: targetStyle.height, fontStyle: targetStyle.fontStyle, fontWeight: targetStyle.fontWeight, fontFamily: targetStyle.fontFamily),
    );

    // 4. 计算「指定行数的最大高度」
    textPainter.layout(maxWidth: textWidth);
    double maxLineHeight = textPainter.size.height;

    // 5. 计算「文本实际总高度」（取消行数限制）
    textPainter.maxLines = null;
    textPainter.layout(maxWidth: textWidth);
    double actualHeight = textPainter.size.height;

    // 6. 精准行高修正（补全行高/基线偏移）
    if (widget.preciseHeight && targetStyle.height != null) {
      // 获取字体的原始行高
      final fontMetrics = textPainter.text!.style!.fontSize! * (targetStyle.height ?? 1.0);
      // 修正多行文本的高度（适配行高倍数）
      final lineCount = textPainter.computeLineMetrics().length;
      actualHeight = fontMetrics * lineCount;
      // 修正指定行数的最大高度
      maxLineHeight = fontMetrics * widget.maxLines;
    }

    // 7. 判断是否需要滚动
    final needScroll = actualHeight > maxLineHeight;

    setState(() {
      _maxHeight = maxLineHeight;
      _actualHeight = actualHeight;
      _needScroll = needScroll;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      widget.text,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: _needScroll ? null : widget.maxLines,
      softWrap: true,
      overflow: _needScroll ? TextOverflow.visible : TextOverflow.ellipsis,
      // 关键：匹配TextPainter的strutStyle，确保行高一致
      strutStyle: StrutStyle(height: widget.style?.height, fontSize: widget.style?.fontSize),
    );

    final containerHeight = _needScroll ? _maxHeight : _actualHeight;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: containerHeight, minHeight: 0),
      child: _needScroll
          ? Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(physics: const AlwaysScrollableScrollPhysics(), child: textWidget),
            )
          : textWidget,
    );
  }
}
