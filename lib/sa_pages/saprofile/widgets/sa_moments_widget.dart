import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/message/widgets/sa_img_album.dart';

import '../controller.dart';

class MomentsWidget extends GetView<SaprofileController> {
  const MomentsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 32.w),
      margin: EdgeInsets.only(bottom: 32.w, top: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(46.r),
        // border: Border.all(width: 2.w, color: Color(0xffEBEBEB)),
        boxShadow: [
          BoxShadow(color: const Color(0x61C5E7B3), offset: const Offset(0, 0), blurRadius: 8, spreadRadius: 1),
        ],
        color: Colors.white,
      ),
      child: Obx(() {
        final images = controller.images;
        if (!SA.storage.isSAB || images.isEmpty) {
          return const SizedBox();
        }
        final imageCount = images.length;
        return GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8.w,
            crossAxisSpacing: 18.w,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (_, idx) {
            final image = images[idx];
            final unlocked = image.unlocked ?? false;
            return PhotoAlbumItem(
              image: image,
              avatar: controller.role.avatar,
              unlocked: unlocked,
              onTap: () {
                if (unlocked) {
                  controller.msgCtr.onTapImage(image);
                } else {
                  controller.msgCtr.onTapUnlockImage(image);
                }
              },
              imageHeight: Get.width,
            );
          },
          itemCount: imageCount,
        );
      }),
    );
  }
}
