import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';
import 'base_container_widget.dart';
import 'describe_widget.dart';
import 'more_detail_widget.dart';
import 'sa_field_title.dart';
import 'sa_image_style_item.dart';
import 'sa_switch.dart';

/// hello
class SABodyWidget extends GetView<SaaigenerateimageController> {
  const SABodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.w),
          BaseContainerWidget(
            child: [
              Text(
                SATextData.basics,
                style: TextStyle(
                  fontSize: 28.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SaFieldTitle(
                    title: SATextData.age,
                    isRequired: true,
                    subtitle: '(18-999)',
                  ),
                  Container(
                    width: 240.w,
                    height: 64.w,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Color(0xffF7F7F7),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: controller.ageFocusNode,
                            cursorHeight: 32.w,
                            controller: controller.ageController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: Color(0xff1A1A1A),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          SATextData.years,
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: Color(0xff808080),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SaFieldTitle(
                    title: SATextData.height,
                    isRequired: true,
                    subtitle: '(10-999)',
                  ),
                  Container(
                    width: 240.w,
                    height: 64.w,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Color(0xffF7F7F7),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: controller.heightFocusNode,
                            cursorHeight: 32.w,
                            controller: controller.heightController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: Color(0xff1A1A1A),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          SATextData.cm,
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: Color(0xff808080),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SaFieldTitle(title: SATextData.gender, isRequired: true),
                  Container(
                    width: (168 * 3).w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Color(0xffF7F7F7),
                    ),
                    child: Row(
                      children: [
                        _buildGenderOption(Gender.male),
                        _buildGenderOption(Gender.female),
                        _buildGenderOption(Gender.nonBinary),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          BaseContainerWidget(
            child: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SaFieldTitle(
                    title: SATextData.imageStyle,
                    isRequired: true,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                  Container(
                    width: (144 * 2).w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Color(0xffF7F7F7),
                    ),
                    child: Row(
                      children: [
                        _buildImagesStyleOption(SATextData.real),
                        _buildImagesStyleOption(SATextData.fantasy),
                      ],
                    ),
                  ),
                ],
              ),
              Obx(
                () => SizedBox(
                  width: Get.width,
                  height: 168.w,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.imageStyleData.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return imageStyleItem(
                        data: controller.imageStyleData[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          BaseContainerWidget(
            child: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SaFieldTitle(
                    title: SATextData.nsfw,
                    isRequired: true,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                  Obx(
                    () => SASwitch(
                      value: controller.state.nsfw,
                      onChanged: (value) => controller.state.nsfw = value,
                    ),
                  ),
                ],
              ),
              Text(
                SATextData.ns,
                style: TextStyle(
                  fontSize: 22.sp,
                  color: Color(0xff808080),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Obx(() {
            return controller.currentIndex.value == 0
                ? MoreDetailWidget()
                : DescribeWidget();
          }),
        ],
      ),
    );
  }

  /// 构建性别选项
  Widget _buildGenderOption(Gender gender) {
    return Obx(() {
      final isSelected = controller.state.selectedGender.value == gender;
      return GestureDetector(
        onTap: () {
          controller.selectGender(gender);
        },
        child: Container(
          width: 168.w,
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [SAAppColors.primaryColor, SAAppColors.yellowColor],
                  )
                : null,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: Text(
              gender.display,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }

  /// 构建风格tab
  Widget _buildImagesStyleOption(imageStyle) {
    return Obx(() {
      final isSelected = controller.state.imageStyleTabs == imageStyle;
      return GestureDetector(
        onTap: () {
          controller.selectImageStyleTab(imageStyle);
        },
        child: Container(
          width: 144.w,
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    // begin: Alignment(0, -0.5),
                    // end: Alignment(1, 0.5),
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [SAAppColors.primaryColor, SAAppColors.yellowColor],
                  )
                : null,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              imageStyle,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }
}
