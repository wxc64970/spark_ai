import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/index.dart';
import 'package:spark_ai/sa_pages/saChat/widgets/sa_f_c.dart';

import 'index.dart';

class SasearchController extends GetxController {
  SasearchController();

  final state = SasearchState();
  final focusNode = FocusNode();
  final textController = TextEditingController();
  final scrollController = ScrollController();

  // 常量定义
  static const int _defaultPage = 1;
  static const int _defaultSize = 1000;
  static const Duration debounceDelay = Duration(milliseconds: 500);

  // 分页参数
  int page = _defaultPage;
  int size = _defaultSize;

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    focusNode.requestFocus();

    // 添加滚动监听器，滚动时关闭键盘
    scrollController.addListener(() {
      if (scrollController.position.isScrollingNotifier.value) {
        focusNode.unfocus();
      }
    });
    _setupSearchDebounce();
  }

  /// 设置搜索防抖
  void _setupSearchDebounce() {
    debounce(state.searchQuery, (_) {
      final requestId = _generateRequestId();
      state.currentRequestId = requestId;
      search(state.searchQuery.value, requestId);
    }, time: debounceDelay);
  }

  /// 生成唯一请求ID
  int _generateRequestId() => DateTime.now().millisecondsSinceEpoch;

  /// 搜索角色
  Future<void> search(String searchText, int requestId) async {
    try {
      if (searchText.trim().isEmpty) {
        _clearSearchResults();
        return;
      }

      _setLoadingState();
      final res = await Api.homeList(page: page, size: size, name: searchText.trim());

      // 检查请求是否已过期
      if (!_isRequestValid(requestId)) {
        return;
      }

      _updateSearchResults(res?.records ?? []);
    } catch (e, stackTrace) {
      log.e('搜索请求失败', error: e, stackTrace: stackTrace);
      _handleSearchError();
    }
  }

  /// 清空搜索结果
  void _clearSearchResults() {
    state.list.clear();
    state.type.value = EmptyType.noData;
  }

  /// 设置加载状态
  void _setLoadingState() {
    state.type.value = EmptyType.SALoading;
  }

  /// 检查请求是否有效
  bool _isRequestValid(int requestId) => requestId == state.currentRequestId;

  /// 更新搜索结果
  void _updateSearchResults(List<ChaterModel> records) {
    if (page == _defaultPage) {
      state.list.clear();
    }

    state.list.addAll(records);
    state.type.value = state.list.isEmpty ? EmptyType.noSearch : null;
  }

  /// 处理搜索错误
  void _handleSearchError() {
    state.type.value = state.list.isEmpty ? EmptyType.noSearch : null;
  }

  /// 处理收藏/取消收藏操作
  Future<void> onCollect(int index, ChaterModel role) async {
    focusNode.unfocus();
    final targetRole = state.list[index];
    final chatId = targetRole.id;

    if (chatId == null) {
      log.w('角色ID为空 无法执行收藏操作');
      return;
    }

    final chatIdStr = chatId.toString();
    final isCurrentlyCollected = targetRole.collect == true;

    try {
      SALoading.show();

      final success = isCurrentlyCollected ? await Api.cancelCollectRole(chatIdStr) : await Api.collectRole(chatIdStr);

      if (success) {
        _updateCollectionState(targetRole, !isCurrentlyCollected, chatIdStr);

        if (!isCurrentlyCollected) {
          if (!SA.storage.isShowGoodCommentDialog) {
            DialogWidget.showPositiveReview();
            SA.storage.setShowGoodCommentDialog(true);
          }
        }
      }
    } catch (e, stackTrace) {
      log.e('收藏操作失败', error: e, stackTrace: stackTrace);
    } finally {
      SALoading.close();
    }
  }

  /// 更新收藏状态
  void _updateCollectionState(ChaterModel role, bool isCollected, String chatId) {
    role.collect = isCollected;
    state.list.refresh();

    _notifyFollowEvent(isCollected, chatId);
    _refreshLikedController();
  }

  /// 通知关注事件
  void _notifyFollowEvent(bool isCollected, String chatId) {
    try {
      final followEvent = isCollected ? FollowEvent.follow : FollowEvent.unfollow;
      SALogUtil.d('通知关注事件: $followEvent, chatId: $chatId');
      Get.find<SadiscoveryController>().followEvent.value = (followEvent, chatId, DateTime.now().millisecondsSinceEpoch);
    } catch (e, stackTrace) {
      log.e('通知关注事件失败', error: e, stackTrace: stackTrace);
    }
  }

  /// 刷新收藏控制器
  void _refreshLikedController() {
    try {
      if (Get.isRegistered<FollowController>()) {
        Get.find<FollowController>().onRefresh();
      }
    } catch (e, stackTrace) {
      log.e('刷新收藏列表失败', error: e, stackTrace: stackTrace);
    }
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
    focusNode.unfocus();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
