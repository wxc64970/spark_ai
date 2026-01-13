import 'dart:convert';

class SALevelModel {
  final int? id;
  final int? level;
  final int? reward;
  final String? title;

  SALevelModel({this.id, this.level, this.reward, this.title});

  factory SALevelModel.fromRawJson(String str) => SALevelModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SALevelModel.fromJson(Map<String, dynamic> json) => SALevelModel(id: json['id'], level: json['level'], reward: json['reward'], title: json['title']);

  Map<String, dynamic> toJson() => {'id': id, 'level': level, 'reward': reward, 'title': title};
}
