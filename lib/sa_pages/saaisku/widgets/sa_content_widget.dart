import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/sagems/widgets/sa_tag_widget.dart';

import '../index.dart';

/// hello
class SAContentWidget extends GetView<SaaiskuController> {
  const SAContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appBar(),
        SizedBox(height: 24.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.w),
              Obx(
                () => Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    itemCount: controller.aiSkuList.length,
                    itemBuilder: (_, index) {
                      final model = controller.aiSkuList[index];
                      var count = 1;
                      var countUni = '';
                      var uniPart = '';

                      if (controller.from == ConsumeFrom.aiphoto) {
                        count = model.createImg ?? 1;
                        // countUni = SATextData.ai_photos.toUpperCase();
                        countUni = SATextData.ai_photos;
                        uniPart = SATextData.ai_photo_label;
                      } else if (controller.from == ConsumeFrom.img2v) {
                        count = model.createVideo ?? 1;
                        // countUni = SATextData.ai_videos.toUpperCase();
                        countUni = SATextData.ai_videos;
                        uniPart = SATextData.ai_video_label;
                      }

                      var rawPrice = model.productDetails?.rawPrice ?? 0;
                      var oneRawPrice = rawPrice / count;
                      double truncated = (oneRawPrice * 100).truncateToDouble() / 100;
                      String formattedNumber = truncated.toStringAsFixed(2);
                      var onePrice = '${model.productDetails?.currencySymbol}$formattedNumber/$uniPart';

                      List<Widget>? tags;
                      if (model.tag == 1) {
                        tags = [SAGemTagWidgets(tag: SATextData.bestChoice)];
                      }
                      if (model.tag == 2) {
                        tags = [SAGemTagWidgets(tag: SATextData.ai_most_popular)];
                      }
                      return Obx(
                        () => InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            controller.selectedModel.value = model;
                            controller.buy();
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 24.w),
                                child: DecoratedBox(
                                  decoration: controller.selectedModel.value == model
                                      ? BoxDecoration(
                                          gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [SAAppColors.primaryColor, SAAppColors.yellowColor]),
                                          borderRadius: BorderRadius.circular(16.r),
                                        )
                                      : BoxDecoration(),
                                  child: Padding(
                                    padding: EdgeInsets.all(4.w), // 边框厚度
                                    child: Container(
                                      padding: EdgeInsets.all(32.w),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: Colors.white),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            spacing: 4.w,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                spacing: 6.w,
                                                children: [
                                                  Text(
                                                    count.toString(),
                                                    style: TextStyle(fontFamily: "Montserrat", fontSize: 36.sp, fontWeight: FontWeight.w600, color: Colors.black, fontStyle: FontStyle.italic),
                                                  ),
                                                  Text(
                                                    countUni,
                                                    style: TextStyle(fontFamily: "Montserrat", fontSize: 36.sp, fontWeight: FontWeight.w600, color: Colors.black, fontStyle: FontStyle.italic),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                spacing: 8.w,
                                                children: [
                                                  Text(
                                                    'Bonus:${model.number ?? 0}',
                                                    style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600, color: Colors.black),
                                                  ),
                                                  Image.asset("assets/images/sa_20.png", width: 40.w, fit: BoxFit.contain),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            spacing: 10.w,
                                            children: [
                                              Text(
                                                onePrice,
                                                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600, color: Color(0xFF222222)),
                                              ),
                                              Text(
                                                model.productDetails?.price ?? '--',
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
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30.w),
        Container(
          padding: EdgeInsets.only(top: 40.w, bottom: Get.mediaQuery.padding.bottom + 20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
            boxShadow: [BoxShadow(color: const Color(0x1000001a), offset: const Offset(0, -2), blurRadius: 8, spreadRadius: 0)],
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 144.w),
            child: ButtonGradientWidget(
              height: 88,
              onTap: controller.buy,
              child: Center(
                child: Text(
                  SATextData.btnContinue,
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 28.sp, fontWeight: FontWeight.w600, color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 32.w, right: 32.w),
      child: Stack(
        children: [
          SizedBox(
            height: 48.w,
            child: Center(
              child: Text(
                SATextData.ai_purchase_balance,
                style: TextStyle(fontSize: 32.sp, color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Image.asset("assets/images/sa_06.png", width: 48.w, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}
