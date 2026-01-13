import 'dart:convert';

class SAImgStyle {
  final String? name;
  final String? style;
  final String? icon;

  SAImgStyle({this.name, this.style, this.icon});

  factory SAImgStyle.fromRawJson(String str) => SAImgStyle.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAImgStyle.fromJson(Map<String, dynamic> json) => SAImgStyle(name: json["name"], style: json["style"], icon: json["icon"]);

  Map<String, dynamic> toJson() => {"name": name, "style": style, "icon": icon};
}
