import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/saDisCovery/widgets/gradient_underline_tabIndicator.dart';
import 'package:spark_ai/sa_pages/saaiphoto/widgets/sa_mak_widget.dart';

import '../index.dart';

/// hello
class SaAiGenerateHistoryTabbar extends GetView<SaaigeneratehistoryController> {
  const SaAiGenerateHistoryTabbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => TabBar(
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
              insets: EdgeInsets.fromLTRB(26.w, 0, 26.w, 4.w),
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
            tabs: List.generate(controller.creationsList.length, (index) {
              final data = index == 0
                  ? '${CreationsType.video.displayName} (${controller.statusCounts[CreationsType.video.apiValue] ?? 0})'
                  : '${CreationsType.image.displayName} (${controller.statusCounts[CreationsType.image.apiValue] ?? 0})';

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
        SizedBox(height: 24.w),
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: List.generate(
              controller.creationsList.length,
              (index) => _buildContent(index),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(int index) {
    return GetBuilder<SaaigeneratehistoryController>(
      builder: (controller) {
        return EasyRefresh.builder(
          controller: controller.refreshCtr,
          onRefresh: () => controller.onRefresh(index),
          onLoad: () => controller.onLoad(index),
          childBuilder: (context, physics) {
            return Obx(() {
              final type = controller.type.value;
              final list = controller.list;
              if (!controller.isDataLoaded[index].value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (type != null && list[index].isEmpty) {
                return historyEmptyWidget();
              }
              return _buildList(physics, list[index], index);
            });
          },
        );
      },
    );
  }

  Widget historyEmptyWidget() {
    return SizedBox(
      width: Get.width,
      child: Column(
        children: [
          Image.asset(
            "assets/images/sa_no_data.png",
            width: 360.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 16.w),
          Text(
            SATextData.noImages,
            style: TextStyle(
              fontSize: 28.sp,
              color: Color(0xffB3B3B3),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.w),
          Text(
            SATextData.noImagesText,
            style: TextStyle(fontSize: 24.sp, color: Color(0xffB3B3B3)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.w),
          ButtonGradientWidget(
            width: 462.w,
            height: 88,
            onTap: () async {
              if (controller.currentIndex.value == 0) {
                await Get.toNamed(
                  SARouteNames.aiImage,
                  arguments: SAAiViewType.video,
                );
              } else {
                // await Get.toNamed(SARouteNames.aiGenerateImage);
                await Get.toNamed(
                  SARouteNames.aiImage,
                  arguments: SAAiViewType.image,
                );
              }
              // 从其他页面返回后刷新当前页面数据
              controller.refreshCurrentPage();
            },
            borderRadius: BorderRadius.circular(100.r),
            child: Center(
              child: Text(
                SATextData.create,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 28.sp,
                  color: Color(0xff1A1A1A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    ScrollPhysics physics,
    List<CreationsHistory> list,
    int tabIndex,
  ) {
    return GridView.builder(
      physics: physics,
      // padding: const EdgeInsets.symmetric(horizontal: 12.0),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.w,
        childAspectRatio: 218 / 290,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _buildItemCard(list[index]);
      },
    );
  }

  Widget _buildItemCard(CreationsHistory item) {
    return GestureDetector(
      onTap: () {
        if (controller.isEdit.value) {
          // 编辑模式下切换选中状态
          if (item.id != null) {
            controller.toggleSelection(item.id!);
          }
        } else {
          // 非编辑模式下跳转到预览页面
          Get.toNamed(
            item.type == 1
                ? SARouteNames.videoPreview
                : SARouteNames.imagePreview,
            arguments: item.resultUrl,
          );
        }
      },
      child: Obx(() {
        final isSelected = item.id != null && controller.isSelected(item.id!);
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              Positioned.fill(
                child: SAImageWidget(
                  url: item.type == 1 ? item.originUrl : item.resultUrl ?? '',
                ),
              ),
              Positioned(
                left: 8.w,
                top: 8.w,
                child: Image.asset(
                  item.type == 1
                      ? "assets/images/sa_83.png"
                      : "assets/images/sa_84.png",
                  width: 24.w,
                  fit: BoxFit.contain,
                ),
              ),
              if (controller.isEdit.value)
                Positioned(
                  left: 0,
                  bottom: 16.w,
                  width: 218.w,
                  child: Center(
                    child: Image.asset(
                      isSelected
                          ? "assets/images/sa_87.png"
                          : "assets/images/sa_88.png",
                      width: 40.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
