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
    id: json["id"],
    characterAvatar: json["character_avatar"],
    characterId: json["character_id"],
    characterName: json["character_name"],
    cover: json["cover"],
    createTime: json["create_time"],
    duration: json["duration"],
    hideCharacter: json["hide_character"],
    istop: json["istop"],
    media: json["media"],
    mediaText: json["media_text"],
    text: json["text"],
    updateTime: json["update_time"],
    unlocked: json["unlocked"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "character_avatar": characterAvatar,
    "character_id": characterId,
    "character_name": characterName,
    "cover": cover,
    "create_time": createTime,
    "duration": duration,
    "hide_character": hideCharacter,
    "istop": istop,
    "media": media,
    "media_text": mediaText,
    "text": text,
    "update_time": updateTime,
    "unlocked": unlocked,
    "price": price,
  };
}
