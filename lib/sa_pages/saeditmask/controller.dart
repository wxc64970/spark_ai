import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/index.dart';

import 'index.dart';

class SaeditmaskController extends GetxController {
  SaeditmaskController();

  final state = SaeditmaskState();

  /// 页面常量定义
  static const int maxNameLength = 20;
  static const int maxDescriptionLength = 500;
  static const int maxOtherInfoLength = 500;
  static const int maxAge = 99999;

  // 文本控制器
  late final TextEditingController nameController;
  late final TextEditingController ageController;
  late final TextEditingController descriptionController;
  late final TextEditingController otherInfoController;

  final RxInt nameLength = 0.obs;
  final RxInt descriptionLength = 0.obs;
  final RxInt otherInfoLength = 0.obs;
  final Rx<Gender?> selectedGender = Rx<Gender?>(null);
  final RxBool isChanged = false.obs;
  final RxBool isLoading = false.obs;

  // 编辑的聊天角色（新建时为null）
  SAMaskModel? chatMask;

  final msgCtr = Get.find<MessageController>();

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    // 初始化文本控制器
    nameController = TextEditingController();
    ageController = TextEditingController();
    descriptionController = TextEditingController();
    otherInfoController = TextEditingController();

    // 设置监听器
    _setupTextListeners();

    // 初始化编辑数据
    _initializeEditData();
  }

  /// 设置文本监听器
  void _setupTextListeners() {
    nameController.addListener(() {
      nameLength.value = nameController.text.length;
      _updateChangeStatus();
    });

    descriptionController.addListener(() {
      descriptionLength.value = descriptionController.text.length;
      _updateChangeStatus();
    });

    otherInfoController.addListener(() {
      otherInfoLength.value = otherInfoController.text.length;
      _updateChangeStatus();
    });

    ageController.addListener(() {
      _updateChangeStatus();
    });
  }

  /// 更新变更状态
  void _updateChangeStatus() {
    if (chatMask == null) {
      // 新建模式：只要有内容就认为有变更
      isChanged.value = nameController.text.isNotEmpty || ageController.text.isNotEmpty || descriptionController.text.isNotEmpty || otherInfoController.text.isNotEmpty || selectedGender.value != null;
    } else {
      // 编辑模式：与原始数据比较
      isChanged.value =
          nameController.text != (chatMask?.profileName ?? '') ||
          ageController.text != (chatMask?.age?.toString() ?? '') ||
          descriptionController.text != (chatMask?.description ?? '') ||
          otherInfoController.text != (chatMask?.otherInfo ?? '') ||
          selectedGender.value?.code != chatMask?.gender;
    }
  }

  /// 初始化编辑数据
  void _initializeEditData() {
    chatMask = Get.arguments;

    if (chatMask != null) {
      nameController.text = chatMask?.profileName ?? '';
      descriptionController.text = chatMask?.description ?? '';
      ageController.text = chatMask?.age == null ? '' : chatMask?.age.toString() ?? '';
      otherInfoController.text = chatMask?.otherInfo ?? '';
      selectedGender.value = Gender.values.firstWhereOrNull((gender) => gender.code == chatMask?.gender);

      // 更新字符计数
      nameLength.value = nameController.text.length;
      descriptionLength.value = descriptionController.text.length;
      otherInfoLength.value = otherInfoController.text.length;
    }

    // 初始状态下没有变更
    isChanged.value = false;
  }

  /// 选择性别
  void selectGender(Gender gender) {
    selectedGender.value = gender;
    _updateChangeStatus();
  }

  /// 验证表单数据
  String? _validateForm() {
    if (nameController.text.trim().isEmpty) {
      // return LocaleKeys.fill_required_info.tr;
      return SATextData.fillRequiredInfo;
    }

    if (descriptionController.text.trim().isEmpty) {
      // return LocaleKeys.fill_required_info.tr;
      return SATextData.fillRequiredInfo;
    }

    if (selectedGender.value == null) {
      // return LocaleKeys.fill_required_info.tr;
      return SATextData.fillRequiredInfo;
    }

    return null;
  }

  /// 显示错误提示
  void _showError(String message) {
    SAToast.show(message);
  }

  /// 保存角色信息
  Future<void> saveMask() async {
    // 验证表单
    final errorMessage = _validateForm();
    if (errorMessage != null) {
      _showError(errorMessage);
      return;
    }

    // 关闭键盘
    Get.focusScope?.unfocus();

    // 检查是否新建且余额不足
    if (chatMask == null) {
      final balance = SA.login.gemBalance.value;
      final profileChange = SA.login.configPrice?.profileChange ?? 5;
      if (balance < profileChange) {
        Get.toNamed(SARouteNames.gems, arguments: ConsumeFrom.mask);
        return;
      }
    }

    final isEditChoosed = chatMask != null && chatMask?.id == msgCtr.state.session.profileId;

    if (isEditChoosed && isChanged.value) {
      DialogWidget.alert(
        // message: LocaleKeys.edit_choose_mask.tr,
        // cancelText: LocaleKeys.cancel.tr,
        // confirmText: LocaleKeys.restart.tr,
        message: SATextData.editChooseMask,
        cancelText: SATextData.cancel,
        confirmText: SATextData.restart,
        onConfirm: () async {
          DialogWidget.dismiss();
          await _saveRequest();
        },
      );
    } else {
      await _saveRequest();
    }
  }

  /// 执行保存请求
  Future<void> _saveRequest() async {
    if (!isChanged.value) {
      Get.back();
      return;
    }

    isLoading.value = true;
    SALoading.show();

    try {
      final success = await Api.createOrUpdateMask(
        name: nameController.text.trim(),
        age: ageController.text.trim(),
        gender: selectedGender.value?.code ?? Gender.unknown.code,
        description: descriptionController.text.trim(),
        otherInfo: otherInfoController.text.trim(),
        id: chatMask?.id,
      );

      await SA.login.fetchUserInfo();

      if (success) {
        final isEditChoosed = chatMask != null && chatMask?.id == msgCtr.state.session.profileId;
        if (isEditChoosed) {
          final id = chatMask?.id;
          if (id != null) {
            await msgCtr.changeMask(id);
          }
        }
        Get.back();
      } else {
        // ToastWidget.SAToast(LocaleKeys.some_error_try_again.tr);
        SAToast.show(SATextData.someErrorTryAgain);
      }
    } catch (e) {
      // ToastWidget.SAToast(LocaleKeys.some_error_try_again.tr);
      SAToast.show(SATextData.someErrorTryAgain);
    } finally {
      isLoading.value = false;
      SALoading.close();
    }
  }

  /// 是否为编辑模式
  bool get isEditMode => chatMask != null;

  /// 获取创建成本
  int get createCost => SA.login.configPrice?.profileChange ?? 5;

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
    nameController.dispose();
    ageController.dispose();
    descriptionController.dispose();
    otherInfoController.dispose();
    super.dispose();
  }
}
