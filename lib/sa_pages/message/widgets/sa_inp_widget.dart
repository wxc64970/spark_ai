import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/index.dart';

import 'widgets.dart';

class SAInpBar extends StatefulWidget {
  const SAInpBar({super.key});

  @override
  State<SAInpBar> createState() => _InputBarState();
}

class _InputBarState extends State<SAInpBar> {
  late TextEditingController textEditingController;
  bool isSend = false;
  final FocusNode focusNode = FocusNode();
  final MessageController ctr = Get.find<MessageController>();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController.addListener(_onInputChange);
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.removeListener(_onInputChange);
    focusNode.dispose();
  }

  void firstClickChatInputBox() async {
    focusNode.unfocus();
    SA.storage.setFirstClickChatInputBox(false);
    setState(() {}); // 更新UI，移除覆盖层

    await DialogWidget.alert(
      message: SATextData.createMaskProfileDescription,
      cancelText: SATextData.cancel,
      confirmText: SATextData.confirm,
      clickMaskDismiss: false,
      onConfirm: () {
        DialogWidget.dismiss();
        Get.toNamed(SARouteNames.mask);
      },
    );
  }

  void _onInputChange() async {
    if (textEditingController.text.length > 500) {
      SAToast.show(SATextData.maxInputLength);
      // 截断文本到500字符
      textEditingController.text = textEditingController.text.substring(0, 500);
      // 将光标移到文本末尾
      textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length),
      );
    }
    isSend = textEditingController.text.isNotEmpty;
    setState(() {});
  }

  // 0  tease, 1 undress, 2 gift, 3 mask, 100 screen, 101 sortlong
  void onTapTag(int index) {
    if (index == 100) {
      FocusManager.instance.primaryFocus?.unfocus();
      Future.delayed(Duration(milliseconds: 300), () {
        editScene(500.w);
      });
    } else if (index == 101) {
      // 聊天模型 chat_model short / long
      showChatModel();
    } else {
      final item = ctr.state.inputTags[index];
      final id = item['id'];

      if (id == 0) {
        List<String> list = item['list'];
        textEditingController.text = list.randomOrNull ?? '';
        onSend();
      } else if (id == 1) {
        Get.toNamed(SARouteNames.undr, arguments: ctr.state.role);
      } else if (id == 2) {
        // showGift();
      } else if (id == 3) {
        Get.toNamed(SARouteNames.mask);
      } else {
        SAToast.show(SATextData.notSupport);
      }
    }
  }

  void editScene(double heigth) {
    SmartDialog.show(
      alignment: Alignment.bottomCenter,
      usePenetrate: false,
      clickMaskDismiss: false,
      backType: SmartBackType.normal,
      builder: (context) {
        return Container(
          width: Get.width,
          decoration: BoxDecoration(color: Colors.transparent),
          child: SAMsgEditScreen(
            content: ctr.state.session.scene ?? '',
            onInputTextFinish: (v) {
              if (v == ctr.state.session.scene) {
                SmartDialog.dismiss();
                return;
              }
              if (!SA.login.vipStatus.value) {
                Get.toNamed(SARouteNames.vip, arguments: VipFrom.scenario);
                return;
              }
              SmartDialog.dismiss();
              ctr.editScene(v);
            },
            subtitle: Text(
              SATextData.editScenario,
              style: TextStyle(
                color: Color(0xff222222),
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            height: heigth,
          ),
        );
      },
    );
  }

  void showChatModel() {
    final isLong = ctr.state.session.chatModel == 'long';
    Get.bottomSheet(
      SAModSheet(
        isLong: isLong,
        onTap: (bool v) {
          ctr.editChatMode(v);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          ctr.state.inputTags.isEmpty
              ? const SizedBox()
              : MsgInputButtons(tags: ctr.state.inputTags, onTap: onTapTag),
          Container(
            padding: EdgeInsets.only(bottom: 28.w),
            child: Stack(
              children: [
                SafeArea(
                  top: false,
                  left: false,
                  right: false,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(56.r),
                    child: Container(
                      color: const Color(0xff212121).withValues(alpha: 0.3),
                      constraints: BoxConstraints(maxHeight: 96.w),
                      child: Row(
                        children: [
                          SizedBox(width: 16.w),
                          _buildSpecialButton(),
                          Flexible(child: _buildTextField()),
                          SizedBox(width: 16.w),
                          ButtonWidget(
                            onTap: onSend,
                            width: 64.w,
                            color: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            child: Center(
                              child: Image.asset(
                                isSend ? 'assets/images/sa_62.png' : 'assets/images/sa_22.png',
                                width: 64.w,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                        ],
                      ),
                    ),
                  ),
                ),
                // 第一次使用时的覆盖层
                if (SA.storage.firstClickChatInputBox)
                  Positioned.fill(child: GestureDetector(onTap: firstClickChatInputBox)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      textInputAction: TextInputAction.send,
      onEditingComplete: onSend,
      minLines: 1,
      maxLines: null,
      style: TextStyle(
        height: 1.2,
        color: Colors.white,
        fontSize: 28.sp,
        fontWeight: FontWeight.w400,
      ),
      controller: textEditingController,
      enableInteractiveSelection: true, // 确保文本选择功能启用
      dragStartBehavior: DragStartBehavior.down, // 优化拖拽行为
      cursorColor: Colors.white,
      decoration: InputDecoration(
        // hintText: LocaleKeys.type_here.tr,
        hintText: SATextData.typeHere,
        hintStyle: const TextStyle(color: Color(0xFFffffff)),
        fillColor: Colors.transparent,
        border: InputBorder.none,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 24.w),
      ),
      autofocus: false,
      focusNode: focusNode,
    );
  }

  void onSend() async {
    String content = textEditingController.text.trim();
    if (content.isNotEmpty) {
      focusNode.unfocus();
      ctr.sendMsg(content);
      textEditingController.clear();
    } else {
      textEditingController.clear();
      return;
    }
    SAlogEvent('c_chat_send');
  }

  Widget _buildSpecialButton() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(focusNode);

        final text = textEditingController.text;
        final selection = textEditingController.selection;

        // Insert "**" at the current cursor position
        final newText = text.replaceRange(selection.start, selection.end, '**');

        // Update the text and set the cursor between the two asterisks
        textEditingController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.fromPosition(TextPosition(offset: selection.start + 1)),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: 20,
        height: 32,
        child: Center(
          child: Text(
            '*',
            style: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class MsgInputButtons extends StatelessWidget {
  const MsgInputButtons({super.key, required this.tags, required this.onTap});

  final List<dynamic> tags;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.w, top: 24.w),
      alignment: Alignment.bottomCenter,
      height: 64.w,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44.w,
              alignment: Alignment.center,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final item = tags[index];
                  int color = item['color'] ?? Colors.black;

                  return GestureDetector(
                    onTap: () => onTap(index),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        color: const Color(0xff212121).withValues(alpha: 0.2),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 24.w),
                        child: Text(
                          item['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Color(color),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemCount: tags.length,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onTap(100);
            },
            child: Image.asset('assets/images/sa_28.png', width: 64.w, fit: BoxFit.contain),
          ),
          SizedBox(width: 32.w),
          GestureDetector(
            onTap: () {
              onTap(101);
            },
            child: Image.asset('assets/images/sa_27.png', width: 64.w, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
