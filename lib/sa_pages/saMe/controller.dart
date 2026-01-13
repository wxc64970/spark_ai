import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/sa_setting_message_background.dart';

class SameController extends GetxController {
  SameController();

  final FocusNode _focusNode = FocusNode();
  late TextEditingController _textEditingController;
  var version = ''.obs;
  var chatbgImagePath = ''.obs;
  final _nickname = ''.obs;
  String get nickname => _nickname.value;
  set nickname(String value) => _nickname.value = value;

  _initData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = "V${packageInfo.version}";
    update(["me"]);
  }

  void onTapExprolreVIP() {
    Get.toNamed(SARouteNames.vip, arguments: VipFrom.mevip);
  }

  changeNickName() {
    nickname = SA.login.currentUser?.nickname ?? '';
    _textEditingController = TextEditingController(text: nickname);

    DialogWidget.input(
      title: SATextData.yourNickname,
      hintText: SATextData.inputYourNickname,
      focusNode: _focusNode,
      textEditingController: _textEditingController,
      onConfirm: () async {
        if (_textEditingController.text.trim().isEmpty) {
          SAToast.show(SATextData.inputYourNickname);
          return;
        }
        nickname = _textEditingController.text.trim();
        SALoading.show();
        await SA.login.modifyUserNickname(nickname);
        SALoading.close();
        DialogWidget.dismiss();
      },
    );
  }

  feedback() async {
    final version = await SAInfoUtils.version();
    final device = await SA.storage.getDeviceId();
    final uid = SA.login.currentUser?.id;

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: EnvConfig.email, // 收件人
      query: "subject=Feedback&body=version: $version\ndevice: $device\nuid: $uid\nPlease input your problem:\n", // 设置默认主题和正文内容
    );
    if (await canLaunchUrl(emailUri)) {
      launchUrl(emailUri);
    } else {
      SAToast.show('Could not launch email client');
    }
  }

  changeChatBackground() {
    DialogWidget.show(
      child: SettingMessageBackground(onTapUpload: uploadImage, onTapUseChat: resetChatBackground, isUseChater: chatbgImagePath.isEmpty),
    );
  }

  PrivacyPolicy() {
    launchUrl(Uri.parse(EnvConfig.privacy));
  }

  TermsOfUse() {
    launchUrl(Uri.parse(EnvConfig.terms));
  }

  void resetChatBackground() async {
    await DialogWidget.dismiss();

    SA.storage.setChatBgImagePath('');
    chatbgImagePath.value = '';
  }

  void uploadImage() async {
    await DialogWidget.dismiss();

    var pickedFile = await SAImageUtils.pickImageFromGallery();

    if (pickedFile != null) {
      SALoading.show();
      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final cachedImagePath = path.join(directory.path, fileName);
      final File cachedImage = await File(pickedFile.path).copy(cachedImagePath);
      SA.storage.setChatBgImagePath(cachedImage.path);
      chatbgImagePath.value = cachedImage.path;
      await Future.delayed(const Duration(seconds: 2));
      SALoading.close();
      SAToast.show(SATextData.backUpdatedSucc);
    }
  }

  Future<void> openAppStore() async {
    try {
      if (Platform.isIOS) {
        String appId = EnvConfig.appId;
        final Uri url = Uri.parse('https://apps.apple.com/app/id$appId');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          SAToast.show('Could not launch $url');
        }
      } else if (Platform.isAndroid) {
        String packageName = await SAInfoUtils.packageName();
        final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=$packageName');

        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          SAToast.show('Could not launch $url');
        }
      } else {
        SAToast.show('Unsupported platform');
      }
    } catch (e) {
      SAToast.show('Could not launch ${e.toString()}');
    }
  }

  //跳转语言设置页面
  pushChooseLang() {
    Get.toNamed(SARouteNames.language);
  }

  @override
  void onInit() {
    super.onInit();
    nickname = SA.login.currentUser?.nickname ?? '';
    _initData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
