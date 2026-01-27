import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/message/index.dart';

import 'widgets.dart';

/// 文本消息容器组件
class SATItem extends StatefulWidget {
  const SATItem({super.key, required this.msg, this.title});

  final SAMessageModel msg;
  final String? title;

  @override
  State<SATItem> createState() => _TextItemState();
}

class _TextItemState extends State<SATItem> {
  // 性能优化：使用AppColors统一颜色管理
  static const Color _bgColor = Color(0x60000000);
  static final BorderRadius _borderRadius = BorderRadius.all(
    Radius.circular(24.r),
  );

  // 控制器缓存，避免重复查找
  late final MessageController _ctr;

  @override
  void initState() {
    super.initState();
    _ctr = Get.find<MessageController>();
  }

  @override
  Widget build(BuildContext context) {
    final msg = widget.msg;

    // 错误隔离设计：安全获取消息内容
    final sendText = _getSendTextSafely(msg);
    final receivText = _getReceiveTextSafely(msg);

    // 优化后的显示逻辑判断
    final shouldShowSend = _shouldShowSendMessage(msg, sendText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (shouldShowSend)
          Padding(
            padding: EdgeInsets.only(bottom: 24.w),
            child: SASItem(msg: widget.msg),
          ),
        if (receivText != null) _buildReceiveText(context),
      ],
    );
  }

  /// 错误隔离设计：安全获取发送文本
  String? _getSendTextSafely(SAMessageModel msg) {
    try {
      return msg.question;
    } catch (e) {
      debugPrint('[TextContainer] 获取发送文本失败: $e');
      return null;
    }
  }

  /// 错误隔离设计：安全获取接收文本
  String? _getReceiveTextSafely(SAMessageModel msg) {
    try {
      return msg.answer;
    } catch (e) {
      debugPrint('[TextContainer] 获取接收文本失败: $e');
      return null;
    }
  }

  /// 优化后的发送消息显示判断逻辑
  bool _shouldShowSendMessage(SAMessageModel msg, String? sendText) {
    try {
      if (msg.source == MessageSource.clothe) {
        return false;
      }

      return msg.source == MessageSource.sendText ||
          (sendText != null && msg.onAnswer != true);
    } catch (e) {
      debugPrint('[TextContainer] 判断发送消息显示失败: $e');
      return false;
    }
  }

  Widget _buildReceiveText(BuildContext context) {
    return Obx(() {
      final isVip = _getVipStatusSafely();
      final isLocked = _isMessageLocked();

      if (!isVip && isLocked) {
        return SATLockItem(textContent: widget.msg.answer ?? '');
      }

      return _buildText(context);
    });
  }

  bool _getVipStatusSafely() {
    return SA.login.vipStatus.value;
  }

  bool _isMessageLocked() {
    return widget.msg.textLock == MsgLockLevel.private.value;
  }

  Widget _buildText(BuildContext context) {
    final msg = widget.msg;

    final textContent =
        msg.translateAnswer ??
        msg.answer ??
        "Hmm… we lost connection for a bit. Please try again!";

    final maxWidth = MediaQuery.of(context).size.width * 0.8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: _borderRadius,
          ),
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    widget.title!,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: SAAppColors.primaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              SARicTItem(
                text: textContent,
                isSend: false,
                isTypingAnimation: msg.typewriterAnimated == true,
                onAnimationComplete: () => _handleAnimationComplete(msg),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        if (!_isTypingAnimationActive(msg))
          _buildActionButtons(
            msg: msg,
            showTranslate: false,
            showTransBtn: false,
          ),
      ],
    );
  }

  /// 处理打字动画完成事件
  void _handleAnimationComplete(SAMessageModel msg) {
    try {
      if (msg.typewriterAnimated == true) {
        setState(() {
          msg.typewriterAnimated = false;
          _ctr.state.list.refresh();
        });
      }
    } catch (e) {
      debugPrint('[TextContainer] 处理动画完成失败: $e');
    }
  }

  /// 检查打字动画是否激活
  bool _isTypingAnimationActive(SAMessageModel msg) {
    try {
      return msg.typewriterAnimated == true;
    } catch (e) {
      debugPrint('[TextContainer] 检查动画状态失败: $e');
      return false;
    }
  }

  /// 构建操作按钮行
  Widget _buildActionButtons({
    required SAMessageModel msg,
    required bool showTranslate,
    required bool showTransBtn,
  }) {
    return Wrap(
      spacing: 16.w,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // 只有最后一条消息才显示消息操作按钮
        if (_isLastMessage(msg)) ..._buildMsgActions(msg),

        // 举报按钮（非大屏模式下显示）
        if (!SA.storage.isSAB) _buildReportButton(),
      ],
    );
  }

  /// 检查是否为最后一条消息
  bool _isLastMessage(SAMessageModel msg) {
    try {
      return widget.msg == _ctr.state.list.lastOrNull;
    } catch (e) {
      debugPrint('[TextContainer] 检查最后消息失败: $e');
      return false;
    }
  }

  /// 构建举报按钮
  Widget _buildReportButton() {
    return InkWell(
      onTap: RoutePages.report,
      child: Image.asset(
        'assets/images/sa_23.png',
        width: 48.w,
        fit: BoxFit.contain,
      ),
    );
  }

  /// 构建消息操作按钮组
  List<Widget> _buildMsgActions(SAMessageModel msg) {
    final hasEditAndRefresh = _hasEditAndRefreshActions(msg);

    return [
      // 续写按钮
      _buildContinueButton(),
      // 编辑和刷新按钮（仅特定消息类型）
      if (hasEditAndRefresh) ...[
        _buildEditButton(msg),
        _buildRefreshButton(msg),
      ],
    ];
  }

  /// 判断消息是否支持编辑和刷新操作
  bool _hasEditAndRefreshActions(SAMessageModel msg) {
    try {
      return msg.source == MessageSource.text ||
          msg.source == MessageSource.video ||
          msg.source == MessageSource.audio ||
          msg.source == MessageSource.photo;
    } catch (e) {
      debugPrint('[TextContainer] 检查编辑刷新权限失败: $e');
      return false;
    }
  }

  /// 构建续写按钮
  Widget _buildContinueButton() {
    return RepaintBoundary(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () => _handleContinueWriting(),
        child: Image.asset(
          'assets/images/sa_25.png',
          width: 96.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// 处理续写事件
  void _handleContinueWriting() {
    try {
      _ctr.continueWriting();
    } catch (e) {
      debugPrint('[TextContainer] 续写失败: $e');
    }
  }

  /// 构建编辑按钮
  Widget _buildEditButton(SAMessageModel msg) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => _handleEditMessage(msg),
      child: Image.asset(
        'assets/images/sa_26.png',
        width: 48.w,
        fit: BoxFit.contain,
      ),
    );
  }

  /// 处理编辑消息事件
  void _handleEditMessage(SAMessageModel msg) {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(Duration(milliseconds: 300), () {
      try {
        SmartDialog.show(
          alignment: Alignment.bottomCenter,
          usePenetrate: false,
          clickMaskDismiss: false,
          backType: SmartBackType.normal,
          builder: (context) {
            return SAMsgEditScreen(
              content: msg.answer ?? '',
              onInputTextFinish: (value) {
                SmartDialog.dismiss();
                _ctr.editMsg(value, msg);
              },
            );
          },
        );
      } catch (e) {
        debugPrint('[TextContainer] 编辑消息失败: $e');
      }
    });
  }

  /// 构建刷新按钮
  Widget _buildRefreshButton(SAMessageModel msg) {
    return RepaintBoundary(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () => _handleResendMessage(msg),
        child: Image.asset(
          'assets/images/sa_29.png',
          width: 48.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// 处理重发消息事件
  void _handleResendMessage(SAMessageModel msg) {
    try {
      _ctr.resendMsg(msg);
    } catch (e) {
      debugPrint('[TextContainer] 重发消息失败: $e');
    }
  }
}
