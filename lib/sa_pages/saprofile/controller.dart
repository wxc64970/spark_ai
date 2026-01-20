import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/message/controller.dart';
import 'package:spark_ai/sa_pages/saDisCovery/controller.dart';

import 'index.dart';
import 'widgets/sa_option_sheet.dart';

class SaprofileController extends GetxController with GetSingleTickerProviderStateMixin {
  SaprofileController();

  final state = SaprofileState();

  final msgCtr = Get.find<MessageController>();

  late ChaterModel role;

  RxList images = <RoleImage>[].obs;
  final List<String> tabs = SA.storage.isSAB ? [SATextData.info, SATextData.tagsTitle, SATextData.Moments] : [SATextData.info];
  late TabController tabController;

  void onCollect() async {
    final id = role.id;
    if (id == null) {
      return;
    }
    if (state.isLoading) {
      return;
    }
    SALoading.show();

    if (state.collect) {
      final res = await Api.cancelCollectRole(id);
      if (res) {
        role.collect = false;
        state.collect = false;
        Get.find<SadiscoveryController>().followEvent.value = (FollowEvent.unfollow, id, DateTime.now().millisecondsSinceEpoch);
      }
      state.isLoading = false;
    } else {
      final res = await Api.collectRole(id);
      if (res) {
        role.collect = true;
        state.collect = true;
        Get.find<SadiscoveryController>().followEvent.value = (FollowEvent.follow, id, DateTime.now().millisecondsSinceEpoch);

        if (!SA.storage.isShowGoodCommentDialog) {
          DialogWidget.showPositiveReview();
          SA.storage.setShowGoodCommentDialog(true);
        }
      }
      state.isLoading = false;
    }
    SALoading.close();
  }

  report() {
    Get.bottomSheet(OptionSheet());
  }

  clearHistory() {
    DialogWidget.alert(
      message: SATextData.clearHistoryConfirmation,
      cancelText: SATextData.cancel,
      onConfirm: () async {
        DialogWidget.dismiss();
        await msgCtr.resetConv();
        Get.back();
      },
    );
  }

  void deleteChat() async {
    DialogWidget.alert(
      message: SATextData.deleteChatConfirmation,
      cancelText: SATextData.cancel,
      onConfirm: () async {
        DialogWidget.dismiss();
        var res = await msgCtr.deleteConv();
        if (res) {
          Get.until((route) => route.isFirst);
        }
      },
    );
  }

  handleReport() {
    Get.bottomSheet(SAReportSheet(), isScrollControlled: true);
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments is ChaterModel) {
      role = arguments;
    }
    tabController = TabController(length: tabs.length, vsync: this, animationDuration: const Duration(milliseconds: 200));
    tabController.addListener(() {
      // final currentIndex = tabController.index;
      // 避免重复触发（Tab 切换动画过程中索引会变化）
      if (tabController.indexIsChanging) return;
    });
    images.value = role.images ?? [];

    state.collect = role.collect ?? false;
    ever(msgCtr.state.roleImagesChaned, (_) {
      images.value = msgCtr.state.role.images ?? [];
    });
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
