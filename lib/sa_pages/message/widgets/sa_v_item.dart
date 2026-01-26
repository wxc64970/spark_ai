import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'widgets.dart';

class SAVItem extends StatelessWidget {
  const SAVItem({super.key, required this.msg});

  final SAMessageModel msg;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SATItem(msg: msg),
          const SizedBox(height: 8),
          if (!msg.typewriterAnimated) _buildImageWidget(),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    var imageUrl = msg.thumbLink ?? msg.imgUrl ?? '';
    var isLockImage = msg.mediaLock == MsgLockLevel.private.value;
    var imageWidth = 200.0;
    var imageHeight = 240.0;

    var videoUrl = msg.videoUrl ?? '';

    var imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SAImageWidget(
        url: imageUrl,
        width: imageWidth,
        height: imageHeight,
        borderRadius: BorderRadius.circular(16),
      ),
    );

    return Obx(() {
      var isHide = !SA.login.vipStatus.value && isLockImage;
      return isHide ? _buildCover(imageWidth, imageHeight, imageWidget) : _buildVideoButton(videoUrl, imageWidget);
    });
  }

  Widget _buildCover(double imageWidth, double imageHeight, Widget imageWidget) {
    return GestureDetector(
      onTap: _onTapUnlock,
      child: Container(
        width: imageWidth,
        height: imageHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF000000).withValues(alpha: 0.1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            imageWidget,
            ClipRect(
              child: BackdropFilter(
                blendMode: BlendMode.srcIn,
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Color(0xFF000000).withValues(alpha: 0.1)),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 40.w,
              children: [
                // const Icon(Icons.play_circle, size: 32, color: Colors.white),
                Image.asset('assets/images/sa_74.png', width: 64.w, fit: BoxFit.contain),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 17.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [SAAppColors.primaryColor, SAAppColors.yellowColor]),
                        borderRadius: BorderRadius.all(Radius.circular(40.r)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            SATextData.hotVideo,
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              color: Colors.black,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoButton(String videoUrl, Widget imageWidget) {
    return InkWell(
      onTap: () {
        Get.toNamed(SARouteNames.videoPreview, arguments: videoUrl);
      },
      child: Stack(alignment: Alignment.center, children: [imageWidget, const Icon(Icons.play_circle, size: 32)]),
    );
  }

  void _onTapUnlock() async {
    SAlogEvent('c_news_lockvideo');
    final isVip = SA.login.vipStatus.value;
    if (!isVip) {
      Get.toNamed(SARouteNames.vip, arguments: VipFrom.lockpic);
    }
  }
}
