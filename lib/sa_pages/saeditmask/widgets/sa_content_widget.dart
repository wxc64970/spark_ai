import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';

/// hello
class SaContentWidget extends GetView<SaeditmaskController> {
  const SaContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appBar(),
        SizedBox(height: 20.w),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 32.w, right: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => _buildTitle(SATextData.yourName, subtitle: '(${controller.nameLength.value}/${SaeditmaskController.maxNameLength})')),
                SizedBox(height: 14.w),
                _buildTextFieldContainer(
                  child: TextField(
                    controller: controller.nameController,
                    maxLength: SaeditmaskController.maxNameLength,
                    inputFormatters: [_NoLeadingSpaceFormatter()],
                    decoration: _buildInputDecoration(SATextData.nameHint),
                    style: _buildTextStyle(),
                  ),
                ),
                SizedBox(height: 32.w),
                _buildTitle(SATextData.yourGender),
                SizedBox(height: 16.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildGenderOption(Gender.female),
                    SizedBox(width: 16.w),
                    _buildGenderOption(Gender.male),
                    SizedBox(width: 16.w),
                    _buildGenderOption(Gender.nonBinary),
                  ],
                ),
                SizedBox(height: 32.w),
                _buildTitle(SATextData.yourAge, query: false),
                SizedBox(height: 16.w),
                _buildTextFieldContainer(
                  child: TextField(
                    controller: controller.ageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(5), _AgeInputFormatter()],
                    decoration: _buildInputDecoration(SATextData.ageHint),
                    style: _buildTextStyle(),
                  ),
                ),
                SizedBox(height: 32.w),
                Obx(() => _buildTitle(SATextData.description, subtitle: '(${controller.descriptionLength.value}/${SaeditmaskController.maxDescriptionLength})', query: true)),
                SizedBox(height: 16.w),
                _buildMultilineTextFieldContainer(
                  child: TextField(
                    controller: controller.descriptionController,
                    maxLength: SaeditmaskController.maxDescriptionLength,
                    maxLines: null,
                    inputFormatters: [_NoLeadingSpaceFormatter()],
                    decoration: _buildInputDecoration(SATextData.descriptionHint),
                    style: _buildTextStyle(),
                  ),
                ),
                SizedBox(height: 32.w),
                Obx(() => _buildTitle(SATextData.otherInfo, subtitle: '(${controller.otherInfoLength.value}/${SaeditmaskController.maxOtherInfoLength})', query: false)),
                SizedBox(height: 16.w),
                _buildMultilineTextFieldContainer(
                  child: TextField(
                    controller: controller.otherInfoController,
                    maxLength: SaeditmaskController.maxOtherInfoLength,
                    maxLines: null,
                    inputFormatters: [_NoLeadingSpaceFormatter()],
                    decoration: _buildInputDecoration(SATextData.otherInfoHint),
                    style: _buildTextStyle(),
                  ),
                ),
                SizedBox(height: 24.w),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 144.w, vertical: 32.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
            boxShadow: [BoxShadow(color: const Color(0x1000001a), offset: const Offset(0, -2), blurRadius: 8, spreadRadius: 0)],
            color: Colors.white,
          ),

          child: Column(
            children: [
              ButtonGradientWidget(
                onTap: controller.saveMask,
                height: 96,
                borderRadius: BorderRadius.circular(100.r),
                child: !controller.isEditMode
                    ? Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // Text(
                          //   '${controller.createCost}',
                          //   style: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.w500),
                          // ),
                          Center(
                            child: Text(
                              SATextData.create,
                              style: TextStyle(fontFamily: "Montserrat", color: Colors.black, fontSize: 28.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Positioned(
                            left: 8.w,
                            top: -26.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 16.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(28.r), bottomRight: Radius.circular(28.r)),
                                color: const Color(0xFF1A2608),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '-${controller.createCost}',
                                    style: TextStyle(fontFamily: "Montserrat", color: SAAppColors.pinkColor, fontSize: 28.sp, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(width: 8.w),
                                  Image.asset("assets/images/sa_20.png", width: 40.w, fit: BoxFit.contain),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          SATextData.save,
                          style: TextStyle(fontFamily: "Montserrat", color: Colors.black, fontSize: 28.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
              ),
              SizedBox(height: Get.mediaQuery.padding.bottom),
            ],
          ),
        ),
      ],
    );
  }

  Widget appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 32.w, right: 32.w),
      child: Stack(
        children: [
          SizedBox(
            height: 64.w,
            child: Center(
              child: Text(
                SATextData.createProfileMask,
                style: TextStyle(fontSize: 32.sp, color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Image.asset("assets/images/sa_06.png", width: 48.w, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title, {String? subtitle, bool query = true}) {
    return Row(
      spacing: 2,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 28.sp, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        if (query)
          Text(
            '*',
            style: TextStyle(fontSize: 28.sp, color: Color(0xFFFF2A75), fontWeight: FontWeight.w600),
          ),
        if (subtitle != null)
          Text(
            subtitle,
            style: TextStyle(fontSize: 24.sp, color: Colors.black, fontWeight: FontWeight.w600),
          ),
      ],
    );
  }

  /// 构建文本输入框容器
  Widget _buildTextFieldContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24.r)),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: child,
    );
  }

  /// 构建输入框装饰
  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      counterText: '',
      hintText: hintText,
      border: InputBorder.none,
      hintStyle: TextStyle(color: Color(0xFFA5A5B9), fontSize: 24.sp, fontWeight: FontWeight.w400),
    );
  }

  /// 构建文本样式
  TextStyle _buildTextStyle() {
    return TextStyle(color: Color(0xff080817), fontSize: 24.sp, fontWeight: FontWeight.w400);
  }

  /// 构建多行文本输入框容器
  Widget _buildMultilineTextFieldContainer({required Widget child}) {
    return Container(
      constraints: BoxConstraints(minHeight: 192.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24.r)),
      padding: EdgeInsets.all(24.w),
      child: child,
    );
  }

  /// 构建性别选项
  Widget _buildGenderOption(Gender gender) {
    return Obx(() {
      final isSelected = controller.selectedGender.value == gender;
      return GestureDetector(
        onTap: () {
          controller.selectGender(gender);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 16.w),
          decoration: BoxDecoration(color: isSelected ? Color(0xff1A2608) : Colors.white, borderRadius: BorderRadius.circular(8.r)),
          child: Row(
            children: [
              Image.asset(gender.icon, height: 32.w, fit: BoxFit.contain, color: isSelected ? null : Color(0xffB3B3B3)),
              SizedBox(height: 8.w),
              Text(
                gender.display,
                style: TextStyle(
                  color: isSelected
                      ? gender.display == SATextData.male
                            ? SAAppColors.primaryColor
                            : gender.display == SATextData.female
                            ? SAAppColors.pinkColor
                            : SAAppColors.yellowColor
                      : Color(0xffB3B3B3),
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
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

class _AgeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int? value = int.tryParse(newValue.text);
    if (value == null || value > 99999) {
      return oldValue;
    }

    return newValue;
  }
}
