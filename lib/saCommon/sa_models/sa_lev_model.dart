import 'dart:convert';

class SALevelModel {
  final int? id;
  final int? level;
  final int? reward;
  final String? title;

  SALevelModel({this.id, this.level, this.reward, this.title});

  factory SALevelModel.fromRawJson(String str) => SALevelModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SALevelModel.fromJson(Map<String, dynamic> json) => SALevelModel(id: json['vhxdej'], level: json['fcdxdd'], reward: json['grgqjo'], title: json['dcbzuv']);

  Map<String, dynamic> toJson() => {'vhxdej': id, 'fcdxdd': level, 'grgqjo': reward, 'dcbzuv': title};
}
