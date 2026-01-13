import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/sa_pages/index.dart';

class SaapplicationPage extends GetView<SaapplicationController> {
  const SaapplicationPage({Key? key}) : super(key: key);

  Widget _buildPageView() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller.pageController,
      onPageChanged: controller.handlePageChanged,

      children: [SachatPage(), SadiscoveryPage(), SamePage()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaapplicationController>(
      builder: (_) {
        return Scaffold(extendBody: true, body: _buildPageView(), bottomNavigationBar: _buildBottomNavigationBar());
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(
      () => Container(
        padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 84.w),
        color: Colors.transparent,
        child: Container(
          height: 100.w,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.r), color: Color(0xff151F06)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...List.generate(controller.bottomTabs.length, (index) {
                var item = controller.bottomTabs[index];
                return IconButton(
                  icon: controller.state.page == index ? item['activeIcon'] : item['icon'],
                  padding: EdgeInsets.zero, // 移除默认内边距
                  constraints: const BoxConstraints(), // 解除点击区域限制
                  onPressed: () => controller.handleNavBarTap(index),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
