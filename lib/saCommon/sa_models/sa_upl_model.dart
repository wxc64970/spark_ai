import 'dart:convert';

class SAImgUpModle {
  final int? estimatedTime;
  final String? uid;

  SAImgUpModle({this.estimatedTime, this.uid});

  factory SAImgUpModle.fromRawJson(String str) => SAImgUpModle.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAImgUpModle.fromJson(Map<String, dynamic> json) => SAImgUpModle(estimatedTime: json['tcnbnr'], uid: json['maeowl']);

  Map<String, dynamic> toJson() => {'tcnbnr': estimatedTime, 'maeowl': uid};
}

class ImageResultRes {
  final List<String>? results;
  final int? status;
  final String? uid;

  ImageResultRes({this.results, this.status, this.uid});

  factory ImageResultRes.fromRawJson(String str) => ImageResultRes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImageResultRes.fromJson(Map<String, dynamic> json) =>
      ImageResultRes(results: json['results'] == null ? [] : List<String>.from(json['results']!.map((x) => x)), status: json['status'], uid: json['maeowl']);

  Map<String, dynamic> toJson() => {'results': results == null ? [] : List<dynamic>.from(results!.map((x) => x)), 'status': status, 'maeowl': uid};
}

class ImageVideoResult {
  ImageVideoResItem? item;

  ImageVideoResult({this.item});

  factory ImageVideoResult.fromRawJson(String str) => ImageVideoResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImageVideoResult.fromJson(Map<String, dynamic> json) => ImageVideoResult(item: json["item"] == null ? null : ImageVideoResItem.fromJson(json["item"]));

  Map<String, dynamic> toJson() => {"item": item?.toJson()};
}

class ImageVideoResItem {
  String? uid;
  int? status;
  String? resultPath;

  ImageVideoResItem({required this.uid, required this.status, required this.resultPath});

  factory ImageVideoResItem.fromRawJson(String str) => ImageVideoResItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImageVideoResItem.fromJson(Map<String, dynamic> json) => ImageVideoResItem(uid: json["maeowl"], status: json["status"], resultPath: json["cwctdd"]);

  Map<String, dynamic> toJson() => {"maeowl": uid, "status": status, "cwctdd": resultPath};
}
