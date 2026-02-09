import 'dart:convert';

class AiAvatarOptions {
  int? id;
  String? name;
  List<AiAvatarTag>? tags;
  bool? required;

  AiAvatarOptions({this.id, this.name, this.tags, this.required});

  AiAvatarOptions copyWith({
    int? id,
    String? name,
    List<AiAvatarTag>? tags,
    bool? required,
  }) => AiAvatarOptions(
    id: id ?? this.id,
    name: name ?? this.name,
    tags: tags ?? this.tags,
    required: required ?? this.required,
  );

  factory AiAvatarOptions.fromRawJson(String str) =>
      AiAvatarOptions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AiAvatarOptions.fromJson(Map<String, dynamic> json) =>
      AiAvatarOptions(
        id: json["id"],
        name: json["name"],
        tags: json["tags"] == null
            ? []
            : List<AiAvatarTag>.from(
                json["tags"]!.map((x) => AiAvatarTag.fromJson(x)),
              ),
        required: json["required"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "tags": tags == null
        ? []
        : List<dynamic>.from(tags!.map((x) => x.toJson())),
    "required": required,
  };
}

class AiAvatarTag {
  String? id;
  String? label;
  String? value;
  bool isSelected; // 添加选中状态字段

  AiAvatarTag({
    this.id,
    this.label,
    this.value,
    this.isSelected = false, // 默认未选中
  });

  AiAvatarTag copyWith({
    String? id,
    String? label,
    String? value,
    bool? isSelected,
  }) => AiAvatarTag(
    id: id ?? this.id,
    label: label ?? this.label,
    value: value ?? this.value,
    isSelected: isSelected ?? this.isSelected,
  );

  factory AiAvatarTag.fromRawJson(String str) =>
      AiAvatarTag.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AiAvatarTag.fromJson(Map<String, dynamic> json) => AiAvatarTag(
    id: json["id"],
    label: json["label"],
    value: json["value"],
    isSelected: false, // API数据默认未选中
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "value": value,
    // isSelected 不需要序列化到API，只用于本地状态管理
  };
}
