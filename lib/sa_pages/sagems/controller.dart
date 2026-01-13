import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';

class SagemsController extends GetxController {
  SagemsController();

  final state = SagemsState();

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    SAInfoUtils.getIdfa();

    _loadData();

    if (Get.arguments != null && Get.arguments is ConsumeFrom) {
      state.from = Get.arguments;
    }

    SAlogEvent('t_paygems');
  }

  Future<void> _loadData() async {
    SALoading.show();
    await SAPayUtils().query();
    SALoading.close();

    state.list.addAll(SAPayUtils().consumableList);
    state.chooseProduct.value = state.list.firstWhereOrNull((e) => e.defaultSku == true)!;
    update();
  }

  Future onTapBuy() async {
    SAlogEvent('c_paygems');
    SAPayUtils().buy(state.chooseProduct.value, consFrom: state.from);
  }

  help() {
    final str = SA.storage.isSAB ? SATextData.textMessageCost : SATextData.textMessageCallCost;
    final processedStr = str.replaceAll('\\n', '\n');
    List<String> strList = processedStr.split('\n');
    SmartDialog.show(
      tag: "help_dialog",
      builder: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 55.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      SmartDialog.dismiss(tag: "help_dialog");
                    },
                    child: Image.asset("assets/images/close.png", width: 48.w, fit: BoxFit.contain),
                  ),
                  Expanded(child: SizedBox.shrink()),
                ],
              ),
              SizedBox(height: 32.w),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: AlignmentGeometry.topCenter, end: AlignmentGeometry.bottomCenter, colors: [Color(0xffEBFFCC), Color(0xffFFFFFF), Color(0xffFFFFFF)]),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: strList.length,
                      itemBuilder: (context, index) {
                        String title = strList[index];
                        return Container(
                          width: Get.width,
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Row(
                            children: [
                              Image.asset("assets/images/sa_20.png", width: 48.w, fit: BoxFit.contain),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(color: const Color(0xFF222222), fontSize: 24.sp, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 40.w);
                      },
                    ),
                    SizedBox(height: 60.w),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    // Get.bottomSheet(
    // );
  }

  onTapChoose(item) {
    state.chooseProduct.value = item;
    update();
  }

  // 根据折扣百分比获取对应的本地化字符串
  String getDiscount(int discountPercent) {
    try {
      return SATextData.saveNum(discountPercent.toString());
    } catch (e) {
      return 'Save $discountPercent%';
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
