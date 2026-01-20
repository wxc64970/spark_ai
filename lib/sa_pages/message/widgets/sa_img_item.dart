import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'widgets.dart';

class SAImgItem extends StatelessWidget {
  const SAImgItem({super.key, required this.msg});

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
          if (!msg.typewriterAnimated) _buildImageWidget(context),
        ],
      ),
    );
  }

  Widget _buildImageWidget(BuildContext context) {
    var imageUrl = msg.imgUrl ?? '';
    if (msg.source == MessageSource.clothe) {
      imageUrl = msg.giftImg ?? '';
    }
    var isLockImage = msg.mediaLock == MsgLockLevel.private.value;
    var imageWidth = 200.0;
    var imageHeight = 240.0;

    var imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SAImageWidget(url: imageUrl, width: imageWidth, height: imageHeight, borderRadius: BorderRadius.circular(16)),
    );

    return Obx(() {
      var isHide = !SA.login.vipStatus.value && isLockImage;
      return isHide
          ? _buildLoackWidge(imageWidth, imageHeight, imageWidget)
          : GestureDetector(
              onTap: () {
                Get.toNamed(SARouteNames.imagePreview, arguments: imageUrl);
              },
              child: imageWidget,
            );
    });
  }

  GestureDetector _buildLoackWidge(double imageWidth, double imageHeight, Widget imageWidget) {
    return GestureDetector(
      onTap: _onTapUnlock,
      child: Container(
        width: imageWidth,
        height: imageHeight,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
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
            _buildContentButton(),
          ],
        ),
      ),
    );
  }

  Column _buildContentButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/sa_36.png', width: 64.w, fit: BoxFit.contain),
        SizedBox(height: 40.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 85.w, vertical: 17.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [SAAppColors.primaryColor, SAAppColors.yellowColor]),
                borderRadius: BorderRadius.all(Radius.circular(40.r)),
              ),
              child: Row(
                children: [
                  Text(
                    SATextData.hotPhoto,
                    style: TextStyle(fontFamily: "Montserrat", color: Colors.black, fontSize: 24.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onTapUnlock() async {
    SAlogEvent('c_news_lockpic');
    final isVip = SA.login.vipStatus.value;
    if (!isVip) {
      Get.toNamed(SARouteNames.vip, arguments: VipFrom.lockpic);
    }
  }
}
