import 'dart:convert';

class SAPricesModel {
  final int? sceneChange;
  final int? textMessage;
  final int? audioMessage;
  final int? photoMessage;
  final int? videoMessage;
  final int? generateImage;
  final int? generateVideo;
  final int? profileChange;
  final int? callAiCharacters;

  SAPricesModel({this.sceneChange, this.textMessage, this.audioMessage, this.photoMessage, this.videoMessage, this.generateImage, this.generateVideo, this.profileChange, this.callAiCharacters});

  factory SAPricesModel.fromRawJson(String str) => SAPricesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAPricesModel.fromJson(Map<String, dynamic> json) => SAPricesModel(
    sceneChange: json["eecvgv"],
    textMessage: json["itjglp"],
    audioMessage: json["kfuons"],
    photoMessage: json["vjwrzt"],
    videoMessage: json["almgyb"],
    generateImage: json["qyqvhx"],
    generateVideo: json["bzplez"],
    profileChange: json["bjxoft"],
    callAiCharacters: json["aeduie"],
  );

  Map<String, dynamic> toJson() => {
    "eecvgv": sceneChange,
    "itjglp": textMessage,
    "kfuons": audioMessage,
    "vjwrzt": photoMessage,
    "almgyb": videoMessage,
    "qyqvhx": generateImage,
    "bzplez": generateVideo,
    "bjxoft": profileChange,
    "aeduie": callAiCharacters,
  };
}
