import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';

class SatexttoimageController extends GetxController {
  SatexttoimageController();

  final state = SatexttoimageState();

  late TextEditingController descriptionController;
  final RxInt descriptionLength = 0.obs;
  final int maxDescriptionLength = 500;
  int stepIndex = 0;
  final List<int> incrementSteps = const [1, 2, 4, 6];

  _initData() async {
    SALoading.show();
    SA.login.fetchUserInfo();
    if (SA.login.textToImage.isEmpty) {
      await SA.login.getStyleConfig();
    }
    state.styleName = SA.login.textToImage.first?.name;
    state.styleImage = SA.login.textToImage.first?.url;
    state.defaultDescription = state.styleName == "Fantasy"
        ? SATextData.fantasyDescription
        : SATextData.realDescription;
    SALoading.close();
  }

  void handleAIWrite() async {
    SALoading.show();
    await SA.login.fetchUserInfo();
    // 检查免费次数和钻石
    if (SA.login.starCount.value < 2) {
      SALoading.close();
      SASheetBottom.show(ConsumeFrom.aiphoto);
      return;
    }

    SAlogEvent('t2i_aiwtite_click');
    try {
      var res = await getAIWriteData();
      if (res != null) {
        descriptionController.text = res;
      } else {
        SAToast.show("AI write failed");
      }
    } catch (e) {
    } finally {
      SALoading.close();
    }
  }

  Future<String?> getAIWriteData() async {
    SALoading.show();
    try {
      var res = await Api.getAIWrite();
      return res;
    } catch (e) {
      return null;
    } finally {
      SALoading.close();
    }
  }

  void handleNumberOfImages(type) {
    if (type == 1) {
      if (stepIndex == incrementSteps.length - 1) return;
      stepIndex++;
      state.numberOfImages = incrementSteps[stepIndex];
    } else {
      if (stepIndex == 0) return;
      stepIndex--;
      state.numberOfImages = incrementSteps[stepIndex];
    }
    SAlogEvent(
      't2i_generate_click',
      parameters: {'number': state.numberOfImages},
    );
    switch (state.numberOfImages) {
      case 1:
        state.coins = "10";
        break;
      case 2:
        state.coins = "18";
        break;
      case 4:
        state.coins = "35";
        break;
      case 6:
        state.coins = "50";
        break;
      default:
        break;
    }
  }

  void clearDescription() {
    descriptionController.clear();
  }

  void selectImageStyle(String styleName) {
    SAlogEvent('t2i_generate_click', parameters: {'sytle': styleName});
    state.styleName = styleName;
    state.styleImage = SA.login.textToImage
        .firstWhere((element) => element?.name == styleName)
        ?.url;
    state.defaultDescription = state.styleName == "Fantasy"
        ? SATextData.fantasyDescription
        : SATextData.realDescription;
  }

  void handleHistory() {
    Get.toNamed(SARouteNames.aiGenerateHistory);
  }

  void createImage() async {
    SALoading.show();

    await SA.login.fetchUserInfo();

    // 检查免费次数和钻石
    if (SA.login.starCount.value < int.parse(state.coins)) {
      SALoading.close();
      // Get.toNamed(SARouteNames.countSku, arguments: ConsumeFrom.aiphoto);
      SASheetBottom.show(ConsumeFrom.aiphoto);
      return;
    }

    // 组装完整的API参数
    Map<String, dynamic> params = {
      "style_name": state.styleName,
      "prompt": descriptionController.text.trim().isEmpty
          ? state.defaultDescription
          : descriptionController.text.trim(),
      "img_count": state.numberOfImages,
      "image_ratio": state.selectImageRatio,
    };

    // SAlogEvent(
    //   't2i_create_click',
    //   parameters: {'method': currentIndex.value == 0 ? 'key' : 'prompt'},
    // );

    _generateImage(params);
  }

  void _generateImage(Map<String, dynamic> params) async {
    try {
      final result = await Api.avatarAiGenerateStar(params);
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

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    SAlogEvent('t2i_show');
    descriptionController = TextEditingController();
    descriptionController.addListener(() {
      descriptionLength.value = descriptionController.text.length;
    });
    _initData();
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
    descriptionController.dispose();
    super.dispose();
  }
}
