import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/message/index.dart';

import 'index.dart';

class SamaskController extends GetxController {
  SamaskController();

  final state = SamaskState();

  static const int pageSize = 10;

  late final EasyRefreshController refreshController;
  final msgCtr = Get.find<MessageController>();

  // tap
  void handleChangeMask() async {
    if (needConfirmChange) {
      DialogWidget.alert(
        message: SATextData.maskAlreadyLoaded,
        cancelText: SATextData.cancel,
        confirmText: SATextData.confirm,
        onConfirm: () async {
          DialogWidget.dismiss();
          await changeMask();
        },
      );
    } else {
      await changeMask();
    }
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    refreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);

    // 延迟触发刷新
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300)).then((_) {
        refreshController.callRefresh();
      });
    });
  }

  /// 下拉刷新
  Future<void> onRefresh() async {
    state.currentPage.value = 1;
    await _fetchData();
    refreshController.finishRefresh();
    refreshController.resetFooter();
  }

  /// 上拉加载更多
  Future<void> onLoad() async {
    state.currentPage.value += 1;
    await _fetchData();
    refreshController.finishLoad(state.hasMore.value ? IndicatorResult.none : IndicatorResult.noMore);
  }

  /// 获取数据
  Future<void> _fetchData() async {
    if (state.isLoading.value) {
      return;
    }

    try {
      state.isLoading.value = true;
      final records = await Api.getMaskList(page: state.currentPage.value, size: pageSize);

      state.hasMore.value = (records?.length ?? 0) >= pageSize;

      if (state.currentPage.value == 1) {
        state.maskList.clear();
      }
      state.maskList.addAll(records ?? []);

      // 自动选择当前会话的 mask
      if (state.selectedMask.value == null && state.maskList.isNotEmpty && msgCtr.state.session.profileId != null) {
        state.selectedMask.value = state.maskList.firstWhereOrNull((element) => element.id == msgCtr.state.session.profileId);
      }
      print(state.maskList.length);
      //  state.maskList.clear();
      state.emptyType.value = state.maskList.isEmpty ? EmptyType.noSearch : null;
      print(state.emptyType.value);
    } catch (e) {
      state.emptyType.value = state.maskList.isEmpty ? EmptyType.noNetwork : null;
      if (state.currentPage.value > 1) {
        state.currentPage.value -= 1;
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  /// 选择 mask
  void selectMask(SAMaskModel mask) {
    state.selectedMask.value = mask;
  }

  /// 推送编辑页面
  Future<void> pushEditPage({SAMaskModel? mask}) async {
    await Get.toNamed(SARouteNames.editMask, arguments: mask);
    onRefresh();
  }

  /// 更换 mask
  Future<void> changeMask() async {
    final maskId = state.selectedMask.value?.id;
    if (maskId == null) {
      return;
    }

    if (maskId == msgCtr.state.session.profileId) {
      Get.back();
      return;
    }

    final res = await msgCtr.changeMask(maskId);
    if (res) {
      Get.back();
    }
  }

  /// 检查是否需要确认更换 mask
  bool get needConfirmChange {
    final maskId = state.selectedMask.value?.id;
    return maskId != null && msgCtr.state.session.profileId != maskId;
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }
}
