import 'dart:convert';

class SALang {
  String? label;
  String? value;

  SALang({this.label, this.value});

  SALang copyWith({String? label, String? value}) => SALang(label: label ?? this.label, value: value ?? this.value);

  factory SALang.fromRawJson(String str) => SALang.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SALang.fromJson(Map<String, dynamic> json) => SALang(label: json["label"], value: json["acokxm"]);

  Map<String, dynamic> toJson() => {"label": label, "acokxm": value};
}
