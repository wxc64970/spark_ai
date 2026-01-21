import 'dart:convert';

class SAPost {
  int? id;
  String? characterAvatar;
  String? characterId;
  String? characterName;
  String? cover;
  dynamic createTime;
  dynamic duration;
  bool? hideCharacter;
  bool? istop;
  String? media;
  dynamic mediaText;
  String? text;
  dynamic updateTime;
  bool? unlocked;
  int? price;

  SAPost({
    this.id,
    this.characterAvatar,
    this.characterId,
    this.characterName,
    this.cover,
    this.createTime,
    this.duration,
    this.hideCharacter,
    this.istop,
    this.media,
    this.mediaText,
    this.text,
    this.updateTime,
    this.unlocked,
    this.price,
  });

  factory SAPost.fromRawJson(String str) => SAPost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAPost.fromJson(Map<String, dynamic> json) => SAPost(
    id: json["vhxdej"],
    characterAvatar: json["character_avatar"],
    characterId: json["okpeqa"],
    characterName: json["jkcnis"],
    cover: json["cover"],
    createTime: json["tldysq"],
    duration: json["xyqkkp"],
    hideCharacter: json["qpghan"],
    istop: json["istop"],
    media: json["qxcvyk"],
    mediaText: json["gpcyam"],
    text: json["text"],
    updateTime: json["cnbcid"],
    unlocked: json["unlocked"],
    price: json["ffgewn"],
  );

  Map<String, dynamic> toJson() => {
    "vhxdej": id,
    "character_avatar": characterAvatar,
    "okpeqa": characterId,
    "jkcnis": characterName,
    "cover": cover,
    "tldysq": createTime,
    "xyqkkp": duration,
    "qpghan": hideCharacter,
    "istop": istop,
    "qxcvyk": media,
    "gpcyam": mediaText,
    "text": text,
    "cnbcid": updateTime,
    "unlocked": unlocked,
    "ffgewn": price,
  };
}
