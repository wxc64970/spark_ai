import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

class SamomentsController extends GetxController {
  SamomentsController();

  final EasyRefreshController cjRefreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);

  int page = 1;
  int size = 1000;
  RxList<dynamic> list = [].obs;
  EmptyType? type = EmptyType.SALoading;
  final _loading = true.obs;
  get loading => _loading.value;
  set loading(bool value) => _loading.value = value;
  bool isNoMoreData = false;

  _initData() async {
    await onRefresh();
    update(["cjmoments"]);
  }

  Future<void> onRefresh() async {
    page = 1;
    await _fetchData();
    cjRefreshController.finishRefresh();
    cjRefreshController.resetFooter();
  }

  Future<void> onLoad() async {
    await _fetchData();
    cjRefreshController.finishLoad(isNoMoreData ? IndicatorResult.noMore : IndicatorResult.none);
  }

  Future<List<SAPost>?> _fetchData() async {
    try {
      final records = await Api.momensListPage(page: page, size: size) ?? [];
      type = records.isEmpty ? (SANetworkMonitorService.to.isConnected == false ? EmptyType.noNetwork : EmptyType.noData) : type;
      loading = records.isEmpty ? (SANetworkMonitorService.to.isConnected == false ? true : true) : loading;
      isNoMoreData = records.length < size;

      if (page == 1) {
        list.clear();
      }

      type = null;
      loading = false;
      list.addAll(records);
      page++;
      update();
      return records;
    } catch (e) {
      type = list.isEmpty ? (SANetworkMonitorService.to.isConnected == false ? EmptyType.noNetwork : EmptyType.noData) : type;
      update();
      return null;
    }
  }

  void onItemClick(SAPost data) async {
    final chaterId = data.characterId;

    if (chaterId == null) {
      SmartDialog.showToast('No chaterId');
      return;
    }

    SmartDialog.showLoading();

    try {
      // 并行执行异步任务

      final (role, session) = await (Api.loadRoleById(chaterId), Api.addSession(chaterId)).wait;

      SmartDialog.dismiss();

      if (role == null) {
        SmartDialog.showToast('No role');
        return;
      }
      if (session == null) {
        SmartDialog.showToast('No session');
        return;
      }

      RoutePages.pushChat(role.id);
    } catch (e) {
      // 捕获异常并提示用户
      SmartDialog.dismiss();
      SmartDialog.showToast('Failed to load data: $e');
    }
  }

  void onPlay(SAPost data) {
    var isVideo = data.cover != null && data.duration != null;
    var imgUrl = isVideo ? data.cover : data.media;

    if (isVideo) {
      if (data.media != null) {
        Get.toNamed(SARouteNames.videoPreview, arguments: data.media!);
      } else {
        SmartDialog.showToast('No video');
      }
    } else {
      Get.toNamed(SARouteNames.imagePreview, arguments: imgUrl ?? '');
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void dispose() {
    cjRefreshController.dispose();
    super.dispose();
  }
}
