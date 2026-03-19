import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

class MessageState {
  var list = <SAMessageModel>[].obs;

  RxList inputTags = [].obs;

  late ChaterModel role;
  late SAConversationModel session;
  int? get sessionId => session.id;

  bool isNewChat = false;

  // 相册变动
  var roleImagesChaned = 0.obs;

  // 聊天等级变动
  Rx<ChatAnserLevel?> chatLevel = Rx<ChatAnserLevel?>(null);

  List<Map<String, dynamic>> chatLevelConfigs = [];

  List<Map<String, dynamic>> chatLevelList = [
    {'icon': '👋', 'text': 'Level 1 Reward', 'level': 1, 'gems': 0},
    {'icon': '🥱', 'text': 'Level 2 Reward', 'level': 2, 'gems': 0},
    {'icon': '😊', 'text': 'Level 3 Reward', 'level': 3, 'gems': 0},
    {'icon': '💓', 'text': 'Level 4 Reward', 'level': 4, 'gems': 0},
  ];

  // 发送id
  var tmpSendId = '894896144';
  SAMessageModel? tmpSendMsg;

  bool isRecieving = false; // 正在接收消息
  RxBool isUndress = false.obs;
  final selectedStyle = ''.obs;
  final genType = ''.obs;
}
