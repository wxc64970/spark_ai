import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';
import 'base_container_widget.dart';
import 'sa_field_title.dart';
import 'widgets.dart';

class DescribeWidget extends GetView<SaaigenerateimageController> {
  const DescribeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseContainerWidget(
      child: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SaFieldTitle(
              title: SATextData.describeImage,
              isRequired: false,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
            SaAiWriteWidget(
              gemCost: SA.login.configPrice?.imgAvatarPrice ?? 40,
              onTap: controller.useAIWrite,
            ),
          ],
        ),
        SizedBox(height: 24.w),
        Container(
          width: Get.width,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Color(0xffF7F7F7),
          ),
          child: TextField(
            controller: controller.descriptionController,
            maxLines: 5,
            maxLength: 2000,
            inputFormatters: [SpecialMarkFormatter()],
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF7F7F7),
              hintText: SATextData.including,
              hintStyle: TextStyle(
                color: Color(0xFFCCCCCC),
                fontSize: 22.sp,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              counterStyle: TextStyle(
                fontSize: 22.sp,
                color: Color(0xFFCCCCCC),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 特殊标记文本输入格式化器
class SpecialMarkFormatter extends TextInputFormatter {
  static const List<String> _specialMarks = [
    ' *X* ',
    ' {user} ',
    ' {char} ',
    '*X*',
    '{user}',
    '{char}',
  ];

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 检测是否是删除操作
    if (newValue.text.length < oldValue.text.length &&
        newValue.selection.isCollapsed) {
      final deletedLength = oldValue.text.length - newValue.text.length;
      final cursorPosition = newValue.selection.baseOffset;

      log.d('删除操作检测: 删除了 $deletedLength 个字符，光标位置: $cursorPosition');

      // 只处理单字符删除（退格键）
      if (deletedLength == 1) {
        return _handleSpecialDeletion(oldValue, newValue, cursorPosition);
      }
    }

    return newValue;
  }

  /// 处理特殊标记的删除
  TextEditingValue _handleSpecialDeletion(
    TextEditingValue oldValue,
    TextEditingValue newValue,
    int cursorPosition,
  ) {
    final oldText = oldValue.text;

    // 检查光标位置前是否有特殊标记
    for (final mark in _specialMarks) {
      final markStart = cursorPosition + 1 - mark.length;

      if (markStart >= 0 && markStart + mark.length <= oldText.length) {
        final textSegment = oldText.substring(
          markStart,
          markStart + mark.length,
        );

        if (textSegment == mark) {
          log.d('检测到特殊标记: "$mark" 在位置 $markStart');

          // 整体删除特殊标记
          final newText = oldText.replaceRange(
            markStart,
            markStart + mark.length,
            '',
          );

          return TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: markStart),
          );
        }
      }
    }

    // 没有找到特殊标记，返回原始的删除结果
    return newValue;
  }
}
