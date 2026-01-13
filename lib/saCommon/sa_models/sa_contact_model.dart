import 'package:flutter/material.dart';
import 'package:spark_ai/saCommon/index.dart';

class SAAzListContactModel {
  final String section;
  final List<String> names;
  final List<SALang>? langs; // 添加 lang 属性来保存语言数据

  SAAzListContactModel({required this.section, required this.names, this.langs});
}

class AzListCursorInfoModel {
  final String title;
  final Offset offset;

  AzListCursorInfoModel({required this.title, required this.offset});
}
