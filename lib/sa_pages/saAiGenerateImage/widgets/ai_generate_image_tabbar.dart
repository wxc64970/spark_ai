import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/saDisCovery/widgets/gradient_underline_tabIndicator.dart';

import '../index.dart';

/// hello
class AiGenerateImageTabbar extends GetView<SaaigenerateimageController> {
  const AiGenerateImageTabbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [SAAppColors.primaryColor, SAAppColors.yellowColor],
            ),
            // 下标线条粗细（同原方案的borderSide.width）
            thickness: 16.w,
            // 下标宽度/位置控制（同原方案的insets）
            insets: EdgeInsets.fromLTRB(100.w, 0, 100.w, 4.w),
            radius: 100.r,
          ),
          padding: EdgeInsets.zero,
          labelPadding: EdgeInsets.only(right: 64.w), // Tab 之间的间距
          unselectedLabelStyle: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w400,
          ), // 未选中文字样式
          labelStyle: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w600,
          ), // 选中文字样式
          tabs: List.generate(controller.tabs.length, (index) {
            final data = controller.tabs[index];

            return SizedBox(
              height: 50.w,
              child: Stack(
                children: [
                  Text(
                    data,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.transparent,
                    ),
                  ),
                  Text(data),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: 16.w),
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: controller.tabData,
          ),
        ),
      ],
    );
  }
}
