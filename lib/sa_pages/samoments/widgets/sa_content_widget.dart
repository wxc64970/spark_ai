import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../controller.dart';
import 'sa_item_widget.dart';

class SaContentWidget extends GetView<SamomentsController> {
  const SaContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Padding(
        padding: EdgeInsets.only(left: 32.w, right: 32.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Image.asset("assets/images/sa_71.png", width: 244.w, fit: BoxFit.contain)],
            ),
            SizedBox(height: 32.w),
            Expanded(
              child: EasyRefresh.builder(
                controller: controller.cjRefreshController,
                onRefresh: controller.onRefresh,
                onLoad: controller.onLoad,
                childBuilder: (context, physics) {
                  return Obx(() {
                    if (controller.loading) {
                      return EmptyWidget(type: controller.type!, physics: physics);
                    } else {
                      // 假设 loading 为 false 时返回 ListView.separated
                      return ListView.separated(
                        physics: physics,
                        // padding: EdgeInsets.symmetric(vertical: 16.w),
                        padding: EdgeInsets.zero,
                        itemCount: controller.list.length,
                        itemBuilder: (context, index) {
                          return SAItemWidget(item: controller.list[index]);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 16.w);
                        },
                      );
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
