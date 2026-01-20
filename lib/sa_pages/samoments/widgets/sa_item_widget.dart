import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';

/// hello
class SAItemWidget extends GetView<SamomentsController> {
  const SAItemWidget({Key? key, required this.item}) : super(key: key);

  final SAPost item;

  @override
  Widget build(BuildContext context) {
    var isVideo = item.cover != null && item.duration != null;
    var imgUrl = isVideo ? item.cover : item.media;
    var istop = item.istop ?? false;
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(32.r), color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              controller.onItemClick(item);
            },
            child: Column(
              spacing: 8.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 16.w,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(color: SAAppColors.primaryColor, borderRadius: BorderRadius.circular(16.r)),
                      child: Padding(
                        padding: EdgeInsets.all(2.w), // 边框厚度
                        child: SAImageWidget(
                          url: item.characterAvatar,
                          width: 64.w,
                          height: 64.w,
                          shape: BoxShape.rectangle,
                          cacheWidth: 64,
                          cacheHeight: 64,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.characterName ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Color(0xff222222), fontSize: 32.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Text(
                  item.text ?? '',
                  style: TextStyle(color: Color(0xFF4D4D4D), fontSize: 28.sp, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.w),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  controller.onPlay(item);
                },
                child: SAImageWidget(url: imgUrl, height: 360.w, width: double.infinity, borderRadius: BorderRadius.circular(16.r), shape: BoxShape.rectangle),
              ),
              Positioned.fill(child: _buildLock(istop, isVideo, item)),
              Obx(() {
                var isVip = SA.login.vipStatus.value;
                if (isVip || istop) {
                  return const SizedBox();
                } else {
                  return Positioned(
                    left: 16.w,
                    top: 16.w,
                    child: isVideo
                        ? Row(
                            children: [
                              Image.asset('assets/images/sa_73.png', width: 32.w, fit: BoxFit.contain),
                              SizedBox(width: 8.w),
                              Text(
                                formatVideoDuration(item.duration ?? 0),
                                style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        : Image.asset('assets/images/sa_72.png', width: 32.w, fit: BoxFit.contain),
                  );
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLock(bool istop, bool isVideo, SAPost data) {
    Widget widget = GestureDetector(
      onTap: () {
        Get.toNamed(SARouteNames.vip, arguments: isVideo ? VipFrom.postvideo : VipFrom.postpic);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
          child: Container(
            width: double.infinity,
            height: 188,
            color: const Color(0xff000000).withValues(alpha: 0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(color: const Color(0xff212121).withValues(alpha: 0.5), borderRadius: BorderRadius.circular(100.r)),
                  child: Image.asset('assets/images/sa_35.png', width: 32.w, fit: BoxFit.contain),
                ),
                SizedBox(height: 24.w),
                ButtonWidget(
                  height: 64.w,
                  margin: EdgeInsets.symmetric(horizontal: 128.w),
                  color: Color(0xff212121).withValues(alpha: 0.5),
                  child: Center(
                    child: Text(
                      'Subscribe to unlock posts',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 26.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Widget play = Center(
      child: GestureDetector(
        onTap: () {
          controller.onPlay(data);
        },
        child: Center(child: Image.asset('assets/images/sa_74.png', width: 64.w)),
      ),
    );

    return Obx(() {
      var isVip = SA.login.vipStatus.value;
      if (isVip || istop) {
        return isVideo ? play : const SizedBox();
      } else {
        return widget;
      }
    });
  }
}
