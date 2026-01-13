import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../../main.dart';

class SALoginService extends GetxService {
  bool _loadingState = false;

  final gemBalance = 0.obs;
  final vipStatus = false.obs;
  final messageUnread = 0.obs;
  final translateAuto = false.obs;

  final imgCreationCount = 0.obs;
  final videoCreationCount = 0.obs;

  SAUsersModel? _currentUser;

  SAUsersModel? get currentUser => _currentUser;

  /// 各种价格配置
  SAPricesModel? configPrice;

  /// 支持的语言列表
  Map<String, dynamic>? appLangs;

  final sessionLang = Rxn<SALang>();

  Future<void> performRegister() async {
    try {
      final userCached = SA.storage.user;
      if (userCached != null) {
        _currentUser = userCached;
        return;
      }
      final userNew = await Api.register();
      if (userNew != null) {
        saveUserInfo(userNew);
      }
    } catch (e) {
      log.e('performRegister error: $e');
    }
  }

  Future<void> fetchUserInfo() async {
    if (_loadingState) {
      return;
    }
    _loadingState = true;
    try {
      final userCached = SA.storage.user;
      if (userCached == null) {
        await performRegister();
      }
      final userFetched = await Api.getUserInfo();
      if (userFetched != null) {
        saveUserInfo(userFetched);
      }
    } catch (e) {
      log.e('fetchUserInfo error: $e');
    }
    _loadingState = false;
  }

  Future modifyUserNickname(String nickname) async {
    final userId = _currentUser?.id;
    if (userId == null) {
      return _currentUser;
    }
    try {
      final payload = {'id': userId, 'nickname': nickname};
      final success = await Api.updateUserInfo(payload);
      if (success) {
        _currentUser?.nickname = nickname;
        saveUserInfo(_currentUser);
      }
    } catch (e) {
      log.e('modifyUserNickname error: $e');
    }
  }

  void saveUserInfo(SAUsersModel? user) async {
    if (user == null) {
      log.e(' save user is null');
      return;
    }
    _currentUser = user;

    await SA.storage.setUser(user);

    gemBalance.value = user.gems ?? 0;
    vipStatus.value = (user.subscriptionEnd ?? 0) > DateTime.now().millisecondsSinceEpoch;
    translateAuto.value = user.autoTranslate ?? false;
    imgCreationCount.value = user.createImg;
    videoCreationCount.value = user.createVideo;
    sessionLang.value = matchUserLang();
  }

  bool checkBalance(ConsumeFrom from) {
    return gemBalance.value >= from.gems;
  }

  Future<void> deductBalance(ConsumeFrom from) async {
    try {
      final newBalance = await Api.consumeReq(from.gems, from.name);
      gemBalance.value = newBalance;
    } catch (e) {
      log.e('$e');
    }
  }

  Future loadPriceConfig() async {
    if (configPrice != null) return;
    var config = await Api.getPriceConfig();
    if (config == null) return;
    configPrice = config;
  }

  // 后台更新语言数据的方法
  void _updateAppLangsInBackground() {
    Api.getAppLangs()
        .then((data) {
          if (data != null) {
            appLangs = data;
            SA.storage.setAppLangs(json.encode(data));
            log.d('Updated appLangs from API in background: ${appLangs?.keys}');
          }
        })
        .catchError((e) {
          log.e('Background update appLangs failed: $e');
        });
  }

  Future<void> loadAppLangs() async {
    try {
      // 先从缓存获取数据
      final cachedData = SA.storage.appLangs;
      if (cachedData != null) {
        appLangs = json.decode(cachedData);
        log.d('Loaded appLangs from cache: ${appLangs?.keys}');

        // 如果有缓存，在后台异步更新数据，不阻塞当前调用
        _updateAppLangsInBackground();
        return; // 立即返回，不等待接口请求
      }

      // 如果没有缓存，才等待接口请求
      final data = await Api.getAppLangs();
      if (data != null) {
        appLangs = data;
        SA.storage.setAppLangs(json.encode(data));
        log.d('Loaded appLangs from API');
      }
    } catch (e) {
      log.e(e.toString());
    }
  }

  SALang matchUserLang() {
    // 获取所有可用语言列表
    final allLangs = _getAllAvailableLangs();
    if (allLangs.isEmpty) {
      return SALang(label: 'English', value: 'en');
    }

    // 根据当前语言设置更新 lang
    String? userLang = currentUser?.targetLanguage;

    // 如果用户没有设置语言，则使用手机语言来匹配
    if (userLang == null || userLang.isEmpty) {
      return _matchDeviceLanguage(allLangs);
    } else {
      return _matchUserLanguage(userLang, allLangs);
    }
  }

  /// 匹配设备语言
  SALang _matchDeviceLanguage(List<SALang> allLangs) {
    final locale = Get.deviceLocale ?? const Locale('en', 'US');

    // 1. 优先匹配完整的语言标签 (例如: zh-CN, en-US)
    final fullTag = locale.toLanguageTag();
    for (var lang in allLangs) {
      if (lang.value == fullTag) {
        return lang;
      }
    }

    // 2. 匹配 locale.toString() 格式 (例如: zh_CN)
    final localeString = locale.toString();
    for (var lang in allLangs) {
      if (lang.value == localeString) {
        return lang;
      }
    }

    // 3. 匹配语言代码 (例如: zh, en)
    final languageCode = locale.languageCode;
    for (var lang in allLangs) {
      if (lang.value == languageCode) {
        return lang;
      }
    }

    // 4. 匹配语言代码前缀 (例如: zh-CN 匹配 zh)
    for (var lang in allLangs) {
      if (lang.value?.startsWith('$languageCode-') == true || lang.value?.startsWith('${languageCode}_') == true) {
        return lang;
      }
    }

    // 5. 默认返回英语
    return _findDefaultLanguage(allLangs);
  }

  /// 匹配用户设置的语言
  SALang _matchUserLanguage(String userLang, List<SALang> allLangs) {
    // 1. 精确匹配
    for (var lang in allLangs) {
      if (lang.value == userLang) {
        return lang;
      }
    }

    // 2. 如果用户语言包含分隔符，尝试匹配语言代码部分
    if (userLang.contains('-') || userLang.contains('_')) {
      final languageCode = userLang.split(RegExp(r'[-_]')).first;
      for (var lang in allLangs) {
        if (lang.value == languageCode) {
          return lang;
        }
      }

      // 3. 尝试匹配相同语言代码的其他变体
      for (var lang in allLangs) {
        if (lang.value?.startsWith('$languageCode-') == true || lang.value?.startsWith('${languageCode}_') == true) {
          return lang;
        }
      }
    } else {
      // 3. 如果用户语言是纯语言代码，尝试匹配带国家代码的变体
      for (var lang in allLangs) {
        if (lang.value?.startsWith('$userLang-') == true || lang.value?.startsWith('${userLang}_') == true) {
          return lang;
        }
      }
    }

    // 4. 都没有匹配到，返回默认语言
    return _findDefaultLanguage(allLangs);
  }

  /// 查找默认语言 (优先英语)
  SALang _findDefaultLanguage(List<SALang> allLangs) {
    // 优先查找英语
    for (var lang in allLangs) {
      if (lang.value == 'en' || lang.value == 'en-US') {
        return lang;
      }
    }

    // 最后的兜底
    return SALang(label: 'English', value: 'en');
  }

  /// 获取所有可用语言列表
  List<SALang> _getAllAvailableLangs() {
    final appLangsData = appLangs;
    if (appLangsData == null) return [];

    List<SALang> allLangs = [];

    // 遍历每个字母分组
    appLangsData.forEach((key, value) {
      if (value is List) {
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            try {
              final lang = SALang.fromJson(item);
              if (lang.label != null && lang.value != null) {
                allLangs.add(lang);
              }
            } catch (e) {
              log.e('Error parsing lang: $e');
            }
          }
        }
      }
    });

    return allLangs;
  }
}
