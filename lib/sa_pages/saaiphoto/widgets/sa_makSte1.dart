import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:video_player/video_player.dart';

class SAMakste1 extends StatefulWidget {
  const SAMakste1({
    super.key,
    this.role,
    required this.isVideo,
    this.hasHistory,
    this.onTapGenRole,
    required this.onTapUpload,
  });

  final ChaterModel? role;
  final bool isVideo;
  final bool? hasHistory;
  final VoidCallback? onTapGenRole;
  final void Function() onTapUpload;

  @override
  State<SAMakste1> createState() => _CjMakste1State();
}

class _CjMakste1State extends State<SAMakste1> {
  VideoPlayerController? _controller;

  String? _localVideoPath;
  String? imageUrl =
      'https://static.pppdgb7roqqonqzc.com/spark/df672f95229d9a05582cf929d47b2e4f1e07033b91961d05ac3ed0668783a9cd.jpeg';
  String videoUrl =
      'https://static.pppdgb7roqqonqzc.com/spark/b059f67331701eab9054e4f90020bd1504377a0e3a252f8abc6e1e6ca4da95fd.mp4';

  @override
  void initState() {
    super.initState();

    FileDownloadService.instance
        .downloadFile(videoUrl, fileType: FileType.video)
        .then((localPath) {
          if (localPath != null) {
            _localVideoPath = localPath;
            if (widget.isVideo) {
              _initVideoPlayer();
            }
          }
        });

    if (widget.isVideo) {
      if (_localVideoPath != null) {
        _initVideoPlayer();
      }
    }
  }

  void _initVideoPlayer() {
    _controller = VideoPlayerController.file(File(_localVideoPath!));
    _controller?.initialize().then((_) {
      _controller?.setLooping(true);
      _controller?.play();
      setState(() {});
    });
  }

  Widget imageErrorWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/errimage.png',
        width: 90.w,
        height: 90.w,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = !widget.isVideo
        ? SATextData.ai_upload_steps_extra
        : SATextData.ai_upload_steps;
    final text2 = !widget.isVideo
        ? SATextData.ai_undress_sweetheart
        : SATextData.ai_make_photo_animated;

    final imgW = 542.w;
    final imgH = 700.w;

    bool hasRole = widget.role != null;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 16,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32.r),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      height: imgH,
                      width: imgW,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.r),
                        color: Colors.white,
                      ),
                      child: widget.isVideo
                          ? (_controller?.value.isInitialized ?? false)
                                ? AspectRatio(
                                    aspectRatio: _controller!.value.aspectRatio,
                                    child: VideoPlayer(_controller!),
                                  )
                                : imageErrorWidget()
                          : SAImageWidget(url: imageUrl),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 65.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: Color(0xFF4D4D4D),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Center(
                        child: Text(
                          text2,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Color(0xff1A1A1A),
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 110.w),
              ],
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 112.w),
              child: ButtonGradientWidget(
                height: 88,
                onTap: widget.onTapUpload,
                gradientColors: hasRole
                    ? const [Colors.white, Colors.white]
                    : const [SAAppColors.primaryColor, SAAppColors.yellowColor],
                child: Center(
                  child: Text(
                    SATextData.uploadAPhoto,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 28.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            if (hasRole) ...[
              SizedBox(height: 32.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 112.w),
                child: ButtonGradientWidget(
                  onTap: widget.onTapGenRole,
                  height: 88,
                  borderRadius: BorderRadius.circular(100.r),
                  child: Center(
                    child: Text(
                      widget.hasHistory == true
                          ? SATextData.ai_view_nude
                          : SATextData.ai_under_character,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 28.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: 32.w),
          ],
        ),
      ],
    );
  }
}
