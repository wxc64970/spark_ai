import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/sa_values/textData.dart';

import 'widgets/sa_c_con.dart';
import 'widgets/sa_f_c.dart';

class SachatController extends GetxController with GetSingleTickerProviderStateMixin, RouteAware {
  SachatController();

  final List<String> tabs = [SATextData.chatted, SATextData.liked];
  late TabController tabController;
  // 记录每个选项卡的数据加载状态
  final List<RxBool> isDataLoaded = [];
  final List<RxBool> isLoading = [];

  final chatCtr = Get.put(ConversationController());
  final likedCtr = Get.put(FollowController());

  // 当前选中索引
  final currentIndex = 0.obs;

  _initData() {
    for (int i = 0; i < tabs.length; i++) {
      isDataLoaded.add(false.obs);
      isLoading.add(false.obs);
      // list.add(<ChaterModel>[].obs);
    }

    chatCtr.onRefresh();

    tabController = TabController(length: tabs.length, vsync: this, animationDuration: const Duration(milliseconds: 200));
    tabController.addListener(() {
      final currentIndex = tabController.index;
      // 避免重复触发（Tab 切换动画过程中索引会变化）
      if (tabController.indexIsChanging) return;

      if (currentIndex == 1) {
        likedCtr.onRefresh();
      }
    });

    update(["chat"]);
  }

  // 当页面重新显示时调用（从其他页面返回）
  @override
  void didPopNext() {
    refreshCurrentTabList();
  }

  void refreshCurrentTabList() {
    chatCtr.onRefresh();
    likedCtr.onRefresh();
  }

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
