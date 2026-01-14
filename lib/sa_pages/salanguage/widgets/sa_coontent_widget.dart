import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../index.dart';
import 'widgets.dart';

/// hello
class SAContentWidget extends GetView<SalanguageController> {
  const SAContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appBar(),
        SizedBox(height: 24.w),
        Obx(
          () => Expanded(
            child: controller.emptyType.value != null
                ? EmptyWidget(type: controller.emptyType.value!)
                : Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 686.w,
                            height: 134.w,
                            margin: EdgeInsets.only(left: 32.w),
                            padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 32.w),
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage('assets/images/sa_52.png'), fit: BoxFit.contain),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 28.sp, color: Color(0xff4D4D4D), fontWeight: FontWeight.w400),
                                  TextSpan(
                                    style: TextStyle(fontSize: 28.sp, color: Color(0xff1A1A1A), fontWeight: FontWeight.w400),
                                    children: [
                                      TextSpan(text: '${SATextData.ai_language} '),
                                      TextSpan(
                                        text: controller.choosedName.value,
                                        style: TextStyle(fontSize: 28.sp, fontFamily: "Montserrat", fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  SATextData.clickSaveToConfirm,
                                  style: TextStyle(fontSize: 22.sp, color: Color(0xff1A1A1A), fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 32.w),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 32.w),
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
                              ),
                              // padding: EdgeInsets.all(32.w),
                              child: SliverViewObserver(
                                controller: controller.observerController,
                                sliverContexts: () {
                                  return controller.sliverContextMap.values.toList();
                                },
                                child: CustomScrollView(
                                  key: ValueKey(controller.isShowListMode),
                                  controller: controller.scrollController,
                                  slivers: [
                                    ...controller.contactList.asMap().entries.map((entry) {
                                      final i = entry.key;
                                      final e = entry.value;
                                      return _buildSliver(index: i, model: e);
                                    }),
                                    SliverToBoxAdapter(child: Container(height: 140)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 32.w, horizontal: 144.w),
                          color: Colors.white,
                          child: Column(
                            children: [
                              ButtonGradientWidget(
                                onTap: controller.onSaveButtonTapped,
                                height: 88,
                                borderRadius: BorderRadius.circular(100.r),
                                child: Center(
                                  child: Text(
                                    SATextData.save,
                                    style: TextStyle(fontFamily: "Montserrat", color: Colors.black, fontSize: 28.sp, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              SizedBox(height: Get.mediaQuery.padding.bottom),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliver({required int index, required SAAzListContactModel model}) {
    final names = model.names;
    if (names.isEmpty) return const SliverToBoxAdapter();
    Widget resultWidget = SliverList(
      delegate: SliverChildBuilderDelegate((context, itemIndex) {
        if (controller.sliverContextMap[index] == null) {
          controller.sliverContextMap[index] = context;
        }
        return Obx(
          () => SAAzListItemV(
            name: names[itemIndex],
            isChoosed: names[itemIndex] == controller.choosedName.value,
            onTap: () {
              debugPrint('click  - ${model.section} - ${names[itemIndex]}');
              controller.choosedName.value = names[itemIndex];
              // 保存选中的语言对象
              if (model.langs != null && itemIndex < model.langs!.length) {
                controller.selectedLang = model.langs![itemIndex];
                debugPrint('Selected lang: ${controller.selectedLang?.label} - ${controller.selectedLang?.value}');
              }
            },
          ),
        );
      }, childCount: names.length),
    );
    resultWidget = SliverStickyHeader(
      header: Container(
        decoration: BoxDecoration(
          color: Color(0xffF4F7F0),
          // borderRadius: BorderRadius.only(topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.w),
        child: Text(
          model.section,
          style: TextStyle(color: Color(0xff222222), fontSize: 28.sp, fontWeight: FontWeight.w600),
        ),
      ),
      sliver: resultWidget,
    );
    return resultWidget;
  }

  Widget appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 32.w, right: 32.w),
      child: Stack(
        children: [
          SizedBox(
            height: 64.w,
            child: Center(
              child: Text(
                SATextData.language,
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
