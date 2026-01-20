import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:uuid/v4.dart';
import '../models/sa_ad_log_model.dart';
import 'sa_ad_log_service.dart';

class SAAdLogEvent {
  static final SAAdLogEvent _instance = SAAdLogEvent._internal();
  factory SAAdLogEvent() => _instance;
  SAAdLogEvent._internal() {
    _startUploadTimer();
    _startRetryTimer();
  }

  final _adLogService = AdLogService();
  Timer? _uploadTimer;
  Timer? _retryTimer;

  void _startUploadTimer() {
    _uploadTimer?.cancel();
    _uploadTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _uploadPendingLogs();
    });
  }

  void _startRetryTimer() {
    _retryTimer?.cancel();
    _retryTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _retryFailedLogs();
    });
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.isDebugMode ? 'https://test-dominion.kiraassociates.com/bravery/obdurate' : 'https://dominion.kiraassociates.com/marmoset/indulge/final',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ),
  );

  String uuid() {
    String uuid = const UuidV4().generate();
    return uuid;
  }

  // 获取通用参数
  Future<Map<String, dynamic>?> _getCommonParams() async {
    final deviceId = await await SA.storage.getDeviceId(isOrigin: true);
    final deviceModel = await SAInfoUtils.getDeviceModel();
    final manufacturer = await SAInfoUtils.getDeviceManufacturer();
    final idfv = await Adjust.getIdfv();
    final version = await SAInfoUtils.version();
    final os = Platform.isIOS ? 'ibis' : 'behead';
    final osVersion = await SAInfoUtils.getOsVersion();
    final gaid = Platform.isAndroid ? await Adjust.getGoogleAdId() : null;

    return {
      "godson": {"regina": deviceId, "day": uuid(), "folktale": deviceModel, "erode": Get.locale.toString(), "flaunt": manufacturer, "chasm": idfv},
      "avis": {"stirling": version, "grille": os, "kovacs": "mcc"},
      "ladle": {"mystify": "com.rolekria.chat", "totem": DateTime.now().millisecondsSinceEpoch},
      "franca": {"innovate": Platform.isAndroid ? deviceId : null, "razor": gaid, "czarina": osVersion},
    };
  }

  Future<void> logInstallEvent() async {
    try {
      var data = await _getCommonParams() ?? {};

      final build = await SAInfoUtils.buildNumber();
      final isLimitAdTrackingEnabled = await SAInfoUtils.isLimitAdTrackingEnabled();
      final pour = isLimitAdTrackingEnabled ? 'adjust' : 'gherkin';

      var params = {
        "priam": {
          "hilarity": "build.$build",
          "incest": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36",
          "pour": pour,
          "incant": DateTime.now().millisecondsSinceEpoch,
          "rangy": DateTime.now().millisecondsSinceEpoch,
          "ink": DateTime.now().millisecondsSinceEpoch,
          "weasel": DateTime.now().millisecondsSinceEpoch,
          "dirt": DateTime.now().millisecondsSinceEpoch,
          "sticky": DateTime.now().millisecondsSinceEpoch,
        },
      };
      data.addAll(params);

      final logModel = AdLogModel(eventType: 'install', data: jsonEncode(data), createTime: DateTime.now().millisecondsSinceEpoch, id: uuid());
      await _adLogService.insertLog(logModel);
      log.d('[ad]log InstallEvent saved to database');
    } catch (e) {
      log.e('[ad]log logEvent error: $e');
    }
  }

  Future<void> logSessionEvent() async {
    try {
      var data = await _getCommonParams();

      if (data == null) {
        return;
      }
      String logId = data["godson"]["day"];

      data['wow'] = "poet";

      final logModel = AdLogModel(id: logId, eventType: 'session', data: jsonEncode(data), createTime: DateTime.now().millisecondsSinceEpoch);
      await _adLogService.insertLog(logModel);
      log.d('[ad]log logSessionEvent saved to database');
    } catch (e) {
      log.e('logEvent error: $e');
    }
  }

  Future<void> logAdEvent({required String adid, required String placement, required String adType, double? value, String? currency}) async {
    try {
      var data = await _getCommonParams();
      if (data == null) {
        return;
      }
      final logId = data["godson"]["day"];
      data['briny'] = {"cry": value?.toInt() ?? 0, "dragon": currency, "varistor": "admob", "acolyte": "admob", "pickle": adid, "drawl": placement, "dupe": adType};
      final logModel = AdLogModel(eventType: 'ad', data: jsonEncode(data), createTime: DateTime.now().millisecondsSinceEpoch, id: logId);
      await _adLogService.insertLog(logModel);
      log.d('[ad]log logAdEvent saved to database');
    } catch (e) {
      log.e('[ad]log logEvent error: $e');
    }
  }

  Future<void> logCustomEvent({required String name, required Map<String, dynamic> params}) async {
    try {
      var data = await _getCommonParams();
      if (data == null) {
        return;
      }
      String logId = data["godson"]["day"];

      data['wow'] = name;
      data['solve'] = params;
      final logModel = AdLogModel(eventType: 'custom', data: jsonEncode(data), createTime: DateTime.now().millisecondsSinceEpoch, id: logId);
      await _adLogService.insertLog(logModel);
      log.d('[ad]log logCustomEvent saved to database');
    } catch (e) {
      log.e('[ad]log logCustomEvent error: $e');
    }
  }

  Future<void> _uploadPendingLogs() async {
    try {
      final logs = await _adLogService.getUnuploadedLogs();
      if (logs.isEmpty) return;

      final List<dynamic> dataList = logs.map((log) => jsonDecode(log.data)).toList();

      final res = await _dio.post('', data: dataList);

      if (res.statusCode == 200) {
        await _adLogService.markLogsAsSuccess(logs);
        log.d('[ad]log Batch upload success: ${logs.length} logs');
      } else {
        log.e('[ad]log Batch upload error: ${res.statusMessage}');
      }
    } catch (e) {
      log.e('[ad]log Batch upload catch: $e');
    }
  }

  Future<void> _retryFailedLogs() async {
    try {
      final failedLogs = await _adLogService.getFailedLogs();
      if (failedLogs.isEmpty) return;

      final List<dynamic> dataList = failedLogs.map((log) => jsonDecode(log.data)).toList();
      final res = await _dio.post('', data: dataList);

      if (res.statusCode == 200) {
        await _adLogService.markLogsAsSuccess(failedLogs);
        log.d('[ad]log Retry success for: ${failedLogs.length}');
      } else {
        final ids = failedLogs.map((e) => e.id).toList();
        log.e('[ad]log Retry failed for: $ids');
      }
    } catch (e) {
      log.e('[ad]log Retry failed catch: $e');
    }
  }
}
