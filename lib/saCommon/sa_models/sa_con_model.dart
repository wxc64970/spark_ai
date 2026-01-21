import 'dart:convert';

class SAConversationModel {
  int? id;
  String? avatar;
  String? userId;
  String? title;
  bool? pinned;
  dynamic pinnedTime;
  String? characterId;
  dynamic model;
  int? templateId;
  String? voiceModel;
  dynamic lastMessage;
  int? updateTime;
  int? createTime;
  bool? collect;
  String? mode;
  dynamic background;
  int? cid;
  String? scene;
  int? profileId;
  String? chatModel;

  SAConversationModel({
    this.id,
    this.avatar,
    this.userId,
    this.title,
    this.pinned,
    this.pinnedTime,
    this.characterId,
    this.model,
    this.templateId,
    this.voiceModel,
    this.lastMessage,
    this.updateTime,
    this.createTime,
    this.collect,
    this.mode,
    this.background,
    this.cid,
    this.scene,
    this.profileId,
    this.chatModel,
  });

  factory SAConversationModel.fromRawJson(String str) => SAConversationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAConversationModel.fromJson(Map<String, dynamic> json) => SAConversationModel(
    id: json["vhxdej"],
    avatar: json["mjjlmx"],
    userId: json["lnoypv"],
    title: json["dcbzuv"],
    pinned: json["pinned"],
    pinnedTime: json["pinned_time"],
    characterId: json["okpeqa"],
    model: json["model"],
    templateId: json["xhxxks"],
    voiceModel: json["voice_model"],
    lastMessage: json["afogji"],
    updateTime: json["cnbcid"],
    createTime: json["tldysq"],
    collect: json["collect"],
    mode: json["mode"],
    background: json["background"],
    cid: json["uqdyrd"],
    scene: json["cvubbg"],
    profileId: json["aosdja"],
    chatModel: json["hnvglc"],
  );

  Map<String, dynamic> toJson() => {
    "vhxdej": id,
    "mjjlmx": avatar,
    "lnoypv": userId,
    "dcbzuv": title,
    "pinned": pinned,
    "pinned_time": pinnedTime,
    "okpeqa": characterId,
    "model": model,
    "xhxxks": templateId,
    "voice_model": voiceModel,
    "afogji": lastMessage,
    "cnbcid": updateTime,
    "tldysq": createTime,
    "collect": collect,
    "mode": mode,
    "background": background,
    "uqdyrd": cid,
    "cvubbg": scene,
    "aosdja": profileId,
    "hnvglc": chatModel,
  };
}
