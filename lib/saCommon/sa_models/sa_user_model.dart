import 'dart:convert';

class SAUsersModel {
  String? id;
  String? deviceId;
  String? token;
  String? platform;
  int? gems;
  dynamic audioSwitch;
  dynamic subscriptionEnd;
  String? nickname;
  String? idfa;
  String? adid;
  String? androidId;
  String? gpsAdid;
  bool? autoTranslate;
  bool? enableAutoTranslate;
  String? sourceLanguage;
  String? targetLanguage;
  int createImg;
  int createVideo;

  SAUsersModel({
    this.id,
    this.deviceId,
    this.token,
    this.platform,
    this.gems,
    this.audioSwitch,
    this.subscriptionEnd,
    this.nickname,
    this.idfa,
    this.adid,
    this.androidId,
    this.gpsAdid,
    this.autoTranslate,
    this.enableAutoTranslate,
    this.sourceLanguage,
    this.targetLanguage,
    this.createImg = 0,
    this.createVideo = 0,
  });

  factory SAUsersModel.fromRawJson(String str) => SAUsersModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAUsersModel.fromJson(Map<String, dynamic> json) => SAUsersModel(
    id: json["vhxdej"],
    deviceId: json["rxskda"],
    token: json["huqwyk"],
    platform: json["qubqwo"],
    gems: json["cuyhea"],
    audioSwitch: json["audio_switch"],
    subscriptionEnd: json["bhvgpi"],
    nickname: json["wwqtde"],
    idfa: json["ttcefd"],
    adid: json["ejtgyq"],
    androidId: json["android_id"],
    gpsAdid: json["gps_adid"],
    autoTranslate: json["rcixxe"],
    enableAutoTranslate: json["vubsjl"],
    sourceLanguage: json["gemadx"],
    targetLanguage: json["pnpknb"],
    createImg: json["ximjsl"] ?? 0,
    createVideo: json["sfuweu"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "vhxdej": id,
    "rxskda": deviceId,
    "huqwyk": token,
    "qubqwo": platform,
    "cuyhea": gems,
    "audio_switch": audioSwitch,
    "bhvgpi": subscriptionEnd,
    "wwqtde": nickname,
    "ttcefd": idfa,
    "ejtgyq": adid,
    "android_id": androidId,
    "gps_adid": gpsAdid,
    "rcixxe": autoTranslate,
    "vubsjl": enableAutoTranslate,
    "gemadx": sourceLanguage,
    "pnpknb": targetLanguage,
    "ximjsl": createImg,
    "sfuweu": createVideo,
  };
}
