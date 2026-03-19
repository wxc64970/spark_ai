import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/message/index.dart';
import 'package:spark_ai/sa_pages/saDisCovery/widgets/gradient_underline_tabIndicator.dart';

import 'widgets.dart';

class SAUndressWidget extends StatefulWidget {
  const SAUndressWidget({super.key});

  @override
  State<SAUndressWidget> createState() => _SAUndressWidgetState();
}

class _SAUndressWidgetState extends State<SAUndressWidget>
    with SingleTickerProviderStateMixin {
  final List<String> tabs = [
    SATextData.ai_image_label,
    SATextData.ai_video_label,
  ];
  late TabController tabController;
  final MessageController ctr = Get.find<MessageController>();
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      animationDuration: const Duration(milliseconds: 200),
    );
    ctr.state.genType.value = 'I2I';
    tabController.addListener(() {
      final currentIndex = tabController.index;
      // 避免重复触发（Tab 切换动画过程中索引会变化）
      if (tabController.indexIsChanging) return;
      if (currentIndex == 0) {
        ctr.state.genType.value = 'I2I';
      } else {
        ctr.state.genType.value = 'I2V';
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.w),
      width: Get.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/sa_10.png"),
          fit: BoxFit.fitWidth,
          alignment: AlignmentGeometry.topCenter,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.w),
          topRight: Radius.circular(32.w),
        ),
        color: Colors.white,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 48.w, horizontal: 32.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: tabController,
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
                        colors: [
                          SAAppColors.primaryColor,
                          SAAppColors.yellowColor,
                        ],
                      ),
                      // 下标线条粗细（同原方案的borderSide.width）
                      thickness: 16.w,
                      // 下标宽度/位置控制（同原方案的insets）
                      insets: EdgeInsets.fromLTRB(16.w, 0, 16.w, 4.w),
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
                    tabs: List.generate(tabs.length, (index) {
                      final data = tabs[index];

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
                ),
                Row(
                  spacing: 8.w,
                  children: [
                    Image.asset(
                      "assets/images/sa_89.png",
                      width: 32.w,
                      fit: BoxFit.contain,
                    ),
                    Obx(
                      () => Text(
                        SA.login.starCount.toString(),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.w),
            SizedBox(
              height: 500.w,
              child: TabBarView(
                controller: tabController,
                children: [ImageToImageWidget(), ImageToVideoWidget()],
              ),
            ),
            SizedBox(height: Get.mediaQuery.padding.bottom),
          ],
        ),
      ),
    );
  }
}
