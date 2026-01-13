import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';

/// hello
class BuildContentWidget extends GetView<SamaskController> {
  const BuildContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoad: controller.onLoad,
      childBuilder: (context, physics) {
        return SingleChildScrollView(
          physics: physics,
          padding: EdgeInsets.only(left: 32.w, right: 32.w),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    SATextData.profileMaskDescription,
                    style: TextStyle(fontSize: 28.sp, color: Color(0xff000000), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 10.w),
              Obx(() {
                if (controller.state.maskList.isEmpty && controller.state.emptyType.value != null) {
                  return SizedBox(
                    width: double.infinity,
                    height: 400,
                    child: EmptyWidget(
                      type: controller.state.emptyType.value!,
                      paddingTop: 20,
                      physics: const NeverScrollableScrollPhysics(),
                      onReload: controller.state.emptyType.value == EmptyType.noNetwork ? () => controller.refreshController.callRefresh() : null,
                    ),
                  );
                }
                if (controller.state.maskList.isNotEmpty) {
                  return _buildGridItems();
                }
                return const SizedBox(height: 400);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGridItems() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.state.maskList.length,
        itemBuilder: (_, index) {
          final item = controller.state.maskList[index];
          return _buildItem(item);
        },
      ),
    );
  }

  Widget _buildItem(SAMaskModel mask) {
    return Obx(() {
      final isSelected = controller.state.selectedMask.value?.id == mask.id;
      return GestureDetector(
        onTap: () {
          controller.selectMask(mask);
        },
        child: Column(
          children: [
            SizedBox(height: 58.w),
            Row(
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: isSelected
                        ? BoxDecoration(
                            gradient: const LinearGradient(begin: Alignment(0, -0.5), end: Alignment(1, 0.5), colors: [SAAppColors.primaryColor, SAAppColors.yellowColor]),
                            borderRadius: BorderRadius.circular(16.r),
                          )
                        : BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsets.all(4.w), // 边框厚度
                      child: Container(
                        clipBehavior: Clip.none,
                        // margin: EdgeInsets.only(top: 26.w),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: Get.width,
                              clipBehavior: Clip.none,
                              padding: EdgeInsets.all(24.w),
                              decoration: BoxDecoration(color: isSelected ? SAAppColors.primaryColor.withValues(alpha: 0.13) : Colors.white, borderRadius: BorderRadius.circular(16.r)),
                              child: Text(
                                mask.description ?? '',
                                style: TextStyle(fontSize: 28.sp, color: Color(0xf0000000), fontWeight: FontWeight.w400),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: -26.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 16.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(26.r), bottomRight: Radius.circular(26.r)),
                                  color: Color(0xff1A2608),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32.w,
                                      height: 32.w,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r), color: Colors.white10),
                                      child: Center(
                                        child: Image.asset(Gender.fromValue(mask.gender).icon, height: 32.w, fit: BoxFit.contain),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      mask.profileName ?? '',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        color: Gender.fromValue(mask.gender).display == SATextData.male
                                            ? SAAppColors.primaryColor
                                            : Gender.fromValue(mask.gender).display == SATextData.female
                                            ? SAAppColors.pinkColor
                                            : SAAppColors.yellowColor,
                                      ),
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
                SizedBox(width: 16.w),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => controller.pushEditPage(mask: mask),
                  child: Image.asset("assets/images/sa_39.png", width: 48.w, fit: BoxFit.contain),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
