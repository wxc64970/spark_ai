import 'dart:math' as math;
import 'dart:ui';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:spark_ai/ad/sa_my_ad.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/saCommon/sa_values/sa_colors.dart';

import '../../index.dart';
import 'gradient_underline_tabIndicator.dart';

class BuildDiscoveryList extends GetView<SadiscoveryController> {
  const BuildDiscoveryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
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
                insets: EdgeInsets.fromLTRB(26.w, 0, 26.w, 4.w),
                radius: 100.r,
              ),
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.only(right: 64.w), // Tab 之间的间距
              unselectedLabelStyle: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w400), // 未选中文字样式
              labelStyle: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600), // 选中文字样式
              tabs: List.generate(controller.categroyList.length, (index) {
                final data = controller.categroyList[index];

                return SizedBox(
                  height: 50.w,
                  child: Stack(
                    children: [
                      Text(
                        data.title,
                        style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600, color: Colors.transparent),
                      ),
                      Text(data.title),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
        SizedBox(height: 16.w),
        controller.categroyList.isEmpty
            ? const Center(child: Text("暂无数据"))
            : Expanded(
                child: TabBarView(controller: controller.tabController, children: List.generate(controller.categroyList.length, (index) => _buildContent(index))),
              ),
      ],
    );
  }

  Widget _buildContent(int index) {
    return GetBuilder<SadiscoveryController>(
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
                return EmptyWidget(type: controller.type.value!, physics: physics);
              }
              return _buildList(physics, list[index], index);
            });
          },
        );
      },
    );
  }

  Widget _buildList(ScrollPhysics physics, List<ChaterModel> list, int tabIndex) {
    // 只在all分类下显示广告
    controller.nativeAd ??= MyAd().nativeAd;
    final bool showAd =
        tabIndex == HomeListCategroy.all.index &&
        controller.nativeAd !=
            null //
            &&
        SA.login.vipStatus.value == false;
    final itemCount = showAd ? list.length + 1 : list.length;
    return GridView.builder(
      key: PageStorageKey("tab_$tabIndex"),
      physics: physics,
      itemCount: itemCount,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 固定 2 列
        crossAxisSpacing: 8.w, // 列之间的间距
        mainAxisSpacing: 8.w, // 行之间的间距
        childAspectRatio: 310.w / 450.w,
        // childAspectRatio: 335 / 370, // 子项宽高比（宽/高），控制网格项形状
      ),
      itemBuilder: (context, index) {
        // 计算实际的列表索引，只在显示广告时调整索引
        final int realIndex = showAd && index > 2 ? index - 1 : index;

        // 在all分类下的第4个位置插入广告
        if (showAd && index == 2) {
          if (controller.nativeAd != null) {
            return Container(
              color: Colors.red,
              constraints: BoxConstraints(minWidth: 335, minHeight: 370),
              child: Stack(
                children: [
                  Material(elevation: 0, child: AdWidget(ad: controller.nativeAd!)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: SAAppColors.pinkColor),
                    child: Text(
                      'Ad',
                      style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          }
        }
        final data = list[realIndex];
        final displayTags = data.buildDisplayTags();
        final shouldShowTags = displayTags.isNotEmpty && SA.storage.isSAB;
        return InkWell(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (controller.tabController.index + 1 == HomeListCategroy.video.index) {
              Get.toNamed(SARouteNames.phoneGuide, arguments: {'role': data});
              SAlogEvent('c_videochat_char');
            } else {
              RoutePages.pushChat(data.id);
            }
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: const Alignment(0, -0.5), end: const Alignment(1, 0.5), colors: const [SAAppColors.primaryColor, SAAppColors.yellowColor]),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: data.vip == true ? EdgeInsets.all(4.w) : EdgeInsets.zero,
              // 边框厚度
              child: Container(
                width: 336.w,
                height: 448.w,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                child: Stack(
                  children: [
                    // 背景图片
                    SAImageWidget(url: data.avatar, width: 360.w, height: 500.w, cacheWidth: 1080, cacheHeight: 1080, borderRadius: BorderRadius.circular(16.r), shape: BoxShape.rectangle),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: Get.width,
                        height: 160.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Color(0xff000000), Color(0xff000000).withValues(alpha: 0)]),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width,
                      height: Get.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.onCollect(tabIndex, index, data);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 10.w),
                                    decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8.r)),
                                    child: Row(
                                      children: [
                                        Image.asset(data.collect! ? "assets/images/sa_04.png" : "assets/images/sa_03.png", width: 24.w, fit: BoxFit.contain),
                                        SizedBox(width: 4.w),
                                        Text(
                                          data.likes.toString(),
                                          style: TextStyle(fontSize: 20.sp, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(maxWidth: 210.w),
                                      child: Text(
                                        data.name ?? "",
                                        style: TextStyle(fontSize: 32.sp, color: Colors.white, fontWeight: FontWeight.w500, height: 1),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    data.age == null
                                        ? const SizedBox()
                                        : Container(
                                            constraints: BoxConstraints(maxWidth: 70.w),
                                            padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 16.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(40.r),
                                              gradient: LinearGradient(
                                                begin: Alignment(math.cos(164 * math.pi / 180), math.sin(-100 * math.pi / 180)),
                                                end: Alignment(math.cos(164 * math.pi / 180 + math.pi), math.sin(-100 * math.pi / 180 + math.pi)),
                                                colors: [SAAppColors.primaryColor, SAAppColors.yellowColor],
                                              ),
                                            ),
                                            child: Text(
                                              '${data.age}',
                                              style: TextStyle(fontFamily: "Montserrat", fontSize: 18.sp, color: Colors.black, height: 1, fontWeight: FontWeight.w600),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                  ],
                                ),
                                if (shouldShowTags) ...[SizedBox(height: 8.w), _buildTags(displayTags)],
                                SizedBox(height: 10.w),
                                Text(
                                  data.aboutMe ?? "",
                                  style: TextStyle(fontSize: 24.sp, color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTags(List<String> displayTags) {
    return SizedBox(
      width: 304.w,
      height: 34.w,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: displayTags.length,
        itemBuilder: (context, i) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 16.w),
            decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(8.r)),
            child: Text(
              displayTags[i],
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400, color: _getTagColor(displayTags[i])),
            ),
          );
        },
      ),
    );
  }

  Color _getTagColor(String text) {
    return SAAppColors.primaryColor;
  }
}
