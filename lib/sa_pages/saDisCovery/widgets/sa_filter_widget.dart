import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';

/// hello
class SAFilterWidget extends GetView<SadiscoveryController> {
  const SAFilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Padding(
            padding: EdgeInsets.only(left: 32.w),
            child: Image.asset("assets/images/close.png", width: 48.w, fit: BoxFit.contain),
          ),
        ),
        SizedBox(height: 32.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 56.w),
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32.w), topRight: Radius.circular(32.w)),
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [const Color(0xffEBFFCC), const Color(0xffFFFFFF)], stops: const [0.0, 0.3]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    SATextData.chooseYourTags,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w600, color: const Color(0xFF000000)),
                  ),
                ],
              ),
              SizedBox(height: 32.w),
              tagTitleWidget(),
              SizedBox(height: 32.w),
              SizedBox(
                height: 700.w,
                child: SingleChildScrollView(padding: EdgeInsets.all(12.w), child: Obx(() => tagsItemWidget())),
              ),
              SizedBox(height: 40.w),
              ButtonGradientWidget(
                height: 96,
                width: 536.w,
                onTap: controller.handleFilterSubmit,
                child: Center(
                  child: Text(
                    SATextData.confirm,
                    style: TextStyle(fontFamily: "Montserrat", fontSize: 28.sp, color: Color(0xff1A1A1A), fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget tagTitleWidget() {
    var tags = controller.roleTags;
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }
    List<SATagsModel> result = (tags.length > 2) ? tags.take(2).toList() : tags;

    SATagsModel type1 = result[0];

    SATagsModel? type2;
    if (result.length > 1) {
      type2 = result[1];
    }
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 32.w,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  controller.selectedType.value = type1;
                },
                child: Obx(() => buildTitleItem(type1)),
              ),
              if (type2 != null)
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    controller.selectedType.value = type2;
                  },
                  child: Obx(() => buildTitleItem(type2!)),
                ),
            ],
          ),
          Obx(() {
            final tags = controller.selectedType.value?.tags;

            bool containsAll = false;
            if (tags != null && tags.isNotEmpty) {
              containsAll = controller.selectTags.containsAll(tags);
            }
            return TextButton(
              onPressed: () {
                if (containsAll) {
                  controller.selectTags.removeAll(tags ?? []);
                } else {
                  controller.selectTags.addAll(tags ?? []);
                }
              },
              child: Text(
                containsAll ? SATextData.unselectAll : SATextData.selectAll,
                style: TextStyle(color: Colors.black, fontSize: 32.sp, fontWeight: FontWeight.w500),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildTitleItem(SATagsModel type) {
    bool isSelected = type == controller.selectedType.value;
    return Stack(
      children: [
        isSelected
            ? Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 86.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                      gradient: LinearGradient(colors: [SAAppColors.primaryColor, SAAppColors.yellowColor]),
                    ),
                  ),
                ),
              )
            : SizedBox(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              type.labelType ?? '',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: isSelected ? Colors.black : Color(0xff808080), fontSize: isSelected ? 32.sp : 28.sp, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }

  Widget tagsItemWidget() {
    final tags = controller.selectedType.value?.tags;
    if (tags == null || tags.isEmpty) {
      return const SizedBox();
    }
    return GridView.builder(
      itemCount: tags.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 24.w, crossAxisSpacing: 30.w, childAspectRatio: 208 / 88),
      itemBuilder: (context, index) {
        var tag = tags[index];
        return GestureDetector(
          onTap: () {
            if (controller.selectTags.contains(tag)) {
              controller.selectTags.remove(tag);
            } else {
              controller.selectTags.add(tag);
            }
            controller.update();
          },
          child: buildItem(tag),
        );
      },
    );
  }

  Widget buildItem(TagModel tag) {
    return Obx(() {
      var isSelected = controller.selectTags.contains(tag);
      return Container(
        height: 88.w,
        width: 208.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
          border: Border.all(color: isSelected ? SAAppColors.primaryColor : Color(0xffF4F7F0)),
          color: isSelected ? SAAppColors.primaryColor.withValues(alpha: 0.3) : Color(0xffF4F7F0),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Text(
                tag.name ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF4D4D4D), fontSize: 28.sp, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // if (isSelected)
            //   Positioned(
            //     top: -12.w,
            //     right: -12.w,
            //     child: Image.asset("assets/images/choose@2x.png", width: 48.w, height: 48.w),
            //   ),
          ],
        ),
      );
    });
  }
}
