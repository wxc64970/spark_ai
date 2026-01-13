import 'package:spark_ai/saCommon/index.dart';

class SAAppConstants {
  // API相关常量
  // 应用名称
  static const appName = 'Spark AI';
  static const String baseUrl = '';
  static const String apiVersion = 'v1';
  static const String apiPrefix = '$baseUrl/$apiVersion';

  // 本地存储键名
  static const String keyUserInfo = 'Qb3kX7p2';
  static const String keyThemeMode = 'Zn5sG1r4';
  static const String keyLanguage = 'Kf2dM8w5';

  // 安全存储键名（FlutterSecureStorage）
  /// 设备ID
  static const String keyDeviceId = 'Xj7bP3t6';

  // SharedPreferences 键名
  /// CLK状态
  static const String keyClkStatus = 'Tm4gW9n1';

  /// 应用重启标识
  static const String keyAppRestart = 'Hn6qY2v7';

  /// 聊天背景图片路径
  static const String keyChatBgPath = 'Lx3rV5z8';

  /// 用户信息（JSON）
  static const String keyUserData = 'Sd8mK1j4';

  /// 发送消息计数
  static const String keySendMsgCount = 'Rp2tF6h3';

  /// 评分计数
  static const String keyRateCount = 'Bv9gN4s7';

  /// 语言设置
  static const String keyLocale = 'Yc5xL2w9';

  /// 翻译对话框显示标识
  static const String keyTranslationDialog = 'Mg7pR5b1';

  /// 安装时间戳
  static const String keyInstallTime = 'Df3zQ8k6';

  /// 上次奖励日期
  static const String keyLastRewardDate = 'Wj6hP2m5';

  /// 首次点击聊天输入框标识
  static const String keyFirstClickInput = 'Nk4sV7g3';

  /// 翻译消息ID列表
  static const String keyTranslationMsgIds = 'Fh8rT1x9';

  /// app言列表
  static const String appLangs = 'Pm2wG5d7';

  // 分页相关
  static const int defaultPageSize = 10;

  //好评弹窗
  static const String goodRateShowTime = 'Ej5bK3n8';

  //好评弹窗1
  static const String goodRateShowTime1 = 'Cg7tX4r2';

  //好评弹窗2
  static const String goodRateShowTime2 = 'Vd3mF6s1';
}

enum VipFrom {
  locktext,
  lockpic,
  lockvideo,
  lockaudio,
  send,
  homevip,
  mevip,
  chatvip,
  launch,
  relaunch,
  viprole,
  call,
  acceptcall,
  creimg,
  crevideo,
  undrphoto,
  postpic,
  postvideo,
  undrchar,
  videochat,
  trans,
  dailyrd,
  scenario,
}

enum ConsumeFrom { home, chat, send, profile, text, audio, call, unlcokText, undr, creaimg, creavideo, album, aiphoto, img2v, mask }

enum RewardType { dislike, accept, like, unknown }

String getRewardTypeDesc(RewardType type) {
  switch (type) {
    case RewardType.dislike:
      return SATextData.dislike;
    case RewardType.accept:
      return SATextData.accept;
    case RewardType.like:
      return SATextData.love;
    case RewardType.unknown:
      return '';
  }
}

extension GlobFromExt on ConsumeFrom {
  int get gems {
    switch (this) {
      case ConsumeFrom.text:
        return SA.login.configPrice?.textMessage ?? 2;

      case ConsumeFrom.call:
        return SA.login.configPrice?.callAiCharacters ?? 10;
      default:
        return 0;
    }
  }
}

enum MsgLockLevel {
  normal,
  private;

  String get value => name.toUpperCase();
}

enum CallState { calling, incoming, listening, answering, answered, micOff }

enum Gender {
  male(0),
  female(1),
  nonBinary(2),
  unknown(-1);

  final int code;
  const Gender(this.code);

  static final Map<int, Gender> _codeMap = {for (var g in Gender.values) g.code: g};

  /// 根据数值反查 Gender
  static Gender fromValue(int? code) => _codeMap[code] ?? Gender.unknown;

  String get display {
    switch (this) {
      case Gender.male:
        return SATextData.male;
      case Gender.female:
        return SATextData.female;
      case Gender.nonBinary:
        return SATextData.nonBinary;
      case Gender.unknown:
        return 'unknown';
    }
  }

  String get icon {
    switch (this) {
      case Gender.male:
        return 'assets/images/sa_41.png';
      case Gender.female:
        return 'assets/images/sa_40.png';
      case Gender.nonBinary:
        return 'assets/images/sa_42.png';
      case Gender.unknown:
        return 'assets/images/sa_42.png';
    }
  }
}
