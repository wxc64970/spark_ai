import 'dart:async';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../models/sa_ad_log_model.dart';

class AdLogService {
  static final AdLogService _instance = AdLogService._internal();
  factory AdLogService() => _instance;
  AdLogService._internal();

  static Box<AdLogModel>? _box;
  static const String boxName = 'ad_logs';

  Future<Box<AdLogModel>> get box async {
    if (_box != null) return _box!;
    _box = await _initBox();
    return _box!;
  }

  Future<Box<AdLogModel>> _initBox() async {
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(AdLogModelAdapter());
    }
    return await Hive.openBox<AdLogModel>(boxName);
  }

  Future<void> insertLog(AdLogModel log) async {
    final box = await this.box;
    return await box.put(log.id, log);
  }

  Future<List<AdLogModel>> getUnuploadedLogs({int limit = 10}) async {
    final box = await this.box;
    return box.values.where((log) => !log.isUploaded).take(limit).toList();
  }

  Future<List<AdLogModel>> getFailedLogs({int limit = 10}) async {
    final box = await this.box;
    return box.values.where((log) => !log.isSuccess).take(limit).toList();
  }

  Future<void> markLogsAsSuccess(List<AdLogModel> logs) async {
    final box = await this.box;
    final now = DateTime.now().millisecondsSinceEpoch;
    try {
      for (final log in logs) {
        final updatedLog = AdLogModel(id: log.id, eventType: log.eventType, data: log.data, isSuccess: true, createTime: log.createTime, uploadTime: now, isUploaded: true);
        await box.put(log.id, updatedLog);
      }
    } catch (e) {
      throw Exception('Failed to update logs: $e');
    }
  }
}
