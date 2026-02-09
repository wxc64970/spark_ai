import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/saaiphoto/widgets/sa_mak_widget.dart';
import 'package:video_player/video_player.dart';

class AiphotoWidget extends StatefulWidget {
  final List<ItemConfigs> aiPhotoList;
  const AiphotoWidget({super.key, required this.aiPhotoList});

  @override
  State<AiphotoWidget> createState() => _AiphotoWidgetState();
}

class _AiphotoWidgetState extends State<AiphotoWidget> {
  VideoPlayerController? _controller;

  String? _localVideoPath;

  @override
  void initState() {
    super.initState();
    if (widget.aiPhotoList.isNotEmpty) {
      for (ItemConfigs item in widget.aiPhotoList) {
        if (item.imageUrl!.contains('.mp4')) {
          FileDownloadService.instance
              .downloadFile(item.imageUrl!, fileType: FileType.video)
              .then((localPath) {
                if (localPath != null) {
                  _localVideoPath = localPath;
                  _initVideoPlayer();
                }
              });
          if (_localVideoPath != null) {
            _initVideoPlayer();
          }
        }
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

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(widget.aiPhotoList.length, (index) {
            var item = widget.aiPhotoList[index];
            return InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if (index == 0) {
                  SAlogEvent('aiphoto_t2i_click');
                  Get.toNamed(SARouteNames.aiGenerateImage);
                } else if (index == 1) {
                  SAlogEvent('aiphoto_i2i_click');
                  Get.toNamed(
                    SARouteNames.aiImage,
                    arguments: SAAiViewType.image,
                  );
                } else {
                  SAlogEvent('aiphoto_i2v_click');
                  Get.toNamed(
                    SARouteNames.aiImage,
                    arguments: SAAiViewType.video,
                  );
                }
              },
              child: Stack(
                children: [
                  Container(
                    height: 386.w,
                    width: 686.w,
                    margin: EdgeInsets.only(bottom: 32.w),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    child: item.imageUrl!.contains('.mp4')
                        ? (_controller?.value.isInitialized ?? false)
                              ? AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child: VideoPlayer(_controller!),
                                )
                              : imageErrorWidget()
                        : SAImageWidget(url: item.imageUrl!),
                  ),
                  index != 0
                      ? Container(
                          height: 386.w,
                          width: 686.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32.r),
                              bottomRight: Radius.circular(32.r),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color(0xff000000).withValues(alpha: 0.6),
                                Color(0xff000000).withValues(alpha: 0),
                              ],
                              stops: [0, 0.5],
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  Positioned(
                    left: 24.w,
                    bottom: 56.w,
                    width: 638.w,
                    child: Row(
                      spacing: 10.w,
                      children: [
                        Expanded(
                          child: index != 0
                              ? Column(
                                  spacing: 2.w,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title ?? '',
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 26.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      item.text ?? '',
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 18.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                        ),
                        ButtonGradientWidget(
                          width: 280.w,
                          height: 64,
                          child: Center(
                            child: Text(
                              SATextData.tryIt,
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 28.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget imageErrorWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      alignment: Alignment.center,
      child: Image.asset('assets/images/sa_70.png', width: 90.w, height: 90.w),
    );
  }
}
