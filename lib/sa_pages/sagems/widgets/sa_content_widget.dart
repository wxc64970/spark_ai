import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';
import 'widgets.dart';

/// hello
class SAContentWidget extends GetView<SagemsController> {
  const SAContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 32.w, right: 32.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset("assets/images/sa_06.png", width: 48.w, fit: BoxFit.contain),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.help();
                      },
                      child: Image.asset("assets/images/sa_43.png", width: 48.w, fit: BoxFit.contain),
                    ),
                  ],
                ),
                SizedBox(height: 40.w),
                Text(
                  SA.storage.isSAB ? SATextData.openChatsUnlock : SATextData.buyGemsOpenChats,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.w),
                Expanded(child: ItemListWidget()),
                Text(
                  SATextData.oneTimePurchaseNote(controller.state.chooseProduct.value.productDetails?.price ?? '--'),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.w),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 32.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(color: const Color(0x1000001a), offset: const Offset(0, -2), blurRadius: 8, spreadRadius: 0),
            ],
            color: Colors.white,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 144.w),
                child: ButtonGradientWidget(
                  height: 88,
                  width: Get.width,
                  onTap: controller.onTapBuy,
                  child: Center(
                    child: Text(
                      SA.storage.isSAB ? SATextData.btnContinue : SATextData.buy,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 28.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.w),
              const PolicyWidget(type: SAPolicyBottomType.gems),
              SizedBox(height: Get.mediaQuery.padding.bottom + 16.w),
            ],
          ),
        ),
      ],
    );
  }
}
