import 'dart:convert';

class SAMaskModel {
  final int? id;
  final String? userId;
  final String? profileName;
  final int? gender;
  final int? age;
  final String? description;
  final String? otherInfo;

  SAMaskModel({this.id, this.userId, this.profileName, this.gender, this.age, this.description, this.otherInfo});

  factory SAMaskModel.fromRawJson(String str) => SAMaskModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAMaskModel.fromJson(Map<String, dynamic> json) => SAMaskModel(
    id: json["vhxdej"],
    userId: json["lnoypv"],
    profileName: json["profile_name"],
    gender: json["wldzbd"],
    age: json["htqcfm"],
    description: json["description"],
    otherInfo: json["other_info"],
  );

  Map<String, dynamic> toJson() => {"vhxdej": id, "lnoypv": userId, "profile_name": profileName, "wldzbd": gender, "htqcfm": age, "description": description, "other_info": otherInfo};
}
