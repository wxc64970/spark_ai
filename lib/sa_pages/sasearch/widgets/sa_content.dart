import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';

/// hello
class SaContentWidget extends GetView<SasearchController> {
  const SaContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset("assets/images/sa_06.png", width: 48.w, fit: BoxFit.contain),
              ),
              SizedBox(width: 32.w),
              Expanded(
                child: Container(
                  height: 80.w,
                  width: double.infinity,
                  margin: const EdgeInsetsDirectional.only(end: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(144.r),
                    border: Border.all(color: const Color(0xFFFFFFFF), width: 2.w),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x61c5e7b3), // #c5e7b361 → 0x61(透明度) + c5e7b3(颜色)
                        offset: Offset(0, 8), // 0 8px（x=0，y=8）
                        blurRadius: 8, // 8px 模糊半径
                        spreadRadius: 0, // 0 扩散半径（对应 CSS 的第4个值）
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ButtonWidget(
                        width: 40.w,
                        height: 40.w,
                        color: Colors.transparent,
                        onTap: () {
                          controller.state.searchQuery.value = controller.textController.text;
                        },
                        child: Center(
                          child: Image.asset('assets/images/sa_05.png', width: 40.w, fit: BoxFit.contain),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: TextField(
                            onChanged: (query) {
                              // 更新 searchQuer
                              if (controller.state.searchQuery.value == query.trim()) return;
                              controller.state.searchQuery.value = query;
                            },
                            autofocus: false,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {},
                            cursorColor: const Color(0xFF6E4EDB),
                            minLines: 1,
                            maxLength: 20,
                            style: TextStyle(height: 1, color: Colors.black, fontSize: 28.sp, fontWeight: FontWeight.w500),
                            controller: controller.textController,
                            enableInteractiveSelection: true, // 确保文本选择功能启用
                            dragStartBehavior: DragStartBehavior.down, // 优化拖拽行为
                            decoration: InputDecoration(
                              // hintText: L10nHelper.current.searchSirens,
                              counterText: '', // 去掉字数显示
                              hintStyle: const TextStyle(color: Color(0xFFD9D9D9)),
                              fillColor: Colors.transparent,
                              hintText: SATextData.seach,
                              border: InputBorder.none,
                              filled: true,
                              isDense: true,
                            ),
                            focusNode: controller.focusNode,
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
          Expanded(
            child: Obx(() {
              final list = controller.state.list;
              final type = controller.state.type.value;

              if (type != null) {
                return GestureDetector(
                  child: EmptyWidget(type: type),
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                );
              }

              return SafeArea(top: false, child: _buildList(list));
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<ChaterModel> list) {
    return ListView.builder(
      controller: controller.scrollController,
      itemCount: list.length,
      padding: EdgeInsets.zero,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final data = list[index];
        return InkWell(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            RoutePages.pushChat(data.id);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 24.w),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: const Alignment(0, -0.5), end: const Alignment(1, 0.5), colors: [SAAppColors.primaryColor, SAAppColors.yellowColor]),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: data.vip == true ? EdgeInsets.all(4.w) : EdgeInsets.zero,
                // 边框厚度
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                  child: Container(
                    width: Get.width,
                    height: 240.w,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: data.vip == true ? SAAppColors.primaryColor.withValues(alpha: 0.13) : Colors.white),
                    padding: EdgeInsets.all(24.w),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            SAImageWidget(url: data.avatar, width: 160.w, height: 192.w, cacheWidth: 1080, cacheHeight: 1080, borderRadius: BorderRadius.circular(24.r), shape: BoxShape.rectangle),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 12.w,
                              child: InkWell(
                                onTap: () {
                                  controller.onCollect(index, data);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 4.w, // 水平模糊度（对应 blur 10px）
                                      sigmaY: 4.w, // 垂直模糊度（对应 blur 10px）
                                    ),
                                    // 关键2：实现 box-shadow + 背景半透（需嵌套 Container）
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 7.w, horizontal: 12.w),
                                          decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(8.r)),
                                          child: Row(
                                            children: [
                                              Image.asset(data.collect! ? "assets/images/sa_04.png" : "assets/images/sa_03.png", width: 24.w, fit: BoxFit.contain),
                                              SizedBox(width: 4.w),
                                              Text(
                                                data.likes.toString(),
                                                style: TextStyle(fontSize: 20.sp, color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(maxWidth: 290.w),
                                      child: Text(
                                        data.name ?? "",
                                        style: TextStyle(fontSize: 32.sp, color: Color(0xff222222), fontWeight: FontWeight.w500),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    data.age == null
                                        ? const SizedBox()
                                        : Container(
                                            constraints: BoxConstraints(maxWidth: 70.w),
                                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(40.r),
                                              gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [SAAppColors.primaryColor, SAAppColors.yellowColor]),
                                            ),
                                            child: Text(
                                              '${data.age}',
                                              style: TextStyle(fontSize: 18.sp, color: Color(0xff000000), fontWeight: FontWeight.w600),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                  ],
                                ),
                                SizedBox(height: 8.w),
                                Text(
                                  data.aboutMe ?? "",
                                  style: TextStyle(fontSize: 28.sp, color: Color(0xff4D4D4D)),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
