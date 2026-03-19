import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/message/widgets/sa_msg_e_scr.dart';

import 'sa_mak_loding.dart';
import 'sa_mak_style_widget.dart';

class SAMakste2 extends StatefulWidget {
  const SAMakste2({
    super.key,
    required this.onTapGen,
    this.onDeleteImage,
    this.role,
    required this.isVideo,
    required this.onInputTextFinish,
    required this.styles,
    required this.onChooseStyles,
    this.imagePath,
    required this.undressRole,
    required this.isLoading,
    this.selectedStyel,
  });

  final VoidCallback onTapGen;
  final VoidCallback? onDeleteImage;
  final ChaterModel? role;
  final bool isVideo;
  final Function(String text) onInputTextFinish;
  final List<StyleConfigItem?> styles;
  final Function(StyleConfigItem? style) onChooseStyles;
  final String? imagePath;
  final bool undressRole;
  final StyleConfigItem? selectedStyel;
  final bool isLoading;

  @override
  State<SAMakste2> createState() => _CjMakste2State();
}

class _CjMakste2State extends State<SAMakste2> {
  StyleConfigItem? style;
  String? customPrompt;

  @override
  void initState() {
    style = widget.selectedStyel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imgW = 542.w;
    final imgH = 700.w;

    bool hasCustomPrompt = customPrompt != null && customPrompt!.isNotEmpty;
    var avatar = widget.role?.avatar;

    var imagePath = widget.imagePath;

    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: 32.w, right: 32.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32.r),
                          clipBehavior: Clip.hardEdge,
                          child: Stack(
                            children: [
                              Container(
                                color: Colors.white,
                                height: imgH,
                                width: imgW,
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    if (widget.undressRole && avatar != null)
                                      Positioned.fill(
                                        child: CachedNetworkImage(
                                          imageUrl: avatar,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    if (imagePath != null &&
                                        imagePath.isNotEmpty)
                                      Positioned.fill(
                                        child: Image.file(
                                          File(imagePath),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    IconButton(
                                      onPressed: widget.onDeleteImage,
                                      icon: Image.asset(
                                        "assets/images/close1.png",
                                        width: 48.w,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    if (widget.isLoading) const SAMakLoading(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.w),
                      if (widget.isVideo == false) ...[
                        SAMakStylesWidget(
                          selectedStyel: style,
                          list: widget.styles,
                          onChooseed: onChooseedStyle,
                        ),
                        const SizedBox(height: 8),
                      ],
                      Container(
                        alignment: Alignment.centerLeft,
                        // padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          SATextData.ai_custom_prompt,
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.w),
                      InkWell(
                        onTap: onTapInput,
                        borderRadius: BorderRadius.circular(24.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                            vertical: 24.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          alignment: AlignmentDirectional.centerStart,
                          child: SAAutoHeightScrollText(
                            text: hasCustomPrompt
                                ? customPrompt!
                                : widget.isVideo
                                ? SATextData.ai_prompt_examples_video
                                : SATextData.ai_prompt_examples_img,
                            style: TextStyle(
                              color: hasCustomPrompt
                                  ? const Color(0xFF1C1C1C)
                                  : const Color(0xFFA5A5B9),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                            preciseHeight: true,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 175.w),
            ],
          ),
        ),
        Positioned(
          left: 0,
          bottom: 10,
          width: Get.width,
          child: Container(
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
                      onTap: widget.onTapGen,
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
                            Text(
                              SA.login.priceConfig!.i2i.toString(),
                              style: TextStyle(
                                color: SAAppColors.yellowColor,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.mediaQuery.padding.bottom),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void onTapInput() {
    if (widget.isLoading) return;
    SmartDialog.show(
      alignment: Alignment.bottomCenter,
      usePenetrate: false,
      clickMaskDismiss: false,
      backType: SmartBackType.normal,
      builder: (context) {
        return SAMsgEditScreen(
          content: customPrompt,
          onInputTextFinish: (v) {
            customPrompt = v;

            style = v.isEmpty ? widget.styles.firstOrNull : null;
            widget.onChooseStyles(style);

            widget.onInputTextFinish(v);
            setState(() {});
            SmartDialog.dismiss();
          },
          subtitle: Row(
            // spacing: 4,
            children: [
              Text(
                SATextData.ai_custom_prompt,
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void onChooseedStyle(StyleConfigItem data) {
    if (widget.isLoading) return;
    style = data;
    customPrompt = null;
    widget.onChooseStyles(data);
    widget.onInputTextFinish('');
    setState(() {});
  }
}
