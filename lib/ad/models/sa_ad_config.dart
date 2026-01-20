import 'dart:convert';

class AdConfig {
  final int? interval;
  final List<AdData>? open;
  final List<AdData>? homelist;
  final List<AdData>? chat;
  final List<AdData>? gems;
  final List<AdData>? album;
  final List<AdData>? chatback;

  AdConfig({this.interval, this.open, this.homelist, this.chat, this.gems, this.album, this.chatback});

  factory AdConfig.fromRawJson(String str) => AdConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdConfig.fromJson(Map<String, dynamic> json) => AdConfig(
    interval: json["interval"],
    open: json["open"] == null ? [] : List<AdData>.from(json["open"]!.map((x) => AdData.fromJson(x))),
    homelist: json["homelist"] == null ? [] : List<AdData>.from(json["homelist"]!.map((x) => AdData.fromJson(x))),
    chat: json["chat"] == null ? [] : List<AdData>.from(json["chat"]!.map((x) => AdData.fromJson(x))),
    gems: json["gems"] == null ? [] : List<AdData>.from(json["gems"]!.map((x) => AdData.fromJson(x))),
    album: json["album"] == null ? [] : List<AdData>.from(json["album"]!.map((x) => AdData.fromJson(x))),
    chatback: json["chatback"] == null ? [] : List<AdData>.from(json["chatback"]!.map((x) => AdData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "interval": interval,
    "open": open == null ? [] : List<dynamic>.from(open!.map((x) => x.toJson())),
    "homelist": homelist == null ? [] : List<dynamic>.from(homelist!.map((x) => x.toJson())),
    "chat": chat == null ? [] : List<dynamic>.from(chat!.map((x) => x.toJson())),
    "gems": gems == null ? [] : List<dynamic>.from(gems!.map((x) => x.toJson())),
    "album": album == null ? [] : List<dynamic>.from(album!.map((x) => x.toJson())),
    "chatback": chatback == null ? [] : List<dynamic>.from(chatback!.map((x) => x.toJson())),
  };
}

class AdData {
  final String? source;
  final int? level;
  final String? type;
  final String? id;
  final int? timer;

  AdData({this.source, this.level, this.type, this.id, this.timer});

  factory AdData.fromRawJson(String str) => AdData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdData.fromJson(Map<String, dynamic> json) => AdData(source: json["source"], level: json["level"], type: json["type"], id: json["id"], timer: json["timer"]);

  Map<String, dynamic> toJson() => {"source": source, "level": level, "type": type, "id": id, "timer": timer};
}
