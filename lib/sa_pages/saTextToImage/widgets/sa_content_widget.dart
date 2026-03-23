import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';
import 'widgets.dart';

/// hello
class SAContextWidget extends GetView<SatexttoimageController> {
  const SAContextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Stack(
              children: [
                SAImageWidget(
                  width: Get.width,
                  height: 700.w,
                  url: controller.state.styleImage,
                  // alignment: Alignment.topCenter,
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: Get.width,
                    height: 700.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black54,
                          Colors.transparent,
                          Color(0xffF7F7F7).withValues(alpha: 0.0),
                          Color(0xffF7F7F7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  width: Get.width,
                  left: 0,
                  top: 0,
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Get.back();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 32.w),
                            child: Image.asset(
                              "assets/images/sa_21.png",
                              width: 48.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                SAlogEvent('aiphoto_creations_click');
                                controller.handleHistory();
                              },
                              child: Container(
                                padding: EdgeInsets.only(right: 16.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.r),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  spacing: 8.w,
                                  children: [
                                    Image.asset(
                                      "assets/images/sa_78.png",
                                      width: 48.w,
                                      fit: BoxFit.contain,
                                    ),
                                    Text(
                                      SATextData.creations,
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        color: Color(0xffEC9DF7),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Row(
                              spacing: 24.w,
                              children: [
                                InkWell(
                                  onTap: () =>
                                      SASheetBottom.show(ConsumeFrom.aiphoto),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 6.w,
                                      horizontal: 16.w,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.r),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      spacing: 8.w,
                                      children: [
                                        Image.asset(
                                          "assets/images/sa_89.png",
                                          width: 32.w,
                                          fit: BoxFit.contain,
                                        ),
                                        Text(
                                          SA.login.starCount.value.toString(),
                                          style: TextStyle(
                                            fontSize: 24.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Image.asset(
                                          "assets/images/sa_76.png",
                                          width: 32.w,
                                          fit: BoxFit.contain,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 32.w),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 32.w,
                  width: Get.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: (144 * 2).w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Color(0xffF7F7F7),
                          ),
                          child: Row(
                            children: [
                              ...List.generate(
                                SA.login.textToImage.length,
                                (index) => _buildImagesStyleOption(
                                  SA.login.textToImage[index]?.name,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              spacing: 44.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildDescriptionWidget(),
                BuildNumberWidget(),
                BuildImageRatioWidget(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.w),
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x1000001a),
                  offset: const Offset(0, -2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
              color: Color(0xffF7F7F7),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonWidget(
                      width: 462.w,
                      height: 88.w,
                      onTap: () => controller.createImage(),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(134.r),
                          color: Colors.black,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 8.w,
                          children: [
                            Text(
                              SATextData.ai_generate,
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.white,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Image.asset(
                              "assets/images/sa_89.png",
                              width: 32.w,
                              fit: BoxFit.contain,
                            ),
                            Obx(
                              () => Text(
                                controller.state.coins,
                                style: TextStyle(
                                  color: SAAppColors.yellowColor,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: Get.mediaQuery.padding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesStyleOption(imageStyle) {
    return Obx(() {
      final isSelected = controller.state.styleName == imageStyle;
      return GestureDetector(
        onTap: () {
          controller.selectImageStyle(imageStyle);
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
