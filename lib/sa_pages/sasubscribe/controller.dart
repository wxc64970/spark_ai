import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

class SasubscribeController extends GetxController {
  SasubscribeController();

  // 响应式状态变量
  final RxList<SASkModel> skuList = <SASkModel>[].obs;
  final Rx<SASkModel?> selectedProduct = Rx<SASkModel?>(null);
  final RxString contentText = ''.obs;
  final RxBool showBackButton = false.obs;
  final RxBool isLoading = false.obs;

  late VipFrom? vipFrom;
  final ScrollController scrollController = ScrollController();

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    // 获取传入参数
    vipFrom = Get.arguments ?? VipFrom.homevip;

    // 初始化数据
    _initializeData();
  }

  /// 初始化数据
  Future<void> _initializeData() async {
    _updateContentText();
    await _loadSubscriptionData();
    _logPageEvent();
    _setupBackButtonDisplay();
  }

  /// 加载订阅数据
  Future<void> _loadSubscriptionData() async {
    try {
      isLoading.value = true;

      await SAInfoUtils.getIdfa();
      SmartDialog.showLoading();

      await SAPayUtils().query();
      skuList.value = SAPayUtils().subscriptionList;

      // 选择默认商品
      selectedProduct.value = skuList.firstWhereOrNull((e) => e.defaultSku == true);
      _updateContentText();
    } catch (e) {
      debugPrint('加载订阅数据失败: $e');
    } finally {
      isLoading.value = false;
      SmartDialog.dismiss();
    }
  }

  /// 更新内容文本
  void _updateContentText() {
    if (SA.storage.isSAB) {
      final gems = selectedProduct.value?.number ?? 150;
      contentText.value = SATextData.vipGet2(gems.toString());
    } else {
      contentText.value = SATextData.vipGet;
    }
  }

  /// 记录页面事件
  void _logPageEvent() {
    SAlogEvent(SA.storage.isSAB ? 't_vipb' : 't_vipa');
  }

  /// 设置返回按钮显示
  void _setupBackButtonDisplay() {
    if (SA.storage.isSAB) {
      Future.delayed(const Duration(seconds: 3), () {
        showBackButton.value = true;
      });
    } else {
      showBackButton.value = true;
    }
  }

  /// 选择商品
  void selectProduct(SASkModel product) {
    if (selectedProduct.value?.sku == product.sku) return; // 避免重复选择
    selectedProduct.value = product;
    _updateContentText();

    // 使用防抖动滚动
    _debounceScrollToSelected();
  }

  // 防抖动滚动定时器
  Timer? _scrollTimer;

  void _debounceScrollToSelected() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer(const Duration(milliseconds: 100), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedItem();
      });
    });
  }

  /// 购买商品
  void purchaseSelectedProduct() {
    final product = selectedProduct.value;
    if (product == null) return;
    SAlogEvent(SA.storage.isSAB ? 'c_vipb_subs' : 'c_vipa_subs');
    SAPayUtils().buy(product, vipFrom: vipFrom);
  }

  /// 恢复购买
  void restorePurchases() {
    SAPayUtils().restore();
  }

  /// 获取价格信息
  String get currentPrice => selectedProduct.value?.productDetails?.price ?? '0.0';

  /// 获取单位信息
  String get currentUnit {
    final skuType = selectedProduct.value?.skuType;
    if (skuType == 2) return SATextData.month;
    if (skuType == 3) return SATextData.year;
    return '';
  }

  /// 获取订阅描述
  String get subscriptionDescription {
    final product = selectedProduct.value;
    if (product == null) return '';

    final price = currentPrice;
    final unit = currentUnit;
    final skuType = product.skuType;

    if (skuType == 4) {
      return SATextData.vipPriceLtDesc(price);
    } else {
      return SATextData.subscriptionInfo(price, unit);
    }
  }

  /// 无动画滚动到选中项
  void _scrollToSelectedItemWithoutAnimation() {
    final product = selectedProduct.value;
    if (product == null || !scrollController.hasClients) return;

    final index = skuList.indexWhere((element) => element.sku == product.sku);
    if (index == -1) return;

    _scrollToIndex(index, animated: false);
  }

  /// 滚动到选中项
  void _scrollToSelectedItem() {
    final product = selectedProduct.value;
    if (product == null || !scrollController.hasClients) return;

    final index = skuList.indexWhere((element) => element.sku == product.sku);
    if (index == -1) return;

    _scrollToIndex(index, animated: true);
  }

  /// 滚动到指定索引
  void _scrollToIndex(int index, {required bool animated}) {
    if (index == 0) {
      // 滚动到最左边
      if (animated) {
        scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else {
        scrollController.jumpTo(0);
      }
    } else if (index == skuList.length - 1) {
      // 滚动到最右边
      final maxScrollExtent = scrollController.position.maxScrollExtent;
      if (animated) {
        scrollController.animateTo(maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else {
        scrollController.jumpTo(maxScrollExtent);
      }
    } else {
      // 居中显示
      try {
        final screenWidth = Get.width;
        final itemWidth = (screenWidth - 32 - 40) / 2 + 8;
        final offset = index * itemWidth - (scrollController.position.viewportDimension - itemWidth) / 2;
        final clampedOffset = offset.clamp(0.0, scrollController.position.maxScrollExtent);

        if (animated) {
          scrollController.animateTo(clampedOffset, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        } else {
          scrollController.jumpTo(clampedOffset);
        }
      } catch (e) {
        debugPrint('滚动计算错误: $e');
      }
    }
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
    // 页面渲染完成后执行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedItemWithoutAnimation();
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
    super.dispose();
  }
}
