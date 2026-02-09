class SAApiUrl {
  static const String collectRole = '/v2/characterProfile/collect';
  static const String aiImageResult = '/v2/getUndressWithResult';
  static const String addSession = '/aiChatConversation/add';
  static String editMask = '/userProfile/update';
  static String editMode = '/aiChatConversation/editMode';
  static const String resetSession = '/aiChatConversation/reset';
  static String sendMsg = '/v2/message/conversation/ask/h';
  static const String updateUserInfo = '/v2/appUser/updateUserInfo';
  static const String genRandomOne = '/v2/characterMedia/getByRole/randomOne';
  static const String voiceChat = '/voices/chat';
  static const String styleConf = '/getStyleConfig';
  static const String roleTag = '/v2/characterProfile/tags';
  static const String momentsList = '/moments/getAll';
  static const String minusGems = '/v2/appUser/minusGems';
  static const String messageList = '/v2/history/getAll';
  static String supportLangs = '/translate/languages';
  static String unlockImage = '/v2/characterProfile/unlockImage';
  static String eventParams = '/v2/user/upinfo';
  static String continueWrite = '/v2/message/resume/h';
  static String deleteMask = '/userProfile/del';
  static const String verifyAndOrder = '/pay/google/verify';
  static const String cancelCollectRole = '/v2/characterProfile/cancelCollect';
  static String chatLevelConfig = '/system/chatLevelConf';
  static String editScene = '/v2/message/conversation/change';
  static const String deleteSession = '/aiChatConversation/delete';
  static const String createAndOrder = '/pay/google/create';
  static const String collectList = '/v2/characterProfile/collect/list';
  static const String getRoleById = '/v2/characterProfile/getById';
  static String saveMsg = '/v2/history/saveMessage';
  static const String upImageForAiImage = '/v2/getUndressWith';
  static const String undrCharacter = '/isNaked/undressOutcome';
  static String createMask = '/userProfile/add';
  static String addGems = '/v2/appUser/plusGems';
  static const String aiGetHistroy = '/noDressHis/getAll';
  static String getMaskList = '/userProfile/getAll';
  static const String roleList = '/v2/characterProfile/getAll';
  static String editMsg = '/v2/message/editMsg';
  static const String createIosOrder = '/rechargeOrders/createOrder';
  static String translate = '/translate';
  static const String aiVideoResult = '/getUndressWithVideoResult';
  static const String register = '/v2/user/device/register';
  static String chatLevel = '/aiChatConversation/getChatLevel';
  static const String splashRandomRole = '/platformConfig/getRecommendRole';
  static String getPriceConfig = '/system/price/config';
  static String changeMask = '/v2/message/conversation/changeArchive';
  static const String verifyIosReceipt = '/rechargeOrders/finishOrder';
  static String signIn = '/signin';
  static String skuList = '/platformConfig/getAllSku';
  static const String upImageForAiVideo = '/getUndressWithVideo';
  static const String sessionList = '/aiChatConversation/list';
  static const String getUserInfo = '/v2/appUser/getByDeviceId/user';
  static String resendMsg = '/v2/message/resend/h';
  static String aiphoto = '/system/ai/photo/config';
  static String imageStyle = '/creationStyleOptions/getAll';
  static const String detailOptionsUrl = '/creationMoreDetails/getAll';
  // 用户资产
  static String userAssets = '/v2/appUser/assets';
  // 生成头像
  static const String generateAvatarUrl = '/aiPhoto/gen';
  // 生成头像结果
  static const String generateAvatarResultUrl = '/aiPhoto/getGenImg';
  // 头像 AI写作 - 图片提示词
  static const String aiWriteAvatarUrl = '/creationCharacter/aiWrite/img';
  // 生成头像历史记录查询
  static const String generateAvatarHistoryUrl = '/aiPhoto/history';
  //生成头像历史记录总数
  static const String generateAvatarHistoryCountUrl = '/aiPhoto/history/count';

  ///生成头像历史记录删除
  static const String generateAvatarHistoryDeleteUrl =
      '/aiPhoto/history/delete';
}
