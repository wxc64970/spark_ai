import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/saCommon/sa_models/sa_ai_avatar_options.dart';
import 'package:spark_ai/sa_pages/saChat/widgets/sa_k_a_widget.dart';

import 'index.dart';
import 'widgets/sa_body_widget.dart';

class SaaigenerateimageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  SaaigenerateimageController();

  final state = SaaigenerateimageState();

  final List<String> tabs = [
    SATextData.keyGeneration,
    SATextData.textToPicture,
  ];
  List<Widget> tabData = [];
  List<ImageStyle> imageStyleList = [];
  RxList<ImageStyle> imageStyleData = <ImageStyle>[].obs;
  Rx<ImageStyle> selectImageStyleData = ImageStyle().obs;

  late TabController tabController;

  final currentIndex = 0.obs;

  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController descriptionController;

  late FocusNode ageFocusNode;
  late FocusNode heightFocusNode;

  // 免费次数和钻石
  int _freeTimesLeft = 3;
  int get freeTimesLeft => _freeTimesLeft;
  int get userDiamonds => SA.login.gemBalance.value;

  // More details 选项数据 - 现在使用 AiAvatarOptions
  List<AiAvatarOptions> _detailOptions = [];
  List<AiAvatarOptions> get detailOptions => _detailOptions;

  // 必填项列表 - 存储完整的 AiAvatarOptions 对象
  final List<AiAvatarOptions> _requiredFields = [];
  List<AiAvatarOptions> get requiredFields => _requiredFields;

  /// 选择性别
  void selectGender(Gender gender) {
    state.selectedGender.value = gender;
  }

  /// 选择
  void handleSelectStyleImages(ImageStyle data) {
    selectImageStyleData.value = data;
  }

  /// imageStyle 风格切换
  void selectImageStyleTab(String type) {
    state.imageStyleTabs = type;
    imageStyleData.clear();
    if (type == SATextData.real) {
      imageStyleData.value = imageStyleList
          .where((item) => item.styleType == 0)
          .toList();
      // if (selectImageStyleData.value.id == null) {
      //   selectImageStyleData.value = imageStyleData.first;
      // } else {
      //   var index = imageStyleData.indexWhere(
      //     (item) => item.id == selectImageStyleData.value.id,
      //   );
      //   if (index == -1) {
      //     selectImageStyleData.value = imageStyleData.first;
      //   }
      // }
      selectImageStyleData.value = imageStyleData.first;
    } else {
      imageStyleData.value = imageStyleList
          .where((item) => item.styleType == 1)
          .toList();
      // if (selectImageStyleData.value.id == null) {
      //   selectImageStyleData.value = imageStyleData.first;
      // } else {
      //   var index = imageStyleData.indexWhere(
      //     (item) => item.id == selectImageStyleData.value.id,
      //   );
      //   if (index == -1) {
      //     selectImageStyleData.value = imageStyleData.first;
      //   }
      // }
      selectImageStyleData.value = imageStyleData.first;
    }
  }

  _initData() async {
    SALoading.show();
    await Future.wait([
      SA.login.fetchUserInfo(),
      loadImageStyles(),
      loadOptions(),
      // loadUserAssets(),
    ]);
    SALoading.close();
  }

  Future<void> loadImageStyles() async {
    List<ImageStyle>? styles = await ImageAPI.getImageStyle();
    imageStyleList = styles ?? [];
    selectImageStyleTab(SATextData.real);

    // if (styles != null) {
    //   for (var style in styles) {
    //     if (style.styleType == 0) {
    //       realStyles.add(style);
    //     } else if (style.styleType == 1) {
    //       fantasyStyles.add(style);
    //     }
    //   }
    // }
  }

  // Future<void> loadUserAssets() async {
  //   final userAssets = await ImageAPI.getUserAsset();
  //   _freeTimesLeft = userAssets?.createImgNum ?? 0;
  //   update();
  // }

  Future<bool> loadOptions() async {
    List<AiAvatarOptions>? options = await ImageAPI.getDetailOptions();
    if (options != null) {
      _detailOptions = options;

      // 更新必填项列表 - 存储完整对象
      _requiredFields.clear();
      _requiredFields.addAll(
        options.where((option) => option.required == true),
      );
      update();
      return true;
    } else {
      return false;
    }
  }

  // 切换详情选择 - 单选模式：同一分类下只能选中一个标签
  void toggleDetailSelection(String category, String tagId) {
    // 找到对应的选项分类
    final option = _detailOptions.firstWhere(
      (opt) => opt.name == category,
      orElse: () => AiAvatarOptions(),
    );

    if (option.tags == null) return;

    // 找到对应的标签
    final tag = option.tags!.firstWhere(
      (t) => t.id == tagId,
      orElse: () => AiAvatarTag(),
    );

    if (tag.id == null) return;

    // 单选逻辑：如果点击已选中的标签，则取消选中
    if (tag.isSelected) {
      tag.isSelected = false;
    } else {
      // 如果点击未选中的标签，先取消该分类下所有标签的选中状态
      for (var t in option.tags!) {
        t.isSelected = false;
      }
      // 然后选中当前标签
      tag.isSelected = true;
    }
    canCreateImage;

    update();
  }

  // 创建图片
  void createImage() async {
    // Get.toNamed(SARouteNames.aiGenerateLoading);
    // return;
    // if (selectImageStyleData.value.id == null) {
    //   SAToast.show('Please select an image style.');
    //   return;
    // }

    // if (!canCreateImage && currentIndex.value == 0) {
    //   SAToast.show('Please fill in all required fields.');
    //   return;
    // }

    SALoading.show();

    await SA.login.fetchUserInfo();

    // 检查免费次数和钻石
    if (SA.login.imgCreationCount.value <= 0) {
      // if (userDiamonds < (SA.login.configPrice?.imgAvatarPrice ?? 50)) {
      //   SALoading.close();
      //   Get.toNamed(SARouteNames.gems, arguments: ConsumeFrom.generateimage);
      //   return;
      // }
      SALoading.close();
      Get.toNamed(SARouteNames.countSku, arguments: ConsumeFrom.aiphoto);
      return;
    }

    // 组装完整的API参数
    Map<String, dynamic> params = {
      "age": ageController.text.trim(),
      "height": heightController.text.trim(),
      "gender": state.selectedGender.value?.stringValue,
      "style_id": selectImageStyleData.value.id!,
      "nsfw": state.nsfw,
    };

    // 如果是 Text to Picture 模式，
    if (currentIndex.value == 1 &&
        descriptionController.text.trim().isNotEmpty) {
      params["describe_img"] = descriptionController.text.trim();
    }
    if (currentIndex.value == 0) {
      // 组装 more_details 参数
      List<Map<String, dynamic>> moreDetails = [];
      for (var option in _detailOptions) {
        if (option.tags != null && option.id != null) {
          // 收集该选项下所有选中的标签
          List<Map<String, dynamic>> selectedTags = [];
          for (var tag in option.tags!) {
            if (tag.isSelected && tag.id != null) {
              selectedTags.add({"id": tag.id});
            }
          }

          // 如果该选项下有选中的标签，则添加到 more_details 中
          if (selectedTags.isNotEmpty) {
            moreDetails.add({"id": option.id!, "tags": selectedTags});
          }
        }
      }
      if (moreDetails.isNotEmpty) {
        params["more_details"] = moreDetails;
      }
    }

    SAlogEvent(
      't2i_create_click',
      parameters: {'method': currentIndex.value == 0 ? 'key' : 'prompt'},
    );

    _generateImage(params);
  }

  // 调用API生成图片
  void _generateImage(Map<String, dynamic> params) async {
    try {
      final result = await ImageAPI.avatarAiGenerate(params);
      // loadUserAssets();
      SALoading.close();
      if (result != null) {
        Get.toNamed(SARouteNames.aiGenerateLoading, arguments: result);
      } else {
        SAToast.show(SATextData.failedGenerate);
      }
    } catch (e) {
      SALoading.close();
      SAToast.show(SATextData.errorGenerate);
    }
  }

  // 检查是否可以创建图片
  bool get canCreateImage {
    state.isClick = _isFormValid();
    return state.isClick;
  }

  // 使用AI写作
  void useAIWrite() async {
    SALoading.show();
    await SA.login.fetchUserInfo();
    if (userDiamonds < (SA.login.configPrice?.imgAvatarPrice ?? 40)) {
      SALoading.close();
      Get.toNamed(SARouteNames.gems, arguments: ConsumeFrom.imageAIwrite);
      return;
    }

    // 收集参数 - 获取当前状态的值
    var params = {
      "age": int.tryParse(ageController.text.trim()) ?? 18,
      "height": heightController.text.trim(),
      "gender": state.selectedGender.value?.code,
      "style_id": selectImageStyleData.value.id ?? 0,
      "nsfw": state.nsfw,
    };

    SAlogEvent('t2i_prompt_aiwrite_click');

    final result = await ImageAPI.avatarAiWriteWords(params);
    if (result == null) {
      SALoading.close();
      SAToast.show('Failed to generate text. Please try again later.');
      return;
    }
    descriptionController.text = result;
    SALoading.close();
    update();
  }

  // 表单验证
  bool _isFormValid() {
    // 检查年龄和身高
    final ageInt = int.tryParse(ageController.text.trim());
    final heightDouble = double.tryParse(heightController.text.trim());

    if (ageInt == null || ageInt < 18 || ageInt > 999) return false;
    if (heightDouble == null || heightDouble < 10 || heightDouble > 999) {
      return false;
    }

    // Keyword Generation 模式需要检查必填项
    if (currentIndex.value == 0) {
      for (AiAvatarOptions field in _requiredFields) {
        // 检查该必填分类下是否至少选中了一个标签
        final hasSelectedTag =
            field.tags?.any((tag) => tag.isSelected) ?? false;
        if (!hasSelectedTag) {
          return false;
        }
      }
    }
    return true;
  }

  void hanldeSku(ConsumeFrom from) {
    Get.toNamed(SARouteNames.countSku, arguments: from);
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    _initData();
    heightController = TextEditingController(text: '165');
    ageController = TextEditingController(text: '18');
    descriptionController = TextEditingController();

    ageFocusNode = FocusNode();
    heightFocusNode = FocusNode();
    // 年龄失去焦点时验证 18-999
    ageFocusNode.addListener(() {
      if (!ageFocusNode.hasFocus) {
        final value = int.tryParse(ageController.text);
        if (value == null || value < 18 || value > 999) {
          SAToast.show(SATextData.ageMust);
          if (value! < 18) {
            ageController.text = '18';
          }
          if (value > 999) {
            ageController.text = '999';
          }
        }
      }
    });

    // 身高失去焦点时验证 10-999
    heightFocusNode.addListener(() {
      if (!heightFocusNode.hasFocus) {
        final value = int.tryParse(heightController.text);
        if (value == null || value < 10 || value > 999) {
          SAToast.show(SATextData.heightMust);
          if (value! < 10) {
            heightController.text = '10';
          }
          if (value > 999) {
            heightController.text = '999';
          }
        }
      }
    });

    tabController = TabController(length: tabs.length, vsync: this);
    SAlogEvent('t2i_keyword_show');
    tabController.addListener(() {
      // 避免重复触发（Tab 切换动画过程中索引会变化）
      if (tabController.indexIsChanging) return;
      currentIndex.value = tabController.index;
      SAlogEvent(
        currentIndex.value == 0 ? 't2i_keyword_show' : 't2i_prompt_show',
      );
      canCreateImage;
    });
    // 初始化数据
    tabData = [
      KeepAliveWrapper(child: SABodyWidget()),
      KeepAliveWrapper(child: SABodyWidget()),
    ];
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
    heightController.dispose();
    ageController.dispose();
    descriptionController.dispose();
    ageFocusNode.dispose();
    heightFocusNode.dispose();
    super.dispose();
  }
}
