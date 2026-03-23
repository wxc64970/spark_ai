import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';

class MessageController extends GetxController {
  MessageController();

  final state = MessageState();

  // 供输入组件外部请求键盘唤起
  final FocusNode inputFocusNode = FocusNode();

  late AutoScrollController autoController;
  String get languageCode => SA.login.sessionLang.value?.value ?? 'en';
  int maxRetryCount = 30;
  bool isDispose = false;

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    // 获取传递的参数
    var arguments = Get.arguments;
    if (arguments != null) {
      state.role = arguments['role'];
      state.session = arguments['session'];
    }
    setupTease();

    loadMsg();

    loadChatLevel();

    autoController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, Get.mediaQuery.padding.bottom),
      axis: Axis.vertical,
    );

    SA.login.loadPriceConfig();
    SA.login.fetchUserInfo();
  }

  void setupTease() {
    state.inputTags.clear();
    if (SA.storage.isSAB) {
      state.inputTags.add({
        'id': 0,
        'name': SATextData.tease,
        'color': 0xFFFFFFFFF,
        "list": SATextData.inputTagsTest,
      });
    }
    state.inputTags.add({
      'id': 3,
      'name': SATextData.mask,
      'color': 0xFFFFFFFFF,
      'list': [],
    });
    if (SA.storage.isSAB) {
      final count = SA.storage.sendMsgCount;
      final showClothingCount = SAThirdPartyService.showClothingCount;
      if (count >= showClothingCount) {
        state.inputTags.add({
          'id': 1,
          'name': SATextData.undress,
          // 'icon': 'assets/images/msgbtnundre.png',
          'color': 0xFFFFFFFFF,
          'list': [],
        });
      }
    }
    update();
  }

  Future loadMsg() async {
    if (state.sessionId == null) {
      return;
    }
    state.list.clear();
    _addDefaaultTips();
    final records = await Api.messageList(1, 10000, state.sessionId!) ?? [];

    // 获取已翻译消息 id
    final Set<String> ids = SA.storage.translationMsgIds;
    // 遍历消息列表，赋值 showTranslate
    for (var msg in records) {
      if (msg.id != null && ids.contains(msg.id)) {
        msg.showTranslate = true;
      }
      if (SA.login.currentUser?.autoTranslate == true &&
          msg.translateAnswer != null) {
        msg.showTranslate = true;
      }
    }

    state.list.addAll(records);

    print(state.list.length);
    update();
  }

  void _addDefaaultTips() {
    final tips = SAMessageModel();
    tips.source = MessageSource.tips;
    tips.answer = SATextData.answer;
    state.list.add(tips);

    var scenario = state.session.scene ?? state.role.scenario;

    if (scenario != null && scenario.isNotEmpty) {
      final intro = SAMessageModel();
      intro.source = MessageSource.scenario;
      intro.answer = scenario;
      state.list.add(intro);
    } else {
      if (state.role.aboutMe != null && state.role.aboutMe!.isNotEmpty) {
        final intro = SAMessageModel();
        intro.source = MessageSource.intro;
        intro.answer = state.role.aboutMe;
        state.list.add(intro);
      }
    }
    _addRandomGreetings();
  }

  Future<void> _addRandomGreetings() async {
    final greetings = state.role.greetings;
    if (greetings == null || greetings.isEmpty) {
      return;
    }
    int randomIndex = Random().nextInt(greetings.length);
    var str = greetings[randomIndex];

    final msg = SAMessageModel();
    msg.id = '${DateTime.now().millisecondsSinceEpoch}';
    msg.answer = str;
    // msg.voiceUrl = voiceUrl;
    // msg.voiceDur = voiceDur;
    msg.source = MessageSource.welcome;
    state.list.add(msg);
  }

  Future<void> loadChatLevel() async {
    if (state.chatLevelConfigs.isNotEmpty) {
      return;
    }
    try {
      final configs = await Api.getChatLevelConfig() ?? [];
      state.chatLevelConfigs = configs.isEmpty
          ? state.chatLevelList
          : configs.map((c) {
              return {
                'icon': c.title ?? '👋',
                'level': c.level ?? 1,
                'text': 'Level ${c.level} Reward',
                'gems': c.reward ?? 0,
              };
            }).toList();

      final roleId = state.role.id;
      final userId = SA.login.currentUser?.id;
      if (roleId == null || userId == null) {
        return;
      }
      var res = await Api.fetchChatLevel(charId: roleId, userId: userId);
      state.chatLevel.value = res;
    } catch (e) {
      debugPrint('[MessageController] : $e');
    }
  }

  /// 续写
  Future<void> continueWriting() async {
    final msg = state.list.last;
    bool canSend = await canSendMsg(text: msg.answer ?? '');
    if (!canSend) {
      return;
    }
    await sendMsgRequest(path: SAApiUrl.continueWrite, isLoading: true);
  }

  Future<bool> canSendMsg({required String text, String? genType}) async {
    if (state.isRecieving) {
      SAToast.show(SATextData.waitForResponse);
      return false;
    }

    SAMessageModel lastMsg = state.list.last;
    if (lastMsg.typewriterAnimated) {
      SAToast.show(SATextData.waitForResponse);
      return false;
    }

    if (text.isEmpty) {
      SAToast.show(SATextData.pleaseInput);
      return false;
    }
    final roleId = state.role.id;
    if (roleId == null) {
      return false;
    }
    if (genType != null) {
      var star = SA.login.starCount.value;
      var imageCount = SA.login.priceConfig!.i2i ?? 0;
      var videoCount = SA.login.priceConfig!.i2v ?? 0;
      if ((genType == 'I2I' && imageCount > star) ||
          (genType == 'I2V' && videoCount > star)) {
        rechage(isUndress: true);
        return false;
      } else {
        return true;
      }
    }
    if (!SA.login.vipStatus.value) {
      if (state.role.gems == true) {
        final flag = SA.login.checkBalance(ConsumeFrom.text);
        if (!flag) {
          rechage();
          return false;
        }
      } else {
        /// 免费角色 - 最大免费条数
        int maxCount = SAThirdPartyService.maxFreeChatCount;

        final sencCount = SA.storage.sendMsgCount;

        if (sencCount > maxCount) {
          DialogWidget.alert(
            message: SATextData.freeChatUsed,
            confirmText: SATextData.upgradeTochat,
            onConfirm: () {
              SAlogEvent('t_chat_send');
              Get.toNamed(SARouteNames.vip, arguments: VipFrom.send);
            },
          );
          return false;
        }
      }
    }
    return true;
  }

  Future<void> sendMsgRequest({
    required String path,
    String? text,
    bool? isLoading,
    String? msgId,
    String? styleName,
    String? genType,
    bool? isUndress,
  }) async {
    try {
      final charId = state.role.id;
      final conversationId = state.sessionId ?? 0;
      final uid = SA.login.currentUser?.id;
      if (charId == null || uid == null || conversationId == 0) {
        SAToast.show(SATextData.someErrorTryAgain);
        return;
      }

      var body = {
        'character_id': charId,
        'conversation_id': conversationId,
        'user_id': uid,
        'auto_translate': true,
        'target_language': languageCode,
      };
      if (text != null) {
        body['message'] = text;
      }
      if (msgId != null) {
        body['msg_id'] = msgId;
      }
      if (styleName != null) {
        body['style_name'] = styleName;
      }
      if (genType != null) {
        body['gen_type'] = genType;
      }

      state.isRecieving = true;
      if (isLoading == true) {
        SALoading.show();
      }
      final res = await Api.sendMsg(path: path, body: body);
      SALoading.close();

      final msg = res?.data;
      if (res?.code == 20003) {
        rechage(isUndress: isUndress);
        return;
      }
      if (msg != null) {
        await progressReceived(msg, isUndress);
      } else {
        progressSSEError();
      }
    } catch (e) {
      progressSSEError();
    } finally {
      SALoading.close();
      state.isRecieving = false;
    }
  }

  void progressSSEError() {
    state.tmpSendMsg?.onAnswer = false;

    SAMessageModel msg = SAMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      answer: SATextData.someErrorTryAgain,
    );
    msg.source = MessageSource.error;
    msg.answer = SATextData.someErrorTryAgain;
    state.list.add(msg);
  }

  Future<void> progressReceived(SAMessageModel msg, bool? isUndress) async {
    if (msg.conversationId != state.sessionId) {
      return;
    }

    queryStatusApi();
    if (msg.textLock == MsgLockLevel.private.value) {
      msg.typewriterAnimated = SA.login.vipStatus.value;
    } else {
      msg.typewriterAnimated = true;
    }

    // 删除最后一条tmpSendMsg
    if (state.list.isNotEmpty &&
        state.list.last.id == state.tmpSendId &&
        msg.question == state.list.last.question) {
      state.list.removeLast();
    }
    if (isUndress == null) {
      final index = state.list.indexOf(msg);
      if (index != -1) {
        state.list[index] = msg;
      } else {
        state.list.add(msg);
      }
    }

    _checkChatLevel(msg);

    await SA.login.fetchUserInfo();

    state.tmpSendMsg = null;
  }

  Future<void> queryStatusApi() async {
    int currentCount = 0;

    // 异步循环：效果=递归，无栈溢出
    while (!isDispose && currentCount < maxRetryCount) {
      currentCount++;
      debugPrint('第 $currentCount 次请求接口');
      try {
        // 调用接口
        var res = await Api.messageList(1, 10000, state.sessionId!) ?? [];

        // 将服务端最新消息融合到本地列表：存在则替换，不存在则追加
        for (var msg in res) {
          if (msg.id == null) {
            continue;
          }
          final index = state.list.indexWhere((item) => item.id == msg.id);
          if (index >= 0) {
            state.list[index] = msg;
          } else {
            state.list.add(msg);
          }
        }

        final isSuccess = checkMessageList(res);
        if (isSuccess) {
          print("✅ 全部数据合规，停止轮询");
          break; // 结束递归/轮询
        } else {
          print("❌ 数据不全，10秒后重试");
          await Future.delayed(const Duration(seconds: 10));
        }
      } catch (e) {
        // 接口报错：停止/重试
        debugPrint('接口请求失败：$e');
        break;
      }
    }

    // 超过最大次数，自动停止
    if (currentCount >= maxRetryCount) {
      debugPrint('🔴 达到最大请求次数，自动停止');
    }
  }

  bool checkMessageList(List<SAMessageModel> res) {
    // 只要有任意一个元素不合规 → 返回false；全部合规 → 返回true
    return !res.any(
      (msg) =>
          (msg.source == MessageSource.i2i && msg.imgUrl == null) ||
          (msg.source == MessageSource.i2v && msg.videoUrl == null),
    );
    // for (var i = 0; i < res.length; i++) {
    //   final msg = res[i];
    //   // 打印核心字段，看真实值
    //   debugPrint(
    //     "第$i条 → src: ${msg.src}, imgUrl: ${msg.imgUrl}, videoUrl: ${msg.videoUrl}",
    //   );

    //   // 你的判断条件
    //   if ((msg.src == MessageSource.i2i && msg.imgUrl == null) ||
    //       (msg.src == MessageSource.i2v && msg.videoUrl == null)) {
    //     debugPrint("❌ 找到不合规数据，直接返回 false");
    //     return false;
    //   }
    // }

    // debugPrint("✅ 所有数据合规，返回 true");
    // return true;
  }

  void _checkChatLevel(SAMessageModel msg) async {
    bool upgrade = msg.upgrade ?? false;
    int rewards = msg.rewards ?? 0;
    var level = msg.appUserChatLevel;
    state.chatLevel.value = level;
    if (upgrade) {
      // 升级了
      await _showChatLevelUp(rewards);

      if ((level?.level ?? 0) == 2) {
        if (!SA.storage.isShowGoodCommentDialog2) {
          DialogWidget.showPositiveReview();
          SA.storage.setShowGoodCommentDialog2(true);
        }
      }
    } else {
      checkSendCount();
    }
  }

  Future _showChatLevelUp(int rewards) async {
    await DialogWidget.showChatLevelUp(rewards);

    checkSendCount();
  }

  void checkSendCount() async {
    // 发送成功后，更新发送次数

    await SA.storage.setSendMsgCount(SA.storage.sendMsgCount + 1);
    setupTease();
    if (SA.storage.isSAB) {
      var count = SA.storage.sendMsgCount;
      if (count == SAThirdPartyService.showClothingCount) {
        DialogWidget.showUndrDialog(
          message: SATextData.undrMessage,
          confirmText: SATextData.tryNow,
          clickMaskDismiss: false,
          onConfirm: () {
            DialogWidget.dismiss();
            // Get.toNamed(SARouteNames.undr, arguments: state.role);
            SAlogEvent('chat_undress_show');
            state.isUndress.value = true;
            SA.login.fetchUserInfo();
          },
          onCancel: () {
            DialogWidget.dismiss();
          },
        );
      } else {
        checkRateMsgCount();
      }
    } else {
      checkRateMsgCount();
    }
  }

  void checkRateMsgCount() async {
    SA.storage.setRateCount(SA.storage.rateCount + 1);
    final roleId = state.role.id;
    var map = SA.storage.messageCountMap;

    if (!SA.storage.isShowGoodCommentDialog1 && roleId != null) {
      final sendCount = map[roleId] ?? 0;

      if ((sendCount + 1) == 2) {
        DialogWidget.showPositiveReview();
        SA.storage.setShowGoodCommentDialog1(true);
      } else {
        map[roleId] = sendCount + 1;
        SA.storage.messageCountMap = map;
      }
    }
  }

  Future<void> rechage({bool? isUndress}) async {
    await SAToast.show(SATextData.notEnough);
    if (isUndress == true) {
      SASheetBottom.show(ConsumeFrom.undr);
      return;
    }
    // v1.3.0 - 调整为跳订阅页
    Get.toNamed(SARouteNames.vip, arguments: VipFrom.send);
  }

  Future<void> onTapUnlockImage(RoleImage image) async {
    final gems = image.gems ?? 0;
    if (SA.login.gemBalance.value < gems) {
      Get.toNamed(SARouteNames.gems, arguments: ConsumeFrom.album);
      return;
    }

    final imageId = image.id;
    final modelId = image.modelId;
    if (imageId == null || modelId == null) {
      return;
    }

    SALoading.show();
    final res = await Api.unlockImageReq(imageId, modelId);
    SALoading.close();
    if (res) {
      // 创建一个新的 images 列表
      final updatedImages = state.role.images?.map((i) {
        if (i.id == imageId) {
          return i.copyWith(unlocked: true);
        }
        return i;
      }).toList();

      // 更新 Role 对象
      state.role = state.role.copyWith(images: updatedImages);
      state.roleImagesChaned.value++;
      SA.login.fetchUserInfo();

      onTapImage(image);
    } else {
      SAToast.show(SATextData.someErrorTryAgain);
    }
  }

  void onTapImage(RoleImage image) {
    final imageUrl = image.imageUrl;
    if (imageUrl == null) {
      return;
    }
    Get.toNamed(SARouteNames.imagePreview, arguments: imageUrl);
  }

  void translateMsg(SAMessageModel msg) async {
    SAMessageModel lastMsg = state.list.last;
    if (lastMsg.typewriterAnimated) {
      SAToast.show(SATextData.waitForResponse);
      return;
    }

    final content = msg.answer;
    final id = msg.id;

    // 内容为空直接返回
    if (content == null || content.isEmpty) return;

    // 定义更新消息的方法
    Future<void> updateMessage({
      required bool showTranslate,
      String? translate,
    }) async {
      msg.showTranslate = showTranslate;

      if (id != null) {
        _transCache(isAdd: showTranslate, id: id);
      }

      if (translate != null) {
        msg.translateAnswer = translate;

        if (id != null) {
          Api.saveMsgTrans(id: id, text: translate);
        }
      }
      state.list.refresh();
    }

    // 根据状态处理逻辑
    if (msg.showTranslate == true) {
      await updateMessage(showTranslate: false);
    } else if (msg.translateAnswer != null) {
      await updateMessage(showTranslate: true);
      SAMessageTransUtils().handleTranslationClick();
    } else {
      SAlogEvent('c_trans');
      if (msg.translateAnswer == null) {
        // 获取翻译内容
        SALoading.show();
        String? result = await Api.translateText(content);
        SALoading.close();
        // 更新消息并显示翻译
        await updateMessage(showTranslate: true, translate: result);
      } else {
        await updateMessage(showTranslate: true);
      }

      SAMessageTransUtils().handleTranslationClick();
    }
  }

  void _transCache({required bool isAdd, required String id}) {
    final Set<String> ids = SA.storage.translationMsgIds;
    if (isAdd) {
      ids.add(id); // 重复添加会自动忽略
    } else {
      ids.remove(id);
    }
    SA.storage.setTranslationMsgIds(ids);
  }

  SAMessageModel? findLastServerMsg() {
    // 从后向前遍历消息列表
    for (int i = state.list.length - 1; i >= 0; i--) {
      final msg = state.list[i];

      // 如果是错误消息，删除它
      if (msg.source == MessageSource.error) {
        state.list.removeAt(i);
        continue;
      }

      // 检查是否为服务器消息类型
      final source = msg.source;
      if (source == MessageSource.text ||
          source == MessageSource.video ||
          source == MessageSource.audio ||
          source == MessageSource.photo ||
          source == MessageSource.gift ||
          source == MessageSource.clothe) {
        return msg; // 找到服务器消息，返回并停止遍历
      }
    }
    return null;
  }

  /// 重新发送消息
  Future<void> resendMsg(SAMessageModel msg) async {
    SAMessageModel? last = msg;
    if (msg.source == MessageSource.error) {
      last = findLastServerMsg();
    }
    if (last == null) {
      continueWriting();
      return;
    }

    bool canSend = await canSendMsg(text: last.answer ?? '');
    if (!canSend) {
      return;
    }

    final id = msg.id;
    if (id == null) {
      SAToast.show(SATextData.someErrorTryAgain);
      return;
    }

    await sendMsgRequest(path: SAApiUrl.resendMsg, isLoading: true, msgId: id);
  }

  /// 编辑消息
  Future<void> editMsg(String content, SAMessageModel msg) async {
    bool canSend = await canSendMsg(text: msg.answer ?? '');
    if (!canSend) {
      return;
    }
    SALoading.show();
    state.isRecieving = true;
    final id = msg.id;
    if (id == null) {
      SAToast.show(SATextData.someErrorTryAgain);
      return;
    }
    var data = await Api.editMsg(id: id, text: content);
    if (data != null) {
      // 查找上一个 sendtext 消息  如果存在question一样的，将它删除
      SAMessageModel? pre = state.list.firstWhereOrNull(
        (element) => element.question == data.question,
      );
      state.list.remove(pre);
      // 替换就消息
      state.list.removeWhere((element) => element.id == id);
      state.list.add(data);
      SA.login.fetchUserInfo();
    }
    state.isRecieving = false;
    SALoading.close();
  }

  /// 修改聊天场景
  Future<void> editScene(String scene) async {
    void request() async {
      final charId = state.role.id;
      final conversationId = state.sessionId ?? 0;
      if (charId == null || conversationId == 0) {
        SAToast.show(SATextData.someErrorTryAgain);
        return;
      }

      bool res = await Api.editScene(
        convId: conversationId,
        scene: scene,
        roleId: charId,
      );
      if (res) {
        state.session.scene = scene;
        state.list.clear();
        _addDefaaultTips();
      }
      SALoading.close();
    }

    DialogWidget.alert(
      message: SATextData.scenarioRestartWarning,
      cancelText: SATextData.cancel,
      confirmText: SATextData.confirm,
      onConfirm: () {
        DialogWidget.dismiss();
        request();
      },
    );
  }

  /// 修改会话模式 聊天模型 short / long
  Future<void> editChatMode(bool isLong) async {
    final conversationId = state.sessionId ?? 0;
    if (conversationId == 0) {
      SAToast.show(SATextData.someErrorTryAgain);
      return;
    }

    var mode = isLong ? 'long' : 'short';
    if (state.session.chatModel == mode) {
      if (Get.isBottomSheetOpen == true) Get.back();
      return;
    }
    SALoading.show();
    bool res = await Api.editChatMode(convId: conversationId, mode: mode);
    if (res) {
      state.session.chatModel = mode;
      if (Get.isBottomSheetOpen == true) Get.back();
    }
    SALoading.close();
  }

  /// 切换 mask
  Future<bool> changeMask(int maskId) async {
    SALoading.show();
    final conversationId = state.session.id;
    final res = await Api.changeMask(
      conversationId: conversationId,
      maskId: maskId,
    );
    SALoading.close();
    if (res) {
      state.session.profileId = maskId;
      state.list.clear();
      _addDefaaultTips();
      _addMaskTips();
    }
    return res;
  }

  void _addMaskTips() {
    final msg = SAMessageModel();
    msg.source = MessageSource.maskTips;
    msg.answer = SATextData.maskApplied;
    state.list.add(msg);
  }

  void cleanFormMask() {
    state.list.clear();
    _addDefaaultTips();
    _addMaskTips();
  }

  Future<void> sendMsg(String text) async {
    bool canSend = await canSendMsg(text: text);
    if (!canSend) {
      return;
    }

    addTemSendMsg(text);

    await sendMsgRequest(path: SAApiUrl.sendMsg, text: text);
  }

  Future<void> sendMsgUndress({
    String? text,
    String? styleName,
    String? genType,
  }) async {
    SALoading.show();
    try {
      if (text != null) {
        bool canSend = await canSendMsg(text: text, genType: genType);
        if (!canSend) {
          return;
        }
        addTemSendMsg(text);
      }
      await sendMsgRequest(
        path: SAApiUrl.sendMsg,
        text: text,
        styleName: styleName,
        genType: genType,
        isUndress: true,
      );
    } catch (e) {
    } finally {
      SALoading.close();
    }
  }

  Future<bool> resetConv() async {
    SALoading.show();
    var result = await Api.resetSession(state.sessionId ?? 0);
    SALoading.close();
    if (result != null) {
      state.session = result;
      state.list.clear();
      _addDefaaultTips();
      return true;
    }
    return false;
  }

  Future<bool> deleteConv() async {
    SALoading.show();
    var result = await Api.deleteSession(state.sessionId ?? 0);

    // if (result && Get.isRegistered<ConversationController>()) {
    //   Get.find<ConversationController>().dataList.removeWhere((r) => r.id == state.sessionId);
    //   Get.find<ConversationController>().dataList.refresh();
    // }

    SALoading.close();
    return result;
  }

  void addTemSendMsg(String text) {
    final charId = state.role.id;
    final conversationId = state.sessionId ?? 0;
    final uid = SA.login.currentUser?.id;
    if (charId == null || uid == null) {
      SAToast.show('charId or uid is null');
      return;
    }

    // 临时发送显示的消息
    final msg = SAMessageModel(
      id: state.tmpSendId,
      question: text,
      userId: SA.login.currentUser?.id,
      conversationId: conversationId,
      characterId: charId,
      onAnswer: true,
    );
    msg.source = MessageSource.sendText;
    state.list.add(msg);
    state.tmpSendMsg = msg;
  }

  String formatNumber(double? value) {
    if (value == null) {
      return '0';
    }
    if (value % 1 == 0) {
      // 如果小数部分为 0，返回整数
      return value.toInt().toString();
    } else {
      // 如果有小数部分，返回原值
      return value.toString();
    }
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    isDispose = true;
    inputFocusNode.dispose();
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    autoController.dispose();
    isDispose = true;
    super.dispose();
  }
}
