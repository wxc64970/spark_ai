import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/saDisCovery/widgets/gradient_underline_tabIndicator.dart';

import '../index.dart';

/// hello
class SAContentWidget extends GetView<SaprofileController> {
  const SAContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SAImageWidget(url: controller.role.avatar, width: Get.width, height: 600.w, shape: BoxShape.rectangle, cacheWidth: 80, cacheHeight: 80),
        Container(
          width: Get.width,
          height: 600.w,
          padding: EdgeInsets.only(top: Get.mediaQuery.padding.top, left: 32.w, right: 32.w, bottom: 72.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff000000).withValues(alpha: 0.8), Color(0xff000000).withValues(alpha: 0.0), Color(0xff000000).withValues(alpha: 0.0), Color(0xff000000).withValues(alpha: 0.9)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset("assets/images/sa_54.png", width: 48.w, fit: BoxFit.contain),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.report();
                    },
                    child: Image.asset("assets/images/sa_53.png", width: 48.w, fit: BoxFit.contain),
                  ),
                ],
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => controller.onCollect(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.w, horizontal: 24.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          gradient: LinearGradient(
                            colors: controller.state.collect ? [Color(0xff000000).withValues(alpha: 0.3), Color(0xff000000).withValues(alpha: 0.3)] : [Color(0xffF77DF3), Color(0xffA67DF7)],
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset(controller.state.collect ? "assets/images/sa_04.png" : "assets/images/sa_03.png", width: 40.w, fit: BoxFit.contain),
                            SizedBox(width: 8.w),
                            Text(
                              controller.role.likes ?? '0',
                              style: TextStyle(fontFamily: "Montserrat", color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: Get.width,
          height: Get.height,
          margin: EdgeInsets.only(top: 560.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xffEBFFCC), Color(0xffFFFFFF)], stops: [0.0, 0.4]),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.w, horizontal: 32.w),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20.w),
                        padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 32.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(46.r),
                          boxShadow: [BoxShadow(color: const Color(0x61C5E7B3), offset: const Offset(0, 8), blurRadius: 8, spreadRadius: 0)],
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            SAImageWidget(
                              url: controller.role.avatar,
                              width: 128.w,
                              height: 128.w,
                              shape: BoxShape.circle,
                              cacheWidth: 80,
                              cacheHeight: 80,
                              // borderRadius: BorderRadius.circular(10),
                            ),
                            SizedBox(width: 24.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints(maxWidth: 360.w),
                                        child: Text(
                                          controller.role.name ?? '',
                                          style: TextStyle(fontSize: 40.sp, color: Color(0xff212121), fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      controller.role.age == null
                                          ? const SizedBox()
                                          : Container(
                                              constraints: BoxConstraints(maxWidth: 70.w),
                                              padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 16.w),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(40.r),
                                                gradient: LinearGradient(
                                                  begin: Alignment(math.cos(164 * math.pi / 180), math.sin(-100 * math.pi / 180)),
                                                  end: Alignment(math.cos(164 * math.pi / 180 + math.pi), math.sin(-100 * math.pi / 180 + math.pi)),
                                                  colors: [SAAppColors.primaryColor, SAAppColors.yellowColor],
                                                ),
                                              ),
                                              child: Text(
                                                '${controller.role.age}',
                                                style: TextStyle(fontFamily: "Montserrat", fontSize: 28.sp, color: Colors.black, height: 1, fontWeight: FontWeight.w600),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                    ],
                                  ),
                                  SizedBox(height: 16.w),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 7.w, horizontal: 16.w),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.r), color: Color(0xffFFEAFE)),
                                        child: Row(
                                          children: [
                                            Image.asset("assets/images/sa_57.png", width: 24.w, fit: BoxFit.contain),
                                            SizedBox(width: 8.w),
                                            Text(
                                              controller.role.sessionCount ?? '0',
                                              style: TextStyle(fontFamily: "Montserrat", fontSize: 28.sp, color: Color(0xffF77DF3), fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TabBar(
                              controller: controller.tabController,
                              isScrollable: true, // 关闭均分宽度，支持滑动
                              tabAlignment: TabAlignment.start,
                              labelColor: Colors.black,
                              unselectedLabelColor: Color(0xff808080),
                              dividerHeight: 0.0,
                              indicatorSize: TabBarIndicatorSize.label, // 下划线宽度与文字一致
                              indicator: GradientUnderlineTabIndicator(
                                // 渐变颜色（可自定义）
                                gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [SAAppColors.primaryColor, SAAppColors.yellowColor]),
                                // 下标线条粗细（同原方案的borderSide.width）
                                thickness: 16.w,
                                // 下标宽度/位置控制（同原方案的insets）
                                insets: EdgeInsets.fromLTRB(16.w, 0, 16.w, 4.w),
                                radius: 100.r,
                              ),
                              padding: EdgeInsets.zero,
                              labelPadding: EdgeInsets.only(right: 64.w), // Tab 之间的间距
                              unselectedLabelStyle: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w400), // 未选中文字样式
                              labelStyle: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600), // 选中文字样式
                              tabs: List.generate(controller.tabs.length, (index) {
                                final data = controller.tabs[index];

                                return SizedBox(
                                  height: 50.w,
                                  child: Stack(
                                    children: [
                                      Text(
                                        data,
                                        style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600, color: Colors.transparent),
                                      ),
                                      Text(data),
                                    ],
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: 40.w),
                            Expanded(
                              child: TabBarView(controller: controller.tabController, children: [InfoWidget()]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 40.w, horizontal: 32.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
                  boxShadow: [BoxShadow(color: const Color(0x1000001a), offset: const Offset(0, -2), blurRadius: 8, spreadRadius: 0)],
                  color: Color(0xffF7F7F7),
                ),

                child: SafeArea(
                  top: false,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => ButtonWidget(
                          width: 334.w,
                          height: 88.w,
                          color: controller.state.collect ? Colors.white : Colors.black,
                          onTap: () => controller.onCollect(),
                          child: Center(
                            child: Text(
                              controller.state.collect ? SATextData.liked : SATextData.like,
                              style: TextStyle(fontFamily: "Montserrat", fontSize: 28.sp, color: controller.state.collect ? Color(0xff000000) : SAAppColors.primaryColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 18.w),
                      ButtonGradientWidget(
                        width: 334.w,
                        height: 88,
                        onTap: () => Get.back(),
                        child: Center(
                          child: Text(
                            SATextData.chat,
                            style: TextStyle(fontFamily: "Montserrat", fontSize: 28.sp, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget InfoWidget() {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 32.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(46.r),
          boxShadow: [BoxShadow(color: const Color(0x61C5E7B3), offset: const Offset(0, 8), blurRadius: 8, spreadRadius: 0)],
          color: Colors.white,
        ),
        child: Text(
          controller.role.aboutMe ?? '',
          style: TextStyle(fontSize: 28.sp, color: Color(0xff4D4D4D), fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
