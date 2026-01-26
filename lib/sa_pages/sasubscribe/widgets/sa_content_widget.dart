import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';
import 'sa_time_widget.dart';
import 'sa_vip_list.dart';

/// hello
class SaContentWidget extends GetView<SasubscribeController> {
  const SaContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          SA.storage.isSAB ? "assets/images/sa_65.png" : "assets/images/sa_45.png",
          width: Get.width,
          height: Get.height,
          fit: BoxFit.cover,
        ),
        Positioned.fill(child: Container(color: Colors.black45)),
        SizedBox(
          height: Get.height,
          width: Get.width,
          child: Padding(
            padding: EdgeInsets.only(left: 32.w, right: 32.w, top: Get.mediaQuery.padding.top + 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => controller.showBackButton.value
                          ? InkWell(
                              onTap: () => Get.back(),
                              child: Image.asset("assets/images/close.png", width: 48.w, fit: BoxFit.contain),
                            )
                          : const SizedBox(),
                    ),
                    GestureDetector(
                      onTap: () => SAPayUtils().restore(),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.w),
                        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(24.r)),
                        child: Text(
                          SATextData.restore,
                          style: TextStyle(fontSize: 28.sp, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.w),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SA.storage.isSAB ? SizedBox(height: 84.w) : SizedBox(height: 326.w),
                        if (SA.storage.isSAB) Image.asset("assets/images/sa_63.png", width: 556.w, fit: BoxFit.contain),
                        if (SA.storage.isSAB) SizedBox(height: 32.w),
                        Stack(
                          children: [
                            Image.asset(
                              SA.storage.isSAB ? "assets/images/sa_64.png" : "assets/images/sa_46.png",
                              width: Get.width,
                              fit: BoxFit.contain,
                            ),
                            Positioned.fill(
                              child: Container(
                                padding: EdgeInsets.only(left: 48.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 48.w),
                                    Text(
                                      SA.storage.isSAB ? SATextData.bestChatExperience : SATextData.vipUpgrade,
                                      style: TextStyle(
                                        fontSize: SA.storage.isSAB ? 24.sp : 40.sp,
                                        color: Color(0xffDF9A44),
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(height: 16.w),
                                    Obx(
                                      () => SARichTextPlaceholder(
                                        textKey: controller.contentText.value,
                                        placeholders: {
                                          'icon': WidgetSpan(
                                            alignment: PlaceholderAlignment.middle,
                                            child: Image.asset(
                                              'assets/images/sa_47.png',
                                              width: 32.w,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        },
                                        style: TextStyle(
                                          color: Color(0xff808080),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.w),
                        const SAVListWidget(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.w),
                if (SA.storage.isSAB) const TimerWidget(),
                if (!SA.storage.isSAB) _buildSubscriptionInfo(),
                SizedBox(height: 16.w),
                _buildPurchaseButton(),
                SizedBox(height: 16.w),
                PolicyWidget(type: SA.storage.isSAB ? SAPolicyBottomType.vip2 : SAPolicyBottomType.vip1),
                SizedBox(height: Get.mediaQuery.padding.bottom + 16.w),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 构建订阅信息（小版本）
  Widget _buildSubscriptionInfo() {
    return Container(
      constraints: const BoxConstraints(minHeight: 42),
      child: Obx(
        () => Center(
          child: Text(
            controller.subscriptionDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xffFFFFFF).withValues(alpha: 0.7),
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建购买按钮
  Widget _buildPurchaseButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 112.w),
      child: ButtonGradientWidget2(
        height: 88,
        width: Get.width,
        onTap: controller.purchaseSelectedProduct,
        gradientColors: const [Color(0xFFDF9A44), Color(0xFFFFF1B3)],
        child: Center(
          child: Text(
            SA.storage.isSAB ? SATextData.btnContinue : SATextData.subscribe,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 28.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
