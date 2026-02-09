import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/index.dart';

import 'sa_no_vip_widget.dart';
import 'sa_setting_item.dart';
import 'sa_vip_widget.dart';

class ContentWidget extends GetView<SameController> {
  const ContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SA.login.vipStatus.value ? const VipWidget() : const NonVipWidget(),
          SizedBox(height: 40.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 32.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: SettingItem(
                  sectionTitle: SATextData.nickname,
                  title: controller.nickname,
                  onTap: controller.changeNickName,
                  top: 32,
                ),
              ),
              if (SA.storage.isSAB)
                Container(
                  margin: EdgeInsets.only(bottom: 32.w),
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: SettingItem(
                    title: SATextData.creations,
                    onTap: controller.handleCreations,
                    top: 0,
                  ),
                ),
              Container(
                margin: EdgeInsets.only(bottom: 32.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final lang = SA.login.sessionLang.value;
                      final name = lang?.label ?? '-';
                      return SettingItem(
                        sectionTitle: SATextData.support,
                        title: SATextData.language,
                        subtitle: name,
                        onTap: () {
                          controller.pushChooseLang();
                        },
                        top: 32,
                      );
                    }),
                    SettingItem(
                      title: SATextData.feedback,
                      onTap: controller.feedback,
                      top: 32,
                    ),
                    SettingItem(
                      title: SATextData.setChatBackground,
                      onTap: controller.changeChatBackground,
                      top: 32,
                    ),
                    Obx(
                      () => SettingItem(
                        title: SATextData.appVersion,
                        subtitle: controller.version.value,
                        top: 32,
                        onTap: () => controller.openAppStore(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 32.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingItem(
                      sectionTitle: SATextData.legal,
                      title: SATextData.privacyPolicy,
                      onTap: controller.PrivacyPolicy,
                      top: 32,
                    ),
                    SettingItem(
                      title: SATextData.termsOfUse,
                      onTap: controller.TermsOfUse,
                      top: 32,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
