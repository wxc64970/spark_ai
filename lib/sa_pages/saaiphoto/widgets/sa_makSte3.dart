import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:video_player/video_player.dart';

class SAMakste3 extends StatefulWidget {
  const SAMakste3({super.key, this.role, required this.onTapGen, this.onDeleteImage, required this.resultUrl, required this.isVideo});

  final ChaterModel? role;
  final VoidCallback onTapGen;
  final VoidCallback? onDeleteImage;
  final String resultUrl;
  final bool isVideo;

  @override
  State<SAMakste3> createState() => _CjMakste3State();
}

class _CjMakste3State extends State<SAMakste3> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _controller = VideoPlayerController.file(File(widget.resultUrl))
        ..initialize().then((_) {
          _controller?.setLooping(true);
          _controller?.play();
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SAMakste3 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVideo && widget.resultUrl != oldWidget.resultUrl) {
      _controller?.dispose();

      _controller = VideoPlayerController.file(File(widget.resultUrl))
        ..initialize().then((_) {
          _controller?.setLooping(true);
          _controller?.play();
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imgW = 542.w;
    final imgH = 700.w;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          margin: EdgeInsets.only(top: 24.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(48.r),
            clipBehavior: Clip.hardEdge,
            child: Container(
              color: const Color(0x1AFFFFFF),
              height: imgH,
              width: imgW,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Positioned.fill(
                    child: InkWell(
                      child: widget.isVideo
                          ? (_controller?.value.isInitialized ?? false)
                                ? AspectRatio(aspectRatio: _controller!.value.aspectRatio, child: VideoPlayer(_controller!))
                                : const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2, backgroundColor: Colors.white, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFDCA4))),
                                    ),
                                  )
                          : SAImageWidget(url: widget.resultUrl),
                      onTap: () {
                        if (widget.isVideo) {
                          Get.toNamed(SARouteNames.videoPreview, arguments: widget.resultUrl);
                        } else {
                          Get.toNamed(SARouteNames.imagePreview, arguments: widget.resultUrl);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onDeleteImage,
                    icon: Image.asset("assets/images/close1.png", width: 48.w, fit: BoxFit.contain),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 112.w),
          child: ButtonGradientWidget(
            onTap: widget.onTapGen,
            height: 96,
            child: Center(
              child: Text(
                SATextData.ai_generate_another,
                style: TextStyle(fontFamily: "Montserrat", fontSize: 28.sp, color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        SizedBox(height: 24.w),
      ],
    );
  }
}
