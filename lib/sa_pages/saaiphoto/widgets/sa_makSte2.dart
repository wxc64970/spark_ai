import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final List<SAImgStyle> styles;
  final Function(SAImgStyle? style) onChooseStyles;
  final String? imagePath;
  final bool undressRole;
  final SAImgStyle? selectedStyel;
  final bool isLoading;

  @override
  State<SAMakste2> createState() => _CjMakste2State();
}

class _CjMakste2State extends State<SAMakste2> {
  SAImgStyle? style;
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
                                child: CachedNetworkImage(imageUrl: avatar, fit: BoxFit.cover),
                              ),
                            if (imagePath != null && imagePath.isNotEmpty) Positioned.fill(child: Image.file(File(imagePath), fit: BoxFit.cover)),
                            IconButton(
                              onPressed: widget.onDeleteImage,
                              icon: Image.asset("assets/images/close1.png", width: 48.w, fit: BoxFit.contain),
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
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.isVideo == false) ...[SAMakStylesWidget(selectedStyel: style, list: widget.styles, onChooseed: onChooseedStyle), const SizedBox(height: 8)],
                      Container(
                        alignment: Alignment.centerLeft,
                        // padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          SATextData.ai_custom_prompt,
                          style: TextStyle(color: Color(0xFF222222), fontSize: 28.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 16.w),
                      InkWell(
                        onTap: onTapInput,
                        borderRadius: BorderRadius.circular(24.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 24.w),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24.r)),
                          alignment: AlignmentDirectional.centerStart,
                          child: SAAutoHeightScrollText(
                            text: hasCustomPrompt
                                ? customPrompt!
                                : widget.isVideo
                                ? SATextData.ai_prompt_examples_video
                                : SATextData.ai_prompt_examples_img,
                            style: TextStyle(color: hasCustomPrompt ? const Color(0xFF1C1C1C) : const Color(0xFFA5A5B9), fontSize: 24.sp, fontWeight: FontWeight.w400, height: 1.5),
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
          right: 0,
          bottom: 10,
          child: Container(
            color: const Color(0xFFF7F7F7),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Obx(() {
                  var createImg = SA.login.imgCreationCount.value;
                  var createVideo = SA.login.videoCreationCount.value;
                  return Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: SATextData.ai_balance,
                          style: TextStyle(color: Color(0xFF222222), fontSize: 24.w, fontWeight: FontWeight.w400),
                        ),
                        WidgetSpan(child: SizedBox(width: 8.w)),
                        TextSpan(
                          text: widget.isVideo ? '$createVideo' : '$createImg',
                          style: TextStyle(fontFamily: "Montserrat", color: Color(0xFF1A1A1A), fontSize: 24.sp, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                        ),
                        const WidgetSpan(child: SizedBox(width: 4)),
                        TextSpan(
                          text: widget.isVideo ? SATextData.ai_videos : SATextData.ai_photos,
                          style: TextStyle(color: Color(0xFF222222), fontSize: 24.w, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                ButtonGradientWidget(
                  onTap: widget.onTapGen,
                  height: 96,
                  child: Center(
                    child: Text(
                      SATextData.ai_generate,
                      style: TextStyle(fontFamily: "Montserrat", fontSize: 28.sp, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void onTapInput() {
    if (widget.isLoading) return;
    Get.bottomSheet(
      SAMsgEditScreen(
        content: customPrompt,
        onInputTextFinish: (v) {
          customPrompt = v;

          style = v.isEmpty ? widget.styles.firstOrNull : null;
          widget.onChooseStyles(style);

          widget.onInputTextFinish(v);
          setState(() {});
          Get.back();
        },
        subtitle: Row(
          spacing: 4,
          children: [
            Text(
              SATextData.ai_custom_prompt,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      enableDrag: false, // 禁用底部表单拖拽，避免与文本选择冲突
      isScrollControlled: true,
      isDismissible: true,
      ignoreSafeArea: false,
    );
  }

  void onChooseedStyle(SAImgStyle data) {
    if (widget.isLoading) return;
    style = data;
    customPrompt = null;
    widget.onChooseStyles(data);
    widget.onInputTextFinish('');
    setState(() {});
  }
}
