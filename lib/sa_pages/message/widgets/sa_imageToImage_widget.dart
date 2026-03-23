import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/message/index.dart';

class ImageToImageWidget extends StatefulWidget {
  const ImageToImageWidget({super.key});

  @override
  State<ImageToImageWidget> createState() => _ImageToImageWidgetState();
}

class _ImageToImageWidgetState extends State<ImageToImageWidget> {
  List<StyleConfigItem?> imagesStyles = [];
  final MessageController ctr = Get.find<MessageController>();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    if (SA.login.imageToImage.isEmpty) {
      await SA.login.getStyleConfig();
    }
    setState(() {
      imagesStyles.assignAll(SA.login.imageToImage);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: imagesStyles.length + 1,
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10.w,
        crossAxisSpacing: 10.w,
        childAspectRatio: 164 / 218,
      ),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildCustomItem();
        }
        var item = imagesStyles[index - 1];
        return _buildItem(item);
      },
    );
  }

  Widget _buildCustomItem() {
    return Obx(
      () => GestureDetector(
        onTap: () {
          ctr.state.selectedStyle.value = 'ImageCustom';
          // 让输入框获得焦点并唤起键盘
          ctr.inputFocusNode.requestFocus();
          ctr.update();
        },
        child: Container(
          width: 164.w,
          height: 218.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/sa_92.png"),
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              width: 2.w,
              color: ctr.state.selectedStyle.value == 'ImageCustom'
                  ? SAAppColors.pinkColor
                  : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Center(
                  child: Text(
                    SATextData.custom,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(StyleConfigItem? item) {
    return GestureDetector(
      onTap: () async {
        int userCoins = SA.login.starCount.value;
        if (SA.login.priceConfig == null) {
          await SA.login.getPriceConfigs();
        }
        int price = SA.login.priceConfig!.i2i!;

        if (userCoins < price) {
          SASheetBottom.show(ConsumeFrom.creaimg);
          return;
        }
        setState(() {
          ctr.state.selectedStyle.value = item.name!;
        });
        ctr.sendMsgUndress(
          styleName: ctr.state.selectedStyle.value,
          genType: ctr.state.genType.value,
        );
        ctr.state.isUndress.value = false;
        ctr.state.selectedStyle.value = '';
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: SAImageWidget(url: item!.url!),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  width: 2.w,
                  color: ctr.state.selectedStyle.value == item.name!
                      ? SAAppColors.pinkColor
                      : Colors.transparent,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Center(
                      child: Text(
                        item.name!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
