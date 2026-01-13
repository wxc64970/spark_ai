import 'dart:convert';

class SATagsModel {
  final String? labelType;
  final List<TagModel>? tags;

  SATagsModel({this.labelType, this.tags});

  factory SATagsModel.fromRawJson(String str) => SATagsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SATagsModel.fromJson(Map<String, dynamic> json) =>
      SATagsModel(labelType: json["label_type"], tags: json["jskdne"] == null ? [] : List<TagModel>.from(json["jskdne"]!.map((x) => TagModel.fromJson(x))));

  Map<String, dynamic> toJson() => {"label_type": labelType, "jskdne": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x.toJson()))};
}

class TagModel {
  final int? id;
  final String? name;
  String? labelType;
  bool? remark;

  TagModel({this.id, this.name, this.labelType, this.remark});

  factory TagModel.fromRawJson(String str) => TagModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(id: json["vhxdej"], name: json["yvosho"], labelType: json["label_type"]);

  Map<String, dynamic> toJson() => {"vhxdej": id, "yvosho": name, "label_type": labelType};
}
