import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

const String loginRewardTag = 'dfa445sdf';
const String giftLoadingTag = 'ghnwrg52';
const String rateUsTag = 'kgf456';
const String rechargeSuccTag = '098nbbd';
const String chatLevelUpTag = '1236hdsgahk';
const String positiveReviewTag = 'sfb23dfgs';
const String undrDialog = 'sdfg456';

class DialogWidget {
  static Future<void> dismiss({String? tag}) {
    return SmartDialog.dismiss(status: SmartStatus.dialog, tag: tag);
  }

  static Future<void> show({required Widget child, bool? clickMaskDismiss = true, String? tag, bool? showCloseButton = true}) async {
    final completer = Completer<void>();

    SmartDialog.show(
      clickMaskDismiss: clickMaskDismiss,
      keepSingle: true,
      debounce: true,
      tag: tag,
      maskWidget: ClipPath(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(color: Colors.black.withValues(alpha: 0.6)),
        ),
      ),
      builder: (context) {
        if (showCloseButton == true) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              child,
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [_buildCloseButton()],
              // ),
            ],
          );
        } else {
          return child;
        }
      },
      onDismiss: () {
        completer.complete();
      },
    );

    await completer.future;
  }

  static Future<void> alert({
    String? title,
    String? message,
    Widget? messageWidget,
    bool? clickMaskDismiss = false,
    String? cancelText,
    String? confirmText,
    void Function()? onCancel,
    void Function()? onConfirm,
  }) async {
    return show(
      clickMaskDismiss: false,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 55.w),
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 64.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.r),
          gradient: LinearGradient(colors: [Color(0xffEBFFCC), Color(0xffFFFFFF)], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.0, 0.3]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            _buildText(title ?? SATextData.tips, 34.sp, FontWeight.w600),
            if (title?.isNotEmpty == true) const SizedBox(height: 16),
            _buildText(message, 28.sp, FontWeight.w500),
            if (messageWidget != null) messageWidget,
            ButtonGradientWidget(
              onTap: onConfirm,
              margin: EdgeInsets.only(top: 40.w),
              height: 88,
              borderRadius: BorderRadius.circular(100.r),
              child: Center(
                child: Text(
                  confirmText ?? SATextData.confirm,
                  style: TextStyle(fontFamily: "Montserrat", color: Colors.black, fontSize: 28.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            if (cancelText?.isNotEmpty == true)
              ButtonWidget(
                onTap: () {
                  onCancel ?? SmartDialog.dismiss();
                },
                height: 48,
                color: Color(0xffF7F7F7),
                child: Center(
                  child: Text(
                    SATextData.cancel,
                    style: TextStyle(fontFamily: "Montserrat", color: Colors.black, fontSize: 28.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Future input({
    String? title,
    String? message,
    String? hintText,
    Widget? messageWidget,
    bool? clickMaskDismiss = false,
    String? cancelText,
    String? confirmText,
    void Function()? onCancel,
    void Function()? onConfirm,
    FocusNode? focusNode,
    TextEditingController? textEditingController,
  }) async {
    final focusNode1 = focusNode ?? FocusNode();
    final textController1 = textEditingController ?? TextEditingController();

    return SmartDialog.show(
      clickMaskDismiss: clickMaskDismiss,
      useAnimation: false,
      maskWidget: ClipPath(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(color: Colors.black.withValues(alpha: 0.8)),
        ),
      ),
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          focusNode1.requestFocus();
        });

        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        return AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [_buildCloseButton()]),
                  SizedBox(height: 48.w),
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 68.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: AlignmentDirectional.topCenter,
                            end: AlignmentDirectional.bottomCenter,
                            colors: [const Color(0xFFEBFFCC), const Color(0xFFFFFFFF)],
                            stops: const [0.0, 0.3],
                          ),
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildText(title, 34.sp, FontWeight.w600),
                            if (title?.isNotEmpty == true) SizedBox(height: 40.w),
                            _buildText(message, 14, FontWeight.w500),
                            if (messageWidget != null) messageWidget,
                            const SizedBox(height: 16),
                            Container(
                              height: 84.w,
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFFFF),
                                borderRadius: BorderRadius.circular(46.r),
                                boxShadow: [BoxShadow(color: const Color(0x61C5E7B3), offset: const Offset(0, 8), blurRadius: 46.r, spreadRadius: 0)],
                              ),
                              child: Center(
                                child: TextField(
                                  autofocus: true,
                                  textInputAction: TextInputAction.done,
                                  onEditingComplete: () {},
                                  minLines: 1,
                                  maxLength: 20,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(height: 1, color: Colors.black, fontSize: 24.sp, fontWeight: FontWeight.w700),
                                  controller: textController1,
                                  decoration: InputDecoration(
                                    hintText: hintText ?? 'input',
                                    counterText: '', // 去掉字数显示
                                    hintStyle: const TextStyle(color: Color(0xFFA5A5B9)),
                                    fillColor: Colors.transparent,
                                    border: InputBorder.none,
                                    filled: true,
                                    isDense: true,
                                  ),
                                  focusNode: focusNode1,
                                ),
                              ),
                            ),
                            SizedBox(height: 56.w),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ButtonGradientWidget(
                                    onTap: onConfirm,
                                    height: 88,
                                    borderRadius: BorderRadius.circular(100.r),
                                    child: Center(
                                      child: Text(
                                        SATextData.confirm,
                                        style: TextStyle(fontFamily: "Montserrat", color: Colors.black, fontSize: 28.sp, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildCloseButton({void Function()? onTap}) {
    return InkWell(
      onTap: () {
        SmartDialog.dismiss();
        onTap?.call();
      },
      child: Image.asset("assets/images/close.png", width: 48.w, fit: BoxFit.contain),
    );
  }

  static Widget _buildText(String? text, double fontSize, FontWeight fontWeight) {
    if (text?.isNotEmpty != true) return const SizedBox.shrink();
    return Text(
      text!,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black, fontSize: fontSize, fontWeight: fontWeight),
    );
  }

  static Future showChatLevel() async {
    return show(child: const SALevelDialog(), clickMaskDismiss: false);
  }

  static bool _isChatSALevelDialogVisible = false;

  static Future<void> showChatLevelUp(int rewards) async {
    // 防止重复弹出
    if (_isChatSALevelDialogVisible) return;

    // 设置标记为显示中
    _isChatSALevelDialogVisible = true;

    try {
      await _showLevelUpToast(rewards);
    } finally {
      _isChatSALevelDialogVisible = false;
    }
  }

  static Future<void> _showLevelUpToast(int rewards) async {
    final completer = Completer<void>();

    SmartDialog.show(
      displayTime: const Duration(milliseconds: 1500),
      maskColor: Colors.transparent,
      clickMaskDismiss: false,
      onDismiss: () => completer.complete(),
      builder: (context) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(40.r)),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8.w,
                  children: [
                    Image.asset('assets/images/sa_09.png', width: 48.w, fit: BoxFit.contain),
                    Text(
                      '+ $rewards',
                      style: TextStyle(fontSize: 32.sp, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future showLoginReward() async {
    if (checkExist(loginRewardTag)) {
      return;
    }
    return show(
      tag: loginRewardTag,
      clickMaskDismiss: false,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 668.w,
            height: SA.login.vipStatus.value ? 542.w : 698.w,
            padding: EdgeInsets.only(left: 52.w, right: 72.w, top: 100.w),
            margin: EdgeInsets.only(bottom: 76.w),
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(SA.login.vipStatus.value ? 'assets/images/sa_19.png' : 'assets/images/sa_18.png'), fit: BoxFit.cover),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SATextData.dailyReward,
                  style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: "Montserrat"),
                ),
                SizedBox(height: 28.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/sa_20.png", width: 104.w, fit: BoxFit.contain),
                    SizedBox(width: 16.w),
                    Text(
                      SA.login.vipStatus.value ? '+50' : '+20',
                      style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w900, color: SAAppColors.pinkColor, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),

                SizedBox(height: 64.w),
                !SA.login.vipStatus.value
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                margin: EdgeInsets.only(bottom: 10.w, left: 38.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24.r),
                                    topRight: Radius.circular(24.r),
                                    bottomRight: Radius.circular(24.r),
                                    bottomLeft: Radius.circular(2.r),
                                  ),
                                  color: Color(0xffFFD9FE),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Pro',
                                      style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w500, color: Color(0xff1A1A1A)),
                                    ),
                                    Text(
                                      ' 50 ',
                                      style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700, color: Color(0xff1A1A1A)),
                                    ),
                                    Image.asset('assets/images/sa_09.png', width: 32.w, fit: BoxFit.contain),
                                    Text(
                                      '/day',
                                      style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w500, color: Color(0xff1A1A1A)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ButtonGradientWidget(
                            onTap: () {
                              Get.toNamed(SARouteNames.vip, arguments: VipFrom.dailyrd);
                            },
                            width: 536.w,
                            height: 88,
                            gradientColors: [Color(0xffF77DF3), Color(0xffA67DF7)],
                            borderRadius: BorderRadius.circular(100.r),
                            child: Center(
                              child: Text(
                                SATextData.gotToPro,
                                style: TextStyle(fontFamily: "Montserrat", color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.w),
                        ],
                      )
                    : const SizedBox.shrink(),

                SA.login.vipStatus.value
                    ? ButtonGradientWidget(
                        onTap: () async {
                          await Api.getDailyReward();
                          await SA.login.fetchUserInfo();
                          dismiss(tag: loginRewardTag);
                        },
                        width: 536.w,
                        height: 88,
                        gradientColors: [Color(0xffF77DF3), Color(0xffA67DF7)],
                        borderRadius: BorderRadius.circular(100.r),
                        child: Center(
                          child: Text(
                            SATextData.collect,
                            style: TextStyle(fontFamily: "Montserrat", color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          await Api.getDailyReward();
                          await SA.login.fetchUserInfo();
                          dismiss(tag: loginRewardTag);
                        },
                        child: Container(
                          width: 536.w,
                          height: 88.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100.r),
                            border: Border.all(width: 2.w, color: Color(0xffF7F7F7)),
                          ),
                          child: Center(
                            child: Text(
                              SATextData.collect,
                              style: TextStyle(fontFamily: "Montserrat", fontSize: 28.sp, color: Color(0xff1A1A1A), fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            width: 668.w,
            child: Center(
              child: InkWell(
                onTap: () {
                  SmartDialog.dismiss();
                },
                child: Image.asset('assets/images/close.png', width: 48.w, fit: BoxFit.contain),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future showPositiveReview() async {
    return Get.bottomSheet(positiveReviewWidget(), isDismissible: false, isScrollControlled: true, enableDrag: false);
  }

  static Widget positiveReviewWidget() {
    Rx<RewardType> review = RewardType.unknown.obs;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 32.w),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                Get.back();
              },
              child: Image.asset("assets/images/close.png", width: 48.w, fit: BoxFit.contain),
            ),
          ],
        ),
        SizedBox(height: 32.w),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: Get.width,
              height: 580.w,
              padding: EdgeInsets.symmetric(vertical: 64.w, horizontal: 58.w),
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/sa_10.png'), fit: BoxFit.contain),
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
              ),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SATextData.positiveReviewTitle,
                      style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                    SizedBox(height: 32.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            review.value = RewardType.dislike;
                          },
                          child: Container(
                            width: 168.w,
                            height: 168.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: review.value == RewardType.dislike ? Color(0xffADFD32).withValues(alpha: 0.2) : Colors.white,
                              border: Border.all(width: 2.w, color: review.value == RewardType.dislike ? Color(0xffADFD32) : Color(0xffF4F7F0)),
                            ),
                            child: Center(
                              child: Image.asset(review.value == RewardType.dislike ? 'assets/images/sa_15.png' : 'assets/images/sa_12.png', width: 80.w, fit: BoxFit.contain),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            review.value = RewardType.accept;
                          },
                          child: Container(
                            width: 168.w,
                            height: 168.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: review.value == RewardType.accept ? Color(0xffADFD32).withValues(alpha: 0.2) : Colors.white,
                              border: Border.all(width: 2.w, color: review.value == RewardType.accept ? Color(0xffADFD32) : Color(0xffF4F7F0)),
                            ),
                            child: Center(
                              child: Image.asset(review.value == RewardType.accept ? 'assets/images/sa_16.png' : 'assets/images/sa_13.png', width: 80.w, fit: BoxFit.contain),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            review.value = RewardType.like;
                          },
                          child: Container(
                            width: 168.w,
                            height: 168.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: review.value == RewardType.like ? Color(0xffADFD32).withValues(alpha: 0.2) : Colors.white,
                              border: Border.all(width: 2.w, color: review.value == RewardType.like ? Color(0xffADFD32) : Color(0xffF4F7F0)),
                            ),
                            child: Center(
                              child: Image.asset(review.value == RewardType.like ? 'assets/images/sa_17.png' : 'assets/images/sa_14.png', width: 80.w, fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 58.w),
                    review.value == RewardType.unknown
                        ? SizedBox(height: 25.w)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getRewardTypeDesc(review.value),
                                style: TextStyle(fontSize: 22.sp, color: Color(0xff1A1A1A), fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                    SizedBox(height: 8.w),
                    review.value == RewardType.unknown
                        ? Container(
                            height: 96.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.r),
                              gradient: LinearGradient(colors: [SAAppColors.primaryColor.withValues(alpha: 0.5), SAAppColors.yellowColor.withValues(alpha: 0.5)]),
                            ),
                            child: Center(
                              child: Text(
                                SATextData.submit,
                                style: TextStyle(fontSize: 28.sp, color: Color(0xff1A1A1A), fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        : ButtonGradientWidget(
                            onTap: () {
                              SmartDialog.dismiss();
                              if (review.value == RewardType.like) {
                                RoutePages.openAppStoreReview();
                              } else {
                                RoutePages.toEmail();
                              }
                            },
                            height: 96,
                            width: Get.width,
                            borderRadius: BorderRadius.circular(100.r),
                            child: Center(
                              child: Text(
                                review.value == RewardType.like ? SATextData.submit : SATextData.subFeedback,
                                style: TextStyle(color: Color(0xff1A1A1A), fontSize: 28.sp, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: -70.w,
              child: Image.asset("assets/images/sa_11.png", width: 200.w, fit: BoxFit.contain),
            ),
          ],
        ),
      ],
    );
  }

  static Future hiddenGiftLoading() {
    return SmartDialog.dismiss(tag: giftLoadingTag);
  }

  static bool rateLevel3Shoed = false;

  static bool rateCollectShowd = false;

  static bool checkExist(String tag) {
    return SmartDialog.checkExist(tag: tag);
  }

  static Future<void> showRechargeSuccess(int number) async {
    return DialogWidget.show(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(64.w),
            margin: EdgeInsets.symmetric(horizontal: 85.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.r),
              gradient: LinearGradient(begin: AlignmentDirectional.topCenter, end: AlignmentDirectional.bottomCenter, colors: [const Color(0xFFFFFFFF), const Color(0xFFFFFFFF)]),
            ),
            child: Column(
              spacing: 10.w,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/sa_44.png", width: 470.w, fit: BoxFit.contain),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.w,
                  children: [
                    Text(
                      '+$number',
                      style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w600, color: Color(0xff222222), fontFamily: "Montserrat", fontStyle: FontStyle.italic),
                    ),
                    Text(
                      SATextData.diamond,
                      style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w500, color: Color(0xff222222)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.w),
          InkWell(
            onTap: () {
              SmartDialog.dismiss(tag: rechargeSuccTag);
            },
            child: Image.asset("assets/images/close.png", width: 64.w, fit: BoxFit.contain),
          ),
        ],
      ),
      clickMaskDismiss: false,
      tag: rechargeSuccTag,
    );
  }

  static Future<void> showUndrDialog({
    String? title,
    String? message,
    Widget? messageWidget,
    bool? clickMaskDismiss = false,
    String? cancelText,
    String? confirmText,
    void Function()? onCancel,
    void Function()? onConfirm,
  }) async {
    return DialogWidget.show(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset("assets/images/undr_bg.png", width: 564.w, fit: BoxFit.contain),

              Container(
                width: 564.w,
                height: 752.w,
                padding: EdgeInsets.symmetric(vertical: 56.w, horizontal: 52.w),
                child: Column(
                  children: [
                    Image.asset("assets/images/undr_img.png", width: 240.w, fit: BoxFit.contain),
                    SizedBox(height: 40.w),
                    Text(
                      SATextData.tips,
                      style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w600, color: Color(0xff080817)),
                    ),
                    SizedBox(height: 16.w),
                    Text(
                      message ?? '',
                      style: TextStyle(fontSize: 26.sp, color: Color(0xff6D6C6E), fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 120.w),
                    ButtonGradientWidget(
                      height: 96,
                      onTap: onConfirm,
                      child: Center(
                        child: Text(
                          confirmText ?? SATextData.confirm,
                          style: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 48.w),
          InkWell(
            onTap: onCancel,
            child: Image.asset("assets/images/close@2x.png", width: 64.w, fit: BoxFit.contain),
          ),
        ],
      ),
      clickMaskDismiss: clickMaskDismiss,
      tag: undrDialog,
    );
  }
}
