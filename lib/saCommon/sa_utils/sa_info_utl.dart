import 'dart:io';
import 'dart:ui';

import 'package:adjust_sdk/adjust.dart';
import 'package:android_id/android_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:carrier_info/carrier_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../main.dart';

class SAInfoUtils {
  static Future<PackageInfo> packageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  static Future<String> version() async {
    return (await packageInfo()).version;
  }

  static Future<String> buildNumber() async {
    return (await packageInfo()).buildNumber;
  }

  static Future<String> packageName() async {
    return (await packageInfo()).packageName;
  }

  static Future<String> getIdfa() async {
    if (!Platform.isIOS) {
      return '';
    }
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      log.d('trackingAuthorizationStatus: $status');

      if (status == TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(milliseconds: 200));
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
      final idfa = await AppTrackingTransparency.getAdvertisingIdentifier();
      log.d('idfa: $idfa');
      return idfa;
    } catch (e) {
      log.e('getIdfa error: $e');
      return '';
    }
  }

  /// android_id
  static Future<String> getAndroidId() async {
    try {
      final String? androidId = await const AndroidId().getId();
      return androidId ?? '';
    } catch (e) {
      log.e('getAndroidId error: $e');
      return '';
    }
  }

  // 获取Adjust ID，带超时和错误处理
  static Future<String> getAdid() async {
    try {
      final adid = await Adjust.getAdid().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          log.w('getAdid: onTimeout');
          return '';
        },
      );
      return adid ?? '';
    } catch (e) {
      log.e('getAdid error: $e');
      return '';
    }
  }

  // 获取Google AdId，带超时和错误处理
  static Future<String> getGoogleAdId() async {
    if (!Platform.isIOS) {
      return '';
    }
    try {
      final gpsAdid = await Adjust.getGoogleAdId().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          log.w('getGoogleAdId:onTimeout');
          return '';
        },
      );
      return gpsAdid ?? '';
    } catch (e) {
      log.e('getGoogleAdId error: $e');
      return '';
    }
  }

  // 获取idfv
  static Future<String> getIdfv() async {
    if (!Platform.isIOS) {
      return '';
    }
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? '';
    } catch (e) {
      log.e('getIdfv error: $e');
      return '';
    }
  }

  // 获取Adjust IDFV（备用方法）
  static Future<String> getAdjustIdfv() async {
    try {
      final idfv = await Adjust.getIdfv().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          log.w('getAdjustIdfv: onTimeout');
          return '';
        },
      );
      return idfv ?? '';
    } catch (e) {
      log.e('getAdjustIdfv error: $e');
      return '';
    }
  }

  // device_model
  static Future<String> getDeviceModel() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    }
    if (Platform.isIOS) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    }
    return '';
  }

  // 手机厂商
  static Future<String> getDeviceManufacturer() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.manufacturer;
    }
    if (Platform.isIOS) {
      return 'Apple';
    }
    return '';
  }

  // 操作系统版本
  static Future<String> getOsVersion() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.release;
    }
    if (Platform.isIOS) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    }
    return '';
  }

  static Future<bool> isLimitAdTrackingEnabled() async {
    if (Platform.isIOS) {
      final attStatus = await AppTrackingTransparency.trackingAuthorizationStatus;
      return attStatus == TrackingStatus.authorized;
    } else if (Platform.isAndroid) {
      final isLimitAdTracking = await Adjust.isEnabled();
      return !isLimitAdTracking; // Android返回的是是否启用跟踪，取反得到是否限制
    }
    return false;
  }

  static Future<String> getIpAddress() async {
    var interfaces = await NetworkInterface.list();
    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          // print('IP Address: ${addr.address}');
          return addr.address;
        }
      }
    }
    return '';
  }

  static int getBasicTimeZone() {
    // 获取当前时间
    DateTime now = DateTime.now();
    // 获取时区偏移（例如：中国时区为 8 小时，返回 Duration(hours: 8)）
    Duration offset = now.timeZoneOffset;
    // 转换为小时数
    double offsetHours = offset.inHours.toDouble() + offset.inMinutes.remainder(60) / 60;

    // print("当前时区与 UTC 偏移：$offsetHours 小时");
    // print("时区偏移详细信息：$offset");
    return offsetHours.toInt();
  }

  /// 检查设备时区是否为中国时区
  /// 返回 true 如果时区为中国时区（GMT+8 或 Asia/Shanghai 等）
  static bool isChinaTimeZone() {
    try {
      final now = DateTime.now();

      // 检查时区偏移是否为 +8 小时 (GMT+8)
      // 中国大陆统一使用 UTC+8 时区
      final offset = now.timeZoneOffset;
      final offsetHours = offset.inHours;

      if (offsetHours == 8) {
        return true;
      }

      // 获取时区名称进行额外检查
      final timeZoneName = now.timeZoneName.toLowerCase();

      // 检查时区名称是否包含中国相关标识
      final chineseTimeZones = [
        'asia/shanghai', // 上海（中国标准时间）
        'asia/chongqing', // 重庆
        'asia/harbin', // 哈尔滨
        'asia/urumqi', // 乌鲁木齐
        'asia/beijing', // 北京
        'asia/hong_kong', // 香港
        'asia/macau', // 澳门
        'cst', // China Standard Time
        'china', // 中国
        'prc', // People's Republic of China
        'gmt+8', // GMT+8
        'utc+8', // UTC+8
      ];

      for (var timezone in chineseTimeZones) {
        if (timeZoneName.contains(timezone)) {
          return true;
        }
      }

      return false;
    } catch (e) {
      log.e('isChinaTimeZone error: $e');
      return false;
    }
  }

  // 生成自定义 User-Agent
  static String userAgent() {
    if (Platform.isAndroid) {
      // 示例：基于默认 UA 移除 ;wv（也可直接写死完整 UA）
      // 注意：实际使用中可先获取默认 UA 再处理，避免硬编码兼容性问题
      return "Mozilla/5.0 (Linux; Android 13; SM-G998B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.5735.196 Mobile Safari/537.36";
    } else if (Platform.isIOS) {
      return "Mozilla/5.0 (iPhone; CPU iPhone OS 16_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148; CustomApp/1.0.0";
    }
    return '';
  }

  /// 检查设备当前的系统语言是否为中文且地区为中国
  /// 返回 true 如果语言为中文（zh 或 zh-Hans）且地区为 CN
  bool isChineseInChina() {
    final locale = Get.deviceLocale ?? const Locale('en', 'US');

    // 检查语言代码是否为中文 (zh)
    final isChineseLanguage = locale.languageCode == 'zh';

    // 检查地区代码是否为中国 (CN)
    final isChinaRegion = locale.countryCode == 'CN';

    return isChineseLanguage || isChinaRegion;
  }

  /// 检查SIM卡运营商是否为中国运营商
  /// 返回 true 如果运营商为中国移动、中国联通或中国电信
  static Future<bool> isChineseCarrier() async {
    try {
      String mcc = '';
      String carrierName = '';

      if (Platform.isAndroid) {
        // Android 平台
        final androidInfo = await CarrierInfo.getAndroidInfo();
        if (androidInfo != null && androidInfo.telephonyInfo.isNotEmpty) {
          final telephony = androidInfo.telephonyInfo.first;
          mcc = telephony.mobileCountryCode;
          carrierName = telephony.carrierName;
        }
      } else if (Platform.isIOS) {
        // iOS 平台
        final iosInfo = await CarrierInfo.getIosInfo();
        if (iosInfo.carrierData.isNotEmpty) {
          final carrier = iosInfo.carrierData.first;
          mcc = carrier.mobileCountryCode;
          carrierName = carrier.carrierName;
        }
      }

      // 检查 MCC (Mobile Country Code)
      // 中国的 MCC 是 460
      if (mcc == '460') {
        return true;
      }

      // 也可以通过运营商名称判断
      final lowerCarrierName = carrierName.toLowerCase();

      // 中国三大运营商的英文和中文名称
      final chineseCarriers = [
        'china mobile', // 中国移动
        'china unicom', // 中国联通
        'china telecom', // 中国电信
        '中国移动',
        '中国联通',
        '中国电信',
        'cmcc', // China Mobile Communications Corporation
        'cucc', // China United Network Communications
        'ctcc', // China Telecommunications Corporation
      ];

      for (var carrier in chineseCarriers) {
        if (lowerCarrierName.contains(carrier.toLowerCase())) {
          return true;
        }
      }

      return false;
    } catch (e) {
      log.e('isChineseCarrier error: $e');
      return false;
    }
  }
}
