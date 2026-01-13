import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';

class SalanguageController extends GetxController {
  SalanguageController();

  final state = SalanguageState();

  List<SAAzListContactModel> contactList = [];

  List<String> get symbols => contactList.map((e) => e.section).toList();

  final indexBarContainerKey = GlobalKey();

  bool isShowListMode = true;

  ValueNotifier<AzListCursorInfoModel?> cursorInfo = ValueNotifier(null);

  double indexBarWidth = 20;

  ScrollController scrollController = ScrollController();

  late SliverObserverController observerController;

  Map<int, BuildContext> sliverContextMap = {};

  var choosedName = ''.obs;
  SALang? selectedLang; // 保存选中的语言对象
  Rx<EmptyType?> emptyType = Rx<EmptyType?>(null);

  Future<void> generateContactData() async {
    try {
      emptyType.value = EmptyType.SALoading;
      // 从 IConfig 获取语言数据（内部已处理缓存逻辑）
      await SA.login.loadAppLangs();
      final appLangs = SA.login.appLangs;

      if (appLangs != null) {
        _buildContactListFromData(appLangs);
        emptyType.value = null;
      }
    } catch (e) {
      debugPrint('Error SALoading language data: $e');
      // 如果加载失败，可以使用默认数据或显示错误
      emptyType.value = null;
    }
  }

  // 从数据构建联系人列表的辅助方法
  void _buildContactListFromData(Map<String, dynamic> appLangs) {
    contactList.clear();

    // 遍历每个字母分组
    appLangs.forEach((key, value) {
      if (value is List) {
        List<String> names = [];
        List<SALang> langs = [];

        // 将每个语言项转换为 SALang 对象
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            final lang = SALang.fromJson(item);
            if (lang.label != null) {
              names.add(lang.label!);
              langs.add(lang);
            }
          }
        }

        if (names.isNotEmpty) {
          contactList.add(SAAzListContactModel(section: key, names: names, langs: langs));
        }
      }
    });
  }

  /// 保存按钮点击处理
  void onSaveButtonTapped() async {
    if (selectedLang != null) {
      debugPrint('Saving selected language: ${selectedLang!.label} - ${selectedLang!.value}');

      SALoading.show();

      final isOK = await Api.updateEventParams(lang: selectedLang?.value);
      if (isOK) {
        SA.login.sessionLang.value = selectedLang;
        await SA.login.fetchUserInfo();
      }

      SALoading.close();

      // 返回上一页
      Get.back(result: selectedLang);
    } else {
      debugPrint('No language selected');
      // 可以显示提示信息
      SAToast.show('Please select a language');
    }
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    observerController = SliverObserverController(controller: scrollController);

    _loadLanguageData();
  }

  Future<void> _loadLanguageData() async {
    await generateContactData();

    // 设置默认选中的语言
    _setDefaultSelectedLanguage();
    update();
  }

  /// 设置默认选中的语言
  void _setDefaultSelectedLanguage() {
    try {
      // 使用 UserHelper 的 matchUserLang 方法获取匹配的语言
      final matchedLang = SA.login.matchUserLang();

      if (matchedLang.label != null) {
        choosedName.value = matchedLang.label!;
        selectedLang = matchedLang;
        debugPrint('Default selected language: ${matchedLang.label} - ${matchedLang.value}');
      }
    } catch (e) {
      debugPrint('Error setting default language: $e');
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
    super.dispose();
  }
}
