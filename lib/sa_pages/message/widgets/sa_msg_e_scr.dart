import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

class SAMsgEditScreen extends StatefulWidget {
  const SAMsgEditScreen({
    super.key,
    required this.onInputTextFinish,
    this.content,
    this.subtitle,
    this.height,
  });

  final String? content;
  final Widget? subtitle;
  final double? height;
  final Function(String text) onInputTextFinish;

  @override
  State<SAMsgEditScreen> createState() => _MessageEditScreenState();
}

class _MessageEditScreenState extends State<SAMsgEditScreen> {
  final focusNode = FocusNode();
  final textController = TextEditingController();

  @override
  void initState() {
    // focusNode.requestFocus();
    focusNode.unfocus();
    textController.addListener(_onTextChanged);
    if (widget.content != null && widget.content!.isNotEmpty) {
      textController.text = widget.content!;
    }
    super.initState();
  }

  void _onTextChanged() {
    if (textController.text.length > 500) {
      SmartDialog.showToast(SATextData.maxInputLength, displayType: SmartToastType.onlyRefresh);
      // 截断文本到500字符
      textController.text = textController.text.substring(0, 500);
      // 将光标移到文本末尾
      textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length),
      );
    }
  }

  void _onSure() {
    focusNode.unfocus();
    // 将值回调出去
    widget.onInputTextFinish(textController.text.trim());
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusNode.requestFocus(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(width: 32.w),
              InkWell(
                onTap: () {
                  focusNode.unfocus();
                  Get.back();
                },
                child: Image.asset("assets/images/close.png", width: 48.w, fit: BoxFit.contain),
              ),
            ],
          ),
          SizedBox(height: 32.w),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r),
                ),
                child: Image.asset(
                  "assets/images/sa_10.png",
                  width: Get.width,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 36.w, horizontal: 32.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.r),
                    topRight: Radius.circular(32.r),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.subtitle != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 0,
                          ).copyWith(bottom: 6),
                          child: widget.subtitle!,
                        ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32.r),
                          border: Border.all(color: Color(0xffF4F7F0), width: 2.w),
                        ),
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            // 阻止滚动通知传播到父级，避免与底部表单的拖拽冲突
                            return true;
                          },
                          child: TextField(
                            autofocus: true,
                            textInputAction: TextInputAction.newline, // 修改为换行操作
                            maxLines: widget.height == null ? 7 : 7, // 允许多行输入
                            minLines: widget.height == null ? 7 : 7, // 最小显示5行
                            maxLength: null,
                            enableInteractiveSelection: true, // 确保文本选择功能启用
                            dragStartBehavior: DragStartBehavior.down, // 优化拖拽行为
                            style: TextStyle(
                              height: 1.5, // 增加行高
                              color: Color(0xff212121),
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            controller: textController,
                            cursorColor: Color(0xff212121),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero, // 添加内边距
                              // hintText: LocaleKeys.please_input_custom_text.tr,
                              hintText: SATextData.pleaseInputCustomText,
                              counterText: '',
                              hintStyle: const TextStyle(color: Color(0xFFB3B3B3)),
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                              filled: true,
                              isDense: true,
                            ),
                            focusNode: focusNode,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 296.w,
                            margin: EdgeInsets.only(
                              top: 32.w,
                              bottom: Get.mediaQuery.viewInsets.bottom,
                            ),
                            child: ButtonGradientWidget(
                              height: 64,
                              width: Get.width,
                              onTap: _onSure,
                              child: Center(
                                child: Text(
                                  SATextData.confirm,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
