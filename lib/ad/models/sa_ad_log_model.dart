import 'dart:convert';

import 'package:hive/hive.dart';

part 'sa_ad_log_model.g.dart';

@HiveType(typeId: 0)
class AdLogModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String eventType;

  @HiveField(2)
  final String data;

  @HiveField(3)
  final bool isSuccess;

  @HiveField(4)
  final int createTime;

  @HiveField(5)
  final int? uploadTime;

  @HiveField(6)
  final bool isUploaded;

  AdLogModel({required this.id, required this.eventType, required this.data, this.isSuccess = false, required this.createTime, this.uploadTime, this.isUploaded = false});

  Map<String, dynamic> toMap() {
    return {'id': id, 'event_type': eventType, 'data': data, 'is_success': isSuccess ? 1 : 0, 'create_time': createTime, 'upload_time': uploadTime, 'is_uploaded': isUploaded ? 1 : 0};
  }

  factory AdLogModel.fromMap(Map<String, dynamic> map) {
    return AdLogModel(
      id: map['id'],
      eventType: map['event_type'],
      data: map['data'],
      isSuccess: map['is_success'] == 1,
      createTime: map['create_time'],
      uploadTime: map['upload_time'],
      isUploaded: map['is_uploaded'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdLogModel.fromJson(String source) => AdLogModel.fromMap(json.decode(source));
}
