// 抽象的策略接口
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart' show Box, Hive;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:spark_ai/saCommon/index.dart';
import 'package:uuid/v7.dart';

import '../../main.dart';

void SAlogEvent(String name, {Map<String, Object>? parameters}) {
  try {
    log.d('[SAlogEvent]: $name, $parameters');
    if (SAThirdPartyService.isFirebaseInitialized) {
      FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
    }
    SAAppLogEvent().logCustomEvent(name: name, params: parameters ?? {});
  } catch (e) {
    log.e('FirebaseAnalytics: $e');
  }
}

/// ----------------------------------------------------------------------
///
/// ----------------------------------------------------------------------

/// 日志数据库服务
class SALogEventDBService {
  static final SALogEventDBService _instance = SALogEventDBService._internal();
  factory SALogEventDBService() => _instance;
  SALogEventDBService._internal();

  static Box<SAEventData>? _box;
  static const String boxName = 'events_logs';
  static int _sequenceCounter = 0;
  static int _lastTimestamp = 0;

  Future<Box<SAEventData>> get box async {
    if (_box != null) return _box!;
    _box = await _initBox();
    return _box!;
  }

  Future<Box<SAEventData>> _initBox() async {
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(EventDataAdapter());
    }
    return await Hive.openBox<SAEventData>(boxName);
  }

  /// 生成唯一的时间戳，确保严格递增
  static int generateUniqueTimestamp() {
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    if (currentTimestamp > _lastTimestamp) {
      // 如果时间戳大于上次，重置序列号
      _lastTimestamp = currentTimestamp;
      _sequenceCounter = 0;
      return currentTimestamp;
    } else {
      // 如果时间戳相同或更小，则使用上次时间戳+递增序列号
      _sequenceCounter++;
      final uniqueTimestamp = _lastTimestamp + _sequenceCounter;
      return uniqueTimestamp;
    }
  }

  /// 获取当前序列号
  static int get currentSequenceId => _sequenceCounter;

  Future<void> insertLog(SAEventData log) async {
    final box = await this.box;
    return await box.put(log.id, log);
  }

  Future<List<SAEventData>> getUnuploadedLogs({int limit = 10}) async {
    final box = await this.box;
    final unuploadedLogs = box.values.where((log) => !log.isUploaded).toList();
    // 按照createTime排序，确保上传顺序
    unuploadedLogs.sort((a, b) => a.createTime.compareTo(b.createTime));
    return unuploadedLogs.take(limit).toList();
  }

  Future<List<SAEventData>> getFailedLogs({int limit = 10}) async {
    final box = await this.box;
    final failedLogs = box.values.where((log) => !log.isSuccess).toList();
    // 按照createTime排序，确保重试顺序
    failedLogs.sort((a, b) => a.createTime.compareTo(b.createTime));
    return failedLogs.take(limit).toList();
  }

  Future<void> markLogsAsSuccess(List<SAEventData> logs) async {
    final box = await this.box;
    final now = DateTime.now().millisecondsSinceEpoch;
    try {
      for (final log in logs) {
        final updatedLog = SAEventData(
          id: log.id,
          eventType: log.eventType,
          data: log.data,
          isSuccess: true,
          createTime: log.createTime,
          uploadTime: now,
          isUploaded: true,
          sequenceId: log.sequenceId,
        );
        await box.put(log.id, updatedLog);
      }
    } catch (e) {
      throw Exception('Failed to update logs: $e');
    }
  }
}

class SAAppLogEvent {
  static final SAAppLogEvent _instance = SAAppLogEvent._internal();

  factory SAAppLogEvent() => _instance;

  SAAppLogEvent._internal() {
    _startTimersAsync();
  }

  final _adLogService = SALogEventDBService();
  Timer? _uploadTimer;
  Timer? _retryTimer;
  bool _isProcessingUpload = false;
  final uuid = const UuidV7();

  final connectTimeout = const Duration(seconds: 20);
  final receiveTimeout = const Duration(seconds: 20);
  final periodicTime = const Duration(seconds: 10);

  /// 异步启动定时器，避免阻塞应用启动
  void _startTimersAsync() {
    // 使用微任务延迟执行，避免阻塞当前调用栈
    scheduleMicrotask(() {
      _startUploadTimer();
    });
  }

  void _startUploadTimer() {
    _uploadTimer?.cancel();
    _uploadTimer = Timer.periodic(periodicTime, (timer) {
      // 防止重复执行，避免并发问题
      if (!_isProcessingUpload) {
        _uploadPendingLogsAsync();
      }
    });
  }

  /// 异步执行上传操作，避免阻塞定时器
  void _uploadPendingLogsAsync() {
    // 使用微任务异步执行，避免阻塞定时器回调
    scheduleMicrotask(() async {
      try {
        _isProcessingUpload = true;
        await _uploadPendingLogs();
      } catch (e) {
        log.e('[ad]log _uploadPendingLogsAsync error: $e');
      } finally {
        _isProcessingUpload = false;
      }
    });
  }

  // TODO:-
  String get androidURL => EnvConfig.isDebugMode ? "" : "";

  String get iosURL => EnvConfig.isDebugMode ? 'https://test-rondo.chatjoyapp.com/fraser/stallion' : 'https://rondo.chatjoyapp.com/gujarat/automat/gabble';

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Platform.isAndroid ? androidURL : iosURL,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ),
  );

  // 获取通用参数
  Future<Map<String, dynamic>?> _getCommonParams() async {
    try {
      final deviceId = await SA.storage.getDeviceId(isOrigin: true);
      final deviceModel = await SAInfoUtils.getDeviceModel();
      final manufacturer = await SAInfoUtils.getDeviceManufacturer();
      final idfv = await SAInfoUtils.getIdfv();
      final version = await SAInfoUtils.version();
      final osVersion = await SAInfoUtils.getOsVersion();
      final idfa = await SAInfoUtils.getIdfa();
      final snuggly = (Get.deviceLocale ?? const Locale('en_US')).toString();
      // final timeZone = InfoUtils.getBasicTimeZone();

      if (Platform.isAndroid) {
        final gaid = await SAInfoUtils.getGoogleAdId();
        final androidId = await SAInfoUtils.getAndroidId();
        return {"isocline": androidId, "trw": gaid, "piraeus": deviceId};
      }

      final logId = uuid.generate();

      return {
        "fugue": "com.chatj.joyc",
        "roger": "client",
        "mafia": version,
        "piraeus": deviceId,
        "gross": logId,
        "frazzle": DateTime.now().millisecondsSinceEpoch,
        "palliate": manufacturer,
        "frothy": deviceModel,
        "hangdog": osVersion,
        "enter": "mcc",
        "sluice": snuggly,
        "swollen": idfa,
        "cationic": idfv,
      };
    } catch (e) {
      log.e('_getCommonParams error: $e');
      return null;
    }
  }

  Future<void> logInstallEvent() async {
    try {
      var data = await _getCommonParams() ?? {};

      final build = await SAInfoUtils.buildNumber();
      final isLimitAdTrackingEnabled = await SAInfoUtils.isLimitAdTrackingEnabled();
      final agent = SAInfoUtils.userAgent();

      if (Platform.isAndroid) {
        // TODO:-
      } else {
        data["oily"] = "lottery";
        data["cordon"] = "build/$build";
        data["turban"] = agent;
        data["skullcap"] = isLimitAdTrackingEnabled ? 'orb' : 'manse';
        data["pivot"] = DateTime.now().millisecondsSinceEpoch;
        data["quarry"] = DateTime.now().millisecondsSinceEpoch;
        data["mason"] = DateTime.now().millisecondsSinceEpoch;
        data["tablet"] = DateTime.now().millisecondsSinceEpoch;
        data["ehrlich"] = DateTime.now().millisecondsSinceEpoch;
        data["mannitol"] = DateTime.now().millisecondsSinceEpoch;
      }

      final uniqueTimestamp = SALogEventDBService.generateUniqueTimestamp();

      final logModel = SAEventData(eventType: 'install', data: jsonEncode(data), createTime: uniqueTimestamp, id: data.logId, sequenceId: SALogEventDBService.currentSequenceId);
      await _adLogService.insertLog(logModel);
      log.d('[ad]log InstallEvent saved to database');
    } catch (e) {
      log.e('[ad]log SAlogEvent error: $e');
    }
  }

  Future<void> logSessionEvent() async {
    try {
      var data = await _getCommonParams();

      if (data == null) {
        return;
      }

      if (Platform.isAndroid) {
        // TODO:-
      } else {
        data['hilbert'] = {};
      }

      final uniqueTimestamp = SALogEventDBService.generateUniqueTimestamp();
      final logModel = SAEventData(id: data.logId, eventType: 'session', data: jsonEncode(data), createTime: uniqueTimestamp, sequenceId: SALogEventDBService.currentSequenceId);
      await _adLogService.insertLog(logModel);
      log.d('[ad]log logSessionEvent saved to database');
    } catch (e) {
      log.e('SAlogEvent error: $e');
    }
  }

  Future<void> logCustomEvent({required String name, required Map<String, dynamic> params}) async {
    try {
      var data = await _getCommonParams();
      if (data == null) {
        return;
      }
      if (Platform.isAndroid) {
        // TODO:-
        // data['swarthy'] = name;
        // // 处理自定义参数
        // params.forEach((key, value) {
        //   data['$key@tung'] = value;
        // });
      } else if (Platform.isIOS) {
        data['oily'] = name;
        // 处理自定义参数
        params.forEach((key, value) {
          data['keenan>$key'] = value;
        });
      }

      final uniqueTimestamp = SALogEventDBService.generateUniqueTimestamp();
      final logModel = SAEventData(eventType: name, data: jsonEncode(data), createTime: uniqueTimestamp, id: data.logId, sequenceId: SALogEventDBService.currentSequenceId);
      await _adLogService.insertLog(logModel);
      log.d('[ad]log logCustomEvent saved to database');
    } catch (e) {
      log.e('[ad]log logCustomEvent error: $e');
    }
  }

  Future<void> _uploadPendingLogs() async {
    try {
      final logs = await _adLogService.getUnuploadedLogs().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          log.w('[ad]log getUnuploadedLogs timeout, returning empty list');
          return <SAEventData>[];
        },
      );

      if (logs.isEmpty) return;

      final List<dynamic> dataList = logs.map((log) => jsonDecode(log.data)).toList();

      // 添加超时控制，避免网络请求卡住应用
      final res = await _dio
          .post('', data: dataList)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              log.w('[ad]log Upload request timeout');
              throw TimeoutException('Upload request timeout', const Duration(seconds: 15));
            },
          );

      if (res.statusCode == 200) {
        await _adLogService
            .markLogsAsSuccess(logs)
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                log.w('[ad]log markLogsAsSuccess timeout');
                throw TimeoutException('markLogsAsSuccess timeout', const Duration(seconds: 5));
              },
            );
        log.d('[ad]log Batch upload success: ${logs.length} logs');
      } else {
        log.e('[ad]log Batch upload error: ${res.statusMessage}');
      }
    } catch (e) {
      log.e('[ad]log Batch upload catch: $e');
      // 网络错误不应影响应用正常运行，仅记录日志
    }
  }

  Future<void> _retryFailedLogs() async {
    try {
      final failedLogs = await _adLogService.getFailedLogs().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          log.w('[ad]log getFailedLogs timeout, returning empty list');
          return <SAEventData>[];
        },
      );

      if (failedLogs.isEmpty) return;

      final List<dynamic> dataList = failedLogs.map((log) => jsonDecode(log.data)).toList();

      // 添加超时控制，避免网络请求卡住应用
      final res = await _dio
          .post('', data: dataList)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              log.w('[ad]log Retry request timeout');
              throw TimeoutException('Retry request timeout', const Duration(seconds: 15));
            },
          );

      if (res.statusCode == 200) {
        await _adLogService
            .markLogsAsSuccess(failedLogs)
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                log.w('[ad]log markLogsAsSuccess timeout in retry');
                throw TimeoutException('markLogsAsSuccess timeout', const Duration(seconds: 5));
              },
            );
        log.d('[ad]log Retry success for: ${failedLogs.length}');
      } else {
        final ids = failedLogs.map((e) => e.id).toList();
        log.e('[ad]log Retry failed for: $ids');
      }
    } catch (e) {
      log.e('[ad]log Retry failed catch: $e');
      // 重试失败不应影响应用正常运行，仅记录日志
    }
  }

  /// 停止所有定时器，用于应用退出时清理资源
  void dispose() {
    _uploadTimer?.cancel();
    _retryTimer?.cancel();
    _uploadTimer = null;
    _retryTimer = null;
    log.d('[ad]log SAAppLogEvent disposed');
  }
}

extension Clannish on Map<String, dynamic> {
  dynamic get logId {
    if (Platform.isAndroid) {
      return ''; //TODO:
    } else {
      return this['gross'];
    }
  }
}

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final _adLogService = SALogEventDBService();
  List<SAEventData> _logs = [];
  bool _isLoading = true;
  String _filterType = 'all'; // all, pending, failed

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    try {
      final box = await _adLogService.box;
      var logs = box.values.toList();

      // Apply filter
      switch (_filterType) {
        case 'pending':
          logs = logs.where((log) => !log.isUploaded).toList();
          break;
        case 'failed':
          logs = logs.where((log) => !log.isSuccess).toList();
          break;
      }

      // Sort by createTime descending
      logs.sort((a, b) => b.createTime.compareTo(a.createTime));

      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Failed to load logs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Logs'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _filterType = value);
              _loadLogs();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Logs')),
              const PopupMenuItem(value: 'pending', child: Text('Pending Logs')),
              const PopupMenuItem(value: 'failed', child: Text('Failed Logs')),
            ],
            child: const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Icon(Icons.filter_list)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
          ? const Center(child: Text('No logs found'))
          : RefreshIndicator(
              onRefresh: _loadLogs,
              color: Colors.blue,
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index];

                  var name = log.eventType;

                  return ListTile(
                    title: Text(
                      name,
                      style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('id: ${log.id}', style: const TextStyle(color: Colors.blue)),
                        Text('Created: ${DateTime.fromMillisecondsSinceEpoch(log.createTime)}'),
                        if (log.uploadTime != null) Text('Uploaded: ${DateTime.fromMillisecondsSinceEpoch(log.uploadTime!)}'),
                        Row(
                          children: [
                            Icon(log.isUploaded ? Icons.cloud_done : Icons.cloud_upload, color: log.isUploaded ? Colors.green : Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text(log.isUploaded ? 'Uploaded' : 'Pending', style: TextStyle(color: log.isUploaded ? Colors.green : Colors.orange)),
                            const SizedBox(width: 8),
                            if (log.isUploaded) Icon(log.isSuccess ? Icons.check_circle : Icons.error, color: log.isSuccess ? Colors.green : Colors.red, size: 16),
                            const SizedBox(width: 4),
                            if (log.isUploaded) Text(log.isSuccess ? 'Success' : 'Failed', style: TextStyle(color: log.isSuccess ? Colors.green : Colors.red)),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Log Details - ${log.eventType}'),
                          content: SingleChildScrollView(
                            child: SelectableText(log.data), // 替换为SelectableText
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                            IconButton(
                              icon: const Icon(Icons.content_copy),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: log.data));
                                Get.snackbar('Copied', 'Log data copied to clipboard');
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
