import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';
import 'widgets.dart';

/// hello
class ItemListWidget extends GetView<SagemsController> {
  const ItemListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.list.isEmpty) {
        return Center(
          child: SizedBox(
            height: 200.w,
            child: Text(
              SATextData.noSubscriptionAvailable,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      }
      return ListView.builder(
        itemCount: controller.state.list.length,
        padding: EdgeInsets.zero,
        reverse: true,
        itemBuilder: (context, index) {
          final item = controller.state.list[index];
          final bestChoice = item.tag == 1;

          // 根据产品信息计算折扣百分比，从90%到0%以20%为步长递减
          // 使用算法计算：90 - (index * 20)，确保不小于0
          int discountPercent = math.max(0, 90 - (index * 20));

          String discount = controller.getDiscount(discountPercent);
          String numericPart = item.number.toString();
          String price = item.productDetails?.price ?? '--';

          List<Widget>? tags;
          if (bestChoice) {
            tags = [SAGemTagWidgets(tag: SATextData.bestChoice)];
          }
          return Obx(
            () => InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => controller.onTapChoose(item),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 24.w),
                    child: DecoratedBox(
                      decoration: controller.state.chooseProduct.value.sku == item.sku
                          ? BoxDecoration(
                              gradient: const LinearGradient(begin: Alignment(0, -0.5), end: Alignment(1, 0.5), colors: [SAAppColors.primaryColor, SAAppColors.yellowColor]),
                              borderRadius: BorderRadius.circular(16.r),
                            )
                          : BoxDecoration(),

                      child: Padding(
                        padding: EdgeInsets.all(4.w), // 边框厚度
                        child: Container(
                          width: Get.width,
                          padding: EdgeInsets.all(32.w),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/images/sa_20.png", width: 72.w, fit: BoxFit.contain),
                                  SizedBox(width: 16.w),
                                  Text(
                                    numericPart,
                                    style: TextStyle(fontFamily: "Montserrat", fontSize: 36.sp, fontWeight: FontWeight.w600, color: Colors.black, fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    discount,
                                    style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600, color: Color(0xFF222222)),
                                  ),
                                  SizedBox(height: 10.w),
                                  Text(
                                    price,
                                    style: TextStyle(fontFamily: "Montserrat", fontSize: 28.sp, fontWeight: FontWeight.w600, color: Color(0xff666666), fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (tags != null) ...tags,
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
