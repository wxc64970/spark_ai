import 'dart:convert';
import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:uuid/uuid.dart';

class SALocalStorage extends GetxService {
  late SharedPreferences _prefs;

  final _secureStorage = const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true), iOptions: IOSOptions());

  SharedPreferences get prefs => _prefs;

  /// 公开的初始化方法，供外部调用
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // String 操作
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Bool 操作
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Int 操作
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Double 操作
  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // StringList 操作
  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // 删除和清空
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs.clear();
  }

  // 检查是否存在
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // 获取所有 key
  Set<String> getKeys() {
    return _prefs.getKeys();
  }

  // ==================== 安全存储功能 ====================

  /// 获取设备ID
  ///
  /// [isOrigin] 是否返回原始设备ID（不带平台前缀）
  /// 返回设备唯一标识
  Future<String> getDeviceId({bool isOrigin = false}) async {
    String? deviceId = await _secureStorage.read(key: SAAppConstants.keyDeviceId);

    if (deviceId == null || deviceId.isEmpty) {
      deviceId = await _generateDeviceId();
      await _secureStorage.write(key: SAAppConstants.keyDeviceId, value: deviceId);
    }

    if (isOrigin) {
      return deviceId;
    }

    // 添加平台前缀
    final platform = EnvConfig.platform;
    return '$platform.$deviceId';
  }

  /// 生成设备ID
  Future<String> _generateDeviceId() async {
    String generateUuid() {
      return const Uuid().v4();
    }

    try {
      if (Platform.isAndroid) {
        const androidIdPlugin = AndroidId();
        final String? androidId = await androidIdPlugin.getId();
        return androidId ?? generateUuid();
      } else if (Platform.isIOS) {
        final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor?.isNotEmpty == true ? iosInfo.identifierForVendor! : generateUuid();
      } else {
        return generateUuid();
      }
    } catch (e) {
      debugPrint('SALocalStorage._generateDeviceId ❌: $e');
      return generateUuid();
    }
  }

  // ==================== 业务数据存储 ====================

  bool get isSAB {
    return _prefs.getBool(SAAppConstants.keyClkStatus) ?? false;
  }

  Future<bool> setIsSAB(bool value) async {
    return await _prefs.setBool(SAAppConstants.keyClkStatus, value);
  }

  /// 应用重启标识
  bool get isRestart {
    return _prefs.getBool(SAAppConstants.keyAppRestart) ?? false;
  }

  Future<bool> setRestart(bool value) async {
    return await _prefs.setBool(SAAppConstants.keyAppRestart, value);
  }

  //是否好评弹窗
  bool get isShowGoodCommentDialog {
    return _prefs.getBool(SAAppConstants.goodRateShowTime) ?? false;
  }

  bool get isShowGoodCommentDialog1 {
    return _prefs.getBool(SAAppConstants.goodRateShowTime1) ?? false;
  }

  bool get isShowGoodCommentDialog2 {
    return _prefs.getBool(SAAppConstants.goodRateShowTime2) ?? false;
  }

  Future<bool> setShowGoodCommentDialog(bool value) async {
    return await _prefs.setBool(SAAppConstants.goodRateShowTime, value);
  }

  Future<bool> setShowGoodCommentDialog1(bool value) async {
    return await _prefs.setBool(SAAppConstants.goodRateShowTime1, value);
  }

  Future<bool> setShowGoodCommentDialog2(bool value) async {
    return await _prefs.setBool(SAAppConstants.goodRateShowTime2, value);
  }

  Map<String, int> get messageCountMap {
    final dynamic storedValue = _prefs.getString('feg4543dsafdg3');
    if (storedValue == null || storedValue.isEmpty) {
      return {}; // 无数据时返回空 Map
    }
    // 将 JSON 字符串转回 Map，并强制类型为 <String, int>
    final dynamic jsonMap = json.decode(storedValue);
    return Map<String, int>.from(jsonMap);
  }

  set messageCountMap(Map<String, int> value) => _prefs.setString('feg4543dsafdg3', json.encode(value));

  /// 聊天背景图片路径
  String get chatBgImagePath {
    return _prefs.getString(SAAppConstants.keyChatBgPath) ?? '';
  }

  Future<bool> setChatBgImagePath(String value) async {
    return await _prefs.setString(SAAppConstants.keyChatBgPath, value);
  }

  /// 用户信息
  SAUsersModel? get user {
    final jsonString = _prefs.getString(SAAppConstants.keyUserData);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return SAUsersModel.fromJson(json);
    } catch (e) {
      debugPrint('SALocalStorage.user getter ❌: $e');
      return null;
    }
  }

  Future<bool> setUser(SAUsersModel? value) async {
    if (value == null) {
      return true;
    }

    try {
      final jsonString = jsonEncode(value.toJson());
      return await _prefs.setString(SAAppConstants.keyUserData, jsonString);
    } catch (e) {
      debugPrint('SALocalStorage.setUser ❌: $e');
      return false;
    }
  }

  /// 发送消息计数
  int get sendMsgCount {
    return _prefs.getInt(SAAppConstants.keySendMsgCount) ?? 0;
  }

  Future<bool> setSendMsgCount(int value) async {
    return await _prefs.setInt(SAAppConstants.keySendMsgCount, value);
  }

  /// 评分计数
  int get rateCount {
    return _prefs.getInt(SAAppConstants.keyRateCount) ?? 0;
  }

  Future<bool> setRateCount(int value) async {
    return await _prefs.setInt(SAAppConstants.keyRateCount, value);
  }

  /// 语言设置
  String get locale {
    return _prefs.getString(SAAppConstants.keyLocale) ?? '';
  }

  Future<bool> setLocale(String value) async {
    return await _prefs.setString(SAAppConstants.keyLocale, value);
  }

  /// 翻译对话框显示标识
  bool get hasShownTranslationDialog {
    return _prefs.getBool(SAAppConstants.keyTranslationDialog) ?? false;
  }

  Future<bool> setShownTranslationDialog(bool value) async {
    return await _prefs.setBool(SAAppConstants.keyTranslationDialog, value);
  }

  /// 安装时间戳
  int get installTime {
    return _prefs.getInt(SAAppConstants.keyInstallTime) ?? 0;
  }

  Future<bool> setInstallTime(int value) async {
    return await _prefs.setInt(SAAppConstants.keyInstallTime, value);
  }

  /// 上次奖励日期
  int get lastRewardDate {
    return _prefs.getInt(SAAppConstants.keyLastRewardDate) ?? 0;
  }

  Future<bool> setLastRewardDate(int value) async {
    return await _prefs.setInt(SAAppConstants.keyLastRewardDate, value);
  }

  /// 首次点击聊天输入框标识
  bool get firstClickChatInputBox {
    return _prefs.getBool(SAAppConstants.keyFirstClickInput) ?? true;
  }

  Future<bool> setFirstClickChatInputBox(bool value) async {
    return await _prefs.setBool(SAAppConstants.keyFirstClickInput, value);
  }

  /// 翻译消息ID列表
  Set<String> get translationMsgIds {
    final List<String>? data = _prefs.getStringList(SAAppConstants.keyTranslationMsgIds);
    return data?.toSet() ?? <String>{};
  }

  Future<bool> setTranslationMsgIds(Set<String> value) async {
    return await _prefs.setStringList(SAAppConstants.keyTranslationMsgIds, value.toList());
  }

  /// 支持的语言列表
  String? get appLangs {
    final data = _prefs.getString(SAAppConstants.appLangs);
    return data;
  }

  Future<bool> setAppLangs(String? value) async {
    return await _prefs.setString(SAAppConstants.appLangs, value ?? '');
  }
}
