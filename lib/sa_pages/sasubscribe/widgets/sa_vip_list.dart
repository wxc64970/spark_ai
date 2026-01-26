import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';

/// hello
class SAVListWidget extends GetView<SasubscribeController> {
  const SAVListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final skuList = controller.skuList;

      if (skuList.isEmpty) {
        return _buildEmptyState();
      }

      return Column(mainAxisAlignment: MainAxisAlignment.start, children: [_buildSkuList(skuList)]);
    });
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: SizedBox(
        height: 100,
        child: Text(
          SATextData.noSubscriptionAvailable,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// 构建SKU列表
  Widget _buildSkuList(List<SASkModel> skuList) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      controller: controller.scrollController,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (_, index) {
        final sku = skuList[index];
        // final isBest = (sku.defaultSku ?? false) && SA.storage.isSAB;
        final isLifetime = sku.lifetime ?? false;
        final price = sku.productDetails?.price ?? '-';
        // final skuType = sku.skuType;
        // final tagMarginLeft = isBest ? 4.0 : 0.0;

        /// 获取SKU标题
        String getSkuTitle() {
          final skuType = sku.skuType;

          switch (skuType) {
            case 2:
              return SATextData.monthly;
            case 3:
              return SATextData.yearly;
            case 4:
              return SATextData.lifetime;
            default:
              return '';
          }
        }

        return Obx(() {
          final isSelected = controller.selectedProduct.value?.sku == sku.sku;
          return GestureDetector(
            onTap: () {
              controller.selectProduct(sku);
            },
            child: Container(
              width: Get.width,
              // margin: EdgeInsets.only(bottom: 16.w),
              padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 32.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  width: 2.w,
                  color: isSelected ? Color(0xffDF9A44) : Color(0xffFFFFFF).withValues(alpha: 0.15),
                ),
                color: isSelected
                    ? Color(0xffDF9A44).withValues(alpha: 0.4)
                    : Color(0xffFFFFFF).withValues(alpha: 0.15),
              ),
              child: SA.storage.isSAB
                  ? SAbWidget(price, isLifetime, sku, getSkuTitle())
                  : SAaWidget(getSkuTitle(), price),
            ),
          );
        });
      },
      separatorBuilder: (_, index) => const SizedBox(height: 8),
      itemCount: skuList.length,
    );
  }

  Widget SAaWidget(String getSkuTitle, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          getSkuTitle,
          style: TextStyle(fontSize: 32.sp, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            Text(
              price,
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 48.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget SAbWidget(String price, bool isLifetime, sku, getSkuTitle) {
    if (isLifetime) {
      return lifetimeContentWidget(price, sku, getSkuTitle);
    } else {
      return subscriptionContentWidget(price, sku, getSkuTitle);
    }
  }

  Widget lifetimeContentWidget(String price, sku, getSkuTitle) {
    String numFixed(dynamic nums, {int position = 2}) {
      double num = nums is double ? nums : double.parse(nums.toString());
      String numString = num.toStringAsFixed(position);

      return numString.endsWith('.0') ? numString.substring(0, numString.lastIndexOf('.')) : numString;
    }

    final rawPrice = sku.productDetails?.rawPrice ?? 0;
    final symbol = sku.productDetails?.currencySymbol ?? '';
    final originalPrice = '$symbol${numFixed(rawPrice * 6, position: 2)}';
    final title = getSkuTitle;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 32.sp, color: Colors.white, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.w),
            Text(
              originalPrice,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 22.sp,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.white,
                decorationThickness: 3.w,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset("assets/images/sa_20.png", width: 40.w, fit: BoxFit.contain),
                SizedBox(width: 8.w),
                Text(
                  '+${sku.number}',
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 32.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            Text(
              price,
              style: TextStyle(fontSize: 24.sp, color: Colors.white, fontWeight: FontWeight.w600),
            ),

            //  SizedBox(width: 2),
          ],
        ),
      ],
    );
  }

  Widget subscriptionContentWidget(String price, sku, getSkuTitle) {
    String numFixed(dynamic nums, {int position = 2}) {
      double num = nums is double ? nums : double.parse(nums.toString());
      String numString = num.toStringAsFixed(position);

      return numString.endsWith('.0') ? numString.substring(0, numString.lastIndexOf('.')) : numString;
    }

    final rawPrice = sku.productDetails?.rawPrice ?? 0;
    final symbol = sku.productDetails?.currencySymbol ?? '';
    final title = getSkuTitle;

    String originalPrice;
    if (sku.skuType == 2) {
      final weekPrice = numFixed(rawPrice / 4, position: 2);
      originalPrice = '$symbol$weekPrice';
    } else {
      final weekPrice = numFixed(rawPrice / 48, position: 2);
      originalPrice = '$symbol$weekPrice';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Column(
          spacing: 4.w,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  price,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.white,
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '/${SATextData.week}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Text(
              originalPrice,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
