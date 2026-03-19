import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/index.dart';

import '../index.dart';

/// hello
class BuildDescriptionWidget extends GetView<SatexttoimageController> {
  const BuildDescriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                SATextData.inputDescription,
                style: TextStyle(
                  fontSize: 28.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () => controller.clearDescription(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: const Color(0xffF7F7F7),
                  ),
                  child: Row(
                    spacing: 8.w,
                    children: [
                      Image.asset(
                        "assets/images/sa_58.png",
                        width: 48.w,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        SATextData.clear,
                        style: TextStyle(
                          fontSize: 22.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            decoration: BoxDecoration(
              color: const Color(0xffF7F7F7),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Obx(
              () => TextField(
                controller: controller.descriptionController,
                maxLength: SaeditmaskController.maxOtherInfoLength,
                maxLines: 5,
                minLines: 5,
                cursorColor: Colors.white,
                inputFormatters: [_NoLeadingSpaceFormatter()],
                decoration: _buildInputDecoration(),
                style: _buildTextStyle(),
              ),
            ),
          ),
          SizedBox(height: 12.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  controller.handleAIWrite();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.w,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: SAAppColors.yellowColor.withValues(alpha: 0.4),
                  ),
                  child: Row(
                    spacing: 8.w,
                    children: [
                      Text(
                        SATextData.aiWrite,
                        style: TextStyle(
                          fontSize: 22.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Image.asset(
                        "assets/images/sa_89.png",
                        width: 32.w,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        "2",
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Text(
                  '${controller.descriptionLength.value}/${controller.maxDescriptionLength}',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: Color(0xff808080),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _buildTextStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 22.sp,
      fontWeight: FontWeight.w500,
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      counterText: '',
      hintText: controller.state.defaultDescription,
      border: InputBorder.none,
      hintStyle: TextStyle(
        color: const Color(0xFFCCCCCC),
        fontSize: 22.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 如果新值为空，直接返回
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // 只阻止第一个字符前面的空格
    // 如果文本以空格开头，且这是新输入的空格，则阻止
    if (newValue.text.startsWith(' ') && !oldValue.text.startsWith(' ')) {
      return oldValue;
    }

    return newValue;
  }
}
