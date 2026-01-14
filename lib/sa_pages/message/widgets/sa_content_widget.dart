import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';
import 'widgets.dart';

/// hello
class SAContentWidget extends GetView<MessageController> {
  const SAContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            Positioned.fill(child: SAImageWidget(url: controller.state.session.background ?? controller.state.role.avatar)),
            Positioned.fill(
              child: Container(width: Get.width, height: Get.height, color: Colors.black.withValues(alpha: 0.3)),
            ),
            if (SA.storage.chatBgImagePath.isNotEmpty) Positioned.fill(child: Image.file(File(SA.storage.chatBgImagePath), fit: BoxFit.cover)),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(left: 32.w, right: 32.w, top: Get.mediaQuery.padding.top + 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed(SARouteNames.profile, arguments: controller.state.role);
                          },
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 300.w),
                              child: Text(
                                controller.state.role.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w500, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Get.back(),
                              child: Image.asset("assets/images/sa_21.png", width: 48.w, fit: BoxFit.contain),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    DialogWidget.showChatLevel();
                                  },
                                  child: Container(
                                    width: 48.w,
                                    height: 48.w,
                                    // margin: EdgeInsets.only(left: 24.w),
                                    decoration: BoxDecoration(color: Color(0xff999999).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(100.r)),
                                    child: Center(
                                      child: Obx(() {
                                        var data = controller.state.chatLevel.value;
                                        var level = data?.level ?? 1;
                                        final map = controller.state.chatLevelConfigs.firstWhereOrNull((element) => element['level'] == level);
                                        var levelStr = map?['icon'] as String?;
                                        return Text(levelStr ?? '👋', style: const TextStyle(fontSize: 17));
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: SAMsgListWidget()),
                          SAInpBar(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: kToolbarHeight,
              child: SafeArea(child: Column(children: [const SALelWidget()])),
            ),
            Obx(() {
              final vip = SA.login.vipStatus.value;
              if (controller.state.role.vip == true && !vip) {
                return const Positioned.fill(child: SAUnLView());
              }
              return const Positioned(left: 0, top: 0, child: SizedBox.shrink());
            }),
          ],
        ),
      ],
    );
  }
}
