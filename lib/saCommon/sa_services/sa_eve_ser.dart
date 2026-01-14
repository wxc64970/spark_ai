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
    // SAAppLogEvent().logCustomEvent(name: name, params: parameters ?? {});
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
