import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/saChat/widgets/sa_k_a_widget.dart';
import 'package:video_player/video_player.dart';

import 'widgets/sa_mak_widget.dart';

class SaaiphotoController extends GetxController
    with GetSingleTickerProviderStateMixin {
  SaaiphotoController();

  late List tabList;
  final List<String> tabs = [SATextData.aiPhoto, SATextData.ai_image_to_video];
  late TabController tabController;
  List<Widget> tabViews = [];
  // 当前选中索引
  final currentIndex = 0.obs;

  final _customPrompt = ''.obs;
  String get customPrompt => _customPrompt.value;
  set customPrompt(String value) => _customPrompt.value = value;
  VideoPlayerController? videoController;
  RxList<ItemConfigs>? aiPhotoList = <ItemConfigs>[].obs;

  void _initData() async {
    SALoading.show();
    List<ItemConfigs>? data = await ImageAPI.getAiPhoto();
    aiPhotoList!.addAll(data ?? []);
    SALoading.close();
    update(["allphoto"]);
  }

  void handleHistory() {
    Get.toNamed(SARouteNames.aiGenerateHistory);
  }

  void hanldeSku(from) {
    Get.toNamed(SARouteNames.countSku, arguments: from);
  }

  @override
  void onInit() {
    super.onInit();
    SAlogEvent('aiphoto_show');
    _initData();
    tabController = TabController(length: tabs.length, vsync: this);
    // 初始化数据
    tabViews = [
      KeepAliveWrapper(
        child: SAMakWidget(key: ValueKey('image'), type: SAAiViewType.image),
      ),
      KeepAliveWrapper(
        child: SAMakWidget(key: ValueKey('video'), type: SAAiViewType.video),
      ),
    ];
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

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
