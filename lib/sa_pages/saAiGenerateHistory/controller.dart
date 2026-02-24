import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';

enum CreationsType {
  video('VIDEOS'),
  image('IMAGES');

  const CreationsType(this.apiValue);

  final String apiValue;

  static CreationsType fromApiValue(String? value) {
    switch (value?.toUpperCase()) {
      case 'VIDEOS':
        return CreationsType.video;
      case 'IMAGES':
        return CreationsType.image;
      default:
        return CreationsType.video;
    }
  }

  String get displayName {
    switch (this) {
      case CreationsType.video:
        return 'Videos';
      case CreationsType.image:
        return 'Images';
    }
  }
}

class SaaigeneratehistoryController extends GetxController
    with GetTickerProviderStateMixin, WidgetsBindingObserver {
  SaaigeneratehistoryController();

  final state = SaaigeneratehistoryState();

  int page = 1;
  int size = 15;
  final EasyRefreshController refreshCtr = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  final RxMap<String, int> statusCounts = <String, int>{
    CreationsType.video.apiValue: 0,
    CreationsType.image.apiValue: 0,
  }.obs;
  var creationsList = <CreationsType>[].obs;
  List<bool> isNoMoreData = [];
  late TabController tabController;
  // 记录每个选项卡的数据加载状态
  final List<RxBool> isDataLoaded = [];
  final List<RxBool> isLoading = [];
  var list = <RxList<CreationsHistory>>[];
  Rx<EmptyType?> type = Rx<EmptyType?>(null);
  //是否编辑模式
  final isEdit = false.obs;

  //选中视频/图片 ID 数组
  final selectedIDs = <int>[].obs;
  static const Duration _actionDebounceDuration = Duration(milliseconds: 800);
  DateTime? _lastDownloadClickAt;
  DateTime? _lastDeleteClickAt;
  bool _isDownloading = false;
  bool _isDeleting = false;

  // 当前选中索引
  final currentIndex = 0.obs;

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    initData();
  }

  // 初始化数据
  void initData() async {
    SAlogEvent('creations_show');
    // 初始化选项卡数据加载状态
    isDataLoaded.clear();
    isLoading.clear();

    creationsList.addAll([CreationsType.video, CreationsType.image]);
    for (int i = 0; i < creationsList.length; i++) {
      isDataLoaded.add(false.obs);
      isLoading.add(false.obs);
      list.add(<CreationsHistory>[].obs);
      isNoMoreData.add(false);
    }
    // 初始化选项卡控制器
    tabController = TabController(
      length: creationsList.length,
      vsync: this,
      animationDuration: const Duration(milliseconds: 200),
    );
    // 初始化选项卡数据
    SALoading.show();
    //获取历史记录数量统计
    await historyCount();

    onRefresh(0);
    tabController.addListener(() {
      currentIndex.value = tabController.index;
      // 避免重复触发（Tab 切换动画过程中索引会变化）
      if (tabController.indexIsChanging) return;

      // 切换 tab 时清空选中状态
      if (isEdit.value) {
        selectedIDs.clear();
      }
      // 切换 tab 时清空编辑状态
      isEdit.value = false;

      final tabState = list[currentIndex.value];
      // if (tabController.index + 1 == HomeListCategroy.video.index) {
      //   SAlogEvent('c_videochat');
      // }
      // 首次切换且未加载过数据 → 加载初始数据
      if (tabState.isEmpty && !isLoading[currentIndex.value].value) {
        onRefresh(currentIndex.value);
      }
    });
  }

  Future<void> historyCount() async {
    var res = await ImageAPI.getAiPhotoHistoryCount();
    log.e("historyCount: $res['videos'], $res['images']");
    statusCounts[CreationsType.video.apiValue] = res['video'] ?? 0;
    statusCounts[CreationsType.image.apiValue] = res['image'] ?? 0;
    log.e('historyCount: $statusCounts');
  }

  /// 刷新当前页面数据
  Future<void> refreshCurrentPage() async {
    await Future.wait([historyCount(), onRefresh(currentIndex.value)]);
  }

  Future<void> onRefresh(int index) async {
    try {
      page = 1;
      isNoMoreData[index] = false;
      await _fetchData(index);

      await Future.delayed(const Duration(milliseconds: 50));
      refreshCtr.finishRefresh();
      refreshCtr.finishLoad(
        isNoMoreData[index] ? IndicatorResult.noMore : IndicatorResult.none,
      );
    } finally {
      if (index == 0) {
        SALoading.close();
      }
      isDataLoaded[index].value = true;
      isLoading[index].value = false;
    }
    historyCount();
  }

  Future<void> onLoad(int index) async {
    if (isLoading[index].value) return;
    if (isNoMoreData[index]) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        refreshCtr.finishLoad(IndicatorResult.noMore);
      });
      return;
    }

    // isLoading[index].value = true;

    try {
      page++;
      await _fetchData(index);

      await Future.delayed(const Duration(milliseconds: 50));
      refreshCtr.finishLoad(
        isNoMoreData[index] ? IndicatorResult.noMore : IndicatorResult.none,
      );
    } catch (e) {
      page--;
      refreshCtr.finishLoad(IndicatorResult.fail);
    } finally {
      isLoading[index].value = false;
    }
  }

  Future _fetchData(int index) async {
    isLoading[index].value = true;
    var cate = creationsList[index];
    var types = 0;
    if (cate == CreationsType.video) {
      types = 1;
    } else if (cate == CreationsType.image) {
      types = 0;
    }

    try {
      final res = await ImageAPI.getAiPhotoHistoryList(
        page: page,
        size: size,
        type: types,
      );
      isNoMoreData[index] = (res.length) < size;

      if (page == 1) {
        list[index].clear();
      }

      type.value = list[index].isEmpty ? EmptyType.noData : null;
      list[index].addAll(res);
      isDataLoaded[index].value = true;
      isLoading[index].value = false;
    } catch (e) {
      type.value = list[index].isEmpty ? EmptyType.noData : null;
    } finally {
      // SALoading.close();
    }
  }

  /// 切换编辑模式
  void toggleEditMode() {
    isEdit.value = !isEdit.value;
    if (!isEdit.value) {
      // 退出编辑模式时清空选中
      selectedIDs.clear();
    }
  }

  /// 切换选中状态
  void toggleSelection(int id) {
    if (selectedIDs.contains(id)) {
      selectedIDs.remove(id);
    } else {
      selectedIDs.add(id);
    }
  }

  /// 检查是否选中
  bool isSelected(int id) {
    return selectedIDs.contains(id);
  }

  /// 全选当前 tab 的所有项
  void selectAll() {
    selectedIDs.clear();
    final currentList = list[currentIndex.value];
    for (var item in currentList) {
      if (item.id != null) {
        selectedIDs.add(item.id!);
      }
    }
  }

  /// 取消全选
  void clearSelection() {
    selectedIDs.clear();
  }

  bool _isDebouncedClick(DateTime? lastClickAt) {
    if (lastClickAt == null) {
      return false;
    }
    return DateTime.now().difference(lastClickAt) < _actionDebounceDuration;
  }

  //下载历史记录
  void downloadSelected() async {
    if (_isDownloading || _isDebouncedClick(_lastDownloadClickAt)) {
      return;
    }
    _lastDownloadClickAt = DateTime.now();
    _isDownloading = true;

    try {
      if (selectedIDs.isEmpty) {
        SAToast.toastDebounce(SATextData.selectItem);
        return;
      }
      SALoading.show();
      await SA.login.fetchUserInfo();
      if (!SA.login.vipStatus.value) {
        SALoading.close();
        Get.toNamed(SARouteNames.vip, arguments: VipFrom.creations);
        return;
      }

      // 检查权限
      final hasPermission = await _requestPermission();
      if (!hasPermission) {
        SALoading.close();
        SAToast.show(SATextData.imagePermission);
        return;
      }

      SAlogEvent('creations_save_click');

      // 只获取当前 tab 中选中的项目
      final currentList = list[currentIndex.value];
      final selectedItems = currentList
          .where((item) => item.id != null && selectedIDs.contains(item.id!))
          .toList();

      int successCount = 0;
      int failCount = 0;

      // 批量下载
      for (var item in selectedItems) {
        try {
          final url = item.resultUrl ?? item.originUrl;
          if (url == null || url.isEmpty) {
            failCount++;
            continue;
          }

          // 下载文件
          final response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            final bytes = response.bodyBytes;
            final timestamp = DateTime.now().millisecondsSinceEpoch;

            // 根据类型保存
            if (item.type == 1) {
              // 视频 - 需要先保存为临时文件
              final tempDir = Directory.systemTemp;
              final tempFile = File(
                '${tempDir.path}/temp_video_$timestamp.mp4',
              );
              await tempFile.writeAsBytes(bytes);

              await PhotoManager.editor.saveVideo(tempFile);

              // 删除临时文件
              await tempFile.delete();
            } else {
              // 图片
              await PhotoManager.editor.saveImage(
                bytes,
                filename: 'AI_Image_$timestamp.jpg',
              );
            }
            successCount++;
          } else {
            failCount++;
          }
        } catch (e) {
          log.e('Download error: ${e.toString()}');
          failCount++;
        }
      }

      SALoading.close();

      // 显示结果
      if (successCount > 0 && failCount == 0) {
        SAToast.show('Saved successfully ($successCount)');
        selectedIDs.clear();
        isEdit.value = false;
      } else if (successCount > 0 && failCount > 0) {
        SAToast.show(
          'Partially saved: $successCount success, $failCount failed',
        );
      } else {
        SAToast.show('Save failed');
      }
    } catch (e) {
      SALoading.close();
      log.e('Error: ${e.toString()}');
      SAToast.show('Error: ${e.toString()}');
    } finally {
      _isDownloading = false;
    }
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      // Android 13+ 使用新的权限模型
      if (await Permission.photos.isGranted) {
        return true;
      }

      final status = await Permission.photos.request();
      if (status.isGranted) {
        return true;
      }

      // 如果photos权限被拒绝，尝试storage权限（适用于旧版本Android）
      if (await Permission.storage.isGranted) {
        return true;
      }

      final storageStatus = await Permission.storage.request();
      return storageStatus.isGranted;
    } else if (Platform.isIOS) {
      // iOS 使用photos权限
      if (await Permission.photos.isGranted) {
        return true;
      }

      final status = await Permission.photos.request();
      return status.isGranted;
    }

    return false;
  }

  //删除历史记录
  void deleteHistory() async {
    if (_isDeleting || _isDebouncedClick(_lastDeleteClickAt)) {
      return;
    }
    _lastDeleteClickAt = DateTime.now();
    _isDeleting = true;

    try {
      if (selectedIDs.isEmpty) {
        SAToast.toastDebounce(SATextData.selectItem);
        return;
      }

      var res = await ImageAPI.deleteAiPhotoHistory(selectedIDs);
      if (res) {
        selectedIDs.clear();
        isEdit.value = false;
        // 只刷新当前 tab 的数据
        refreshCurrentPage();
        SAToast.show('Deleted successfully');
      } else {
        SAToast.show('Delete failed');
      }
    } finally {
      _isDeleting = false;
    }
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
    // 注册生命周期观察者
    WidgetsBinding.instance.addObserver(this);
  }

  /// 监听应用生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 当应用从后台返回前台或页面重新获得焦点时刷新数据
    if (state == AppLifecycleState.resumed) {
      refreshCurrentPage();
    }
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    // 移除生命周期观察者
    WidgetsBinding.instance.removeObserver(this);
    tabController.dispose();
    refreshCtr.dispose();
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
