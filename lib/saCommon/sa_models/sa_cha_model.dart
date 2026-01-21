import 'dart:convert';

import 'package:spark_ai/saCommon/index.dart';

class SAChaterPageModel {
  List<ChaterModel>? records;
  int? total;
  int? size;
  int? current;
  int? pages;

  SAChaterPageModel({this.records, this.total, this.size, this.current, this.pages});

  factory SAChaterPageModel.fromRawJson(String str) => SAChaterPageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAChaterPageModel.fromJson(Map<String, dynamic> json) => SAChaterPageModel(
    records: json["goiscj"] == null ? [] : List<ChaterModel>.from(json["goiscj"]!.map((x) => ChaterModel.fromJson(x))),
    total: json["azwmwk"],
    size: json["rvaqlw"],
    current: json["ncbeif"],
    pages: json["hdxfjf"],
  );

  Map<String, dynamic> toJson() => {"goiscj": records == null ? [] : List<dynamic>.from(records!.map((x) => x.toJson())), "azwmwk": total, "rvaqlw": size, "ncbeif": current, "hdxfjf": pages};

  void operator [](String other) {}
}

class ChaterModel {
  String? id;
  int? age;
  String? aboutMe;
  Media? media;
  List<RoleImage>? images;
  String? avatar;
  dynamic avatarVideo;
  String? name;
  String? platform;
  String? renderStyle;
  String? likes;
  List<String>? greetings;
  List<dynamic>? greetingsVoice;
  String? sessionCount;
  bool? vip;
  int? orderNum;
  List<String>? tags;
  String? tagType;
  String? scenario;
  double? temperature;
  String? voiceId;
  String? engine;
  int? gender;
  bool? videoChat;
  List<CharacterVideoChat>? characterVideoChat;
  List<String>? genPhotoTags;
  List<String>? genVideoTags;
  bool? genPhoto;
  bool? genVideo;
  bool? gems;
  bool? collect;
  String? lastMessage;
  String? intro;
  bool? changeClothing;
  List<ChangeClothe>? changeClothes;
  int? updateTime;
  int? chatNum;
  int? msgNum;
  String? mode;
  int? cid;
  dynamic cardNum;
  dynamic unlockCardNum;
  dynamic price;

  ChaterModel({
    this.id,
    this.age,
    this.aboutMe,
    this.media,
    this.images,
    this.avatar,
    this.avatarVideo,
    this.name,
    this.platform,
    this.renderStyle,
    this.likes,
    this.greetings,
    this.greetingsVoice,
    this.sessionCount,
    this.vip,
    this.orderNum,
    this.tags,
    this.tagType,
    this.scenario,
    this.temperature,
    this.voiceId,
    this.engine,
    this.gender,
    this.videoChat,
    this.characterVideoChat,
    this.genPhotoTags,
    this.genVideoTags,
    this.genPhoto,
    this.genVideo,
    this.gems,
    this.collect,
    this.lastMessage,
    this.intro,
    this.changeClothing,
    this.changeClothes,
    this.updateTime,
    this.chatNum,
    this.msgNum,
    this.mode,
    this.cid,
    this.cardNum,
    this.unlockCardNum,
    this.price,
  });

  ChaterModel copyWith({
    String? id,
    int? age,
    String? aboutMe,
    Media? media,
    List<RoleImage>? images,
    String? avatar,
    dynamic avatarVideo,
    String? name,
    String? platform,
    String? renderStyle,
    String? likes,
    List<String>? greetings,
    List<dynamic>? greetingsVoice,
    String? sessionCount,
    bool? vip,
    int? orderNum,
    List<String>? tags,
    String? tagType,
    String? scenario,
    double? temperature,
    String? voiceId,
    String? engine,
    int? gender,
    bool? videoChat,
    List<CharacterVideoChat>? characterVideoChat,
    List<String>? genPhotoTags,
    List<String>? genVideoTags,
    bool? genPhoto,
    bool? genVideo,
    bool? gems,
    bool? collect,
    dynamic lastMessage,
    dynamic intro,
    dynamic changeClothing,
    dynamic changeClothes,
    dynamic updateTime,
    int? chatNum,
    int? msgNum,
    dynamic mode,
    int? cid,
    dynamic cardNum,
    dynamic unlockCardNum,
    dynamic price,
  }) => ChaterModel(
    id: id ?? this.id,
    age: age ?? this.age,
    aboutMe: aboutMe ?? this.aboutMe,
    media: media ?? this.media,
    images: images ?? this.images,
    avatar: avatar ?? this.avatar,
    avatarVideo: avatarVideo ?? this.avatarVideo,
    name: name ?? this.name,
    platform: platform ?? this.platform,
    renderStyle: renderStyle ?? this.renderStyle,
    likes: likes ?? this.likes,
    greetings: greetings ?? this.greetings,
    greetingsVoice: greetingsVoice ?? this.greetingsVoice,
    sessionCount: sessionCount ?? this.sessionCount,
    vip: vip ?? this.vip,
    orderNum: orderNum ?? this.orderNum,
    tags: tags ?? this.tags,
    tagType: tagType ?? this.tagType,
    scenario: scenario ?? this.scenario,
    temperature: temperature ?? this.temperature,
    voiceId: voiceId ?? this.voiceId,
    engine: engine ?? this.engine,
    gender: gender ?? this.gender,
    videoChat: videoChat ?? this.videoChat,
    characterVideoChat: characterVideoChat ?? this.characterVideoChat,
    genPhotoTags: genPhotoTags ?? this.genPhotoTags,
    genVideoTags: genVideoTags ?? this.genVideoTags,
    genPhoto: genPhoto ?? this.genPhoto,
    genVideo: genVideo ?? this.genVideo,
    gems: gems ?? this.gems,
    collect: collect ?? this.collect,
    lastMessage: lastMessage ?? this.lastMessage,
    intro: intro ?? this.intro,
    changeClothing: changeClothing ?? this.changeClothing,
    changeClothes: changeClothes ?? this.changeClothes,
    updateTime: updateTime ?? this.updateTime,
    chatNum: chatNum ?? this.chatNum,
    msgNum: msgNum ?? this.msgNum,
    mode: mode ?? this.mode,
    cid: cid ?? this.cid,
    cardNum: cardNum ?? this.cardNum,
    unlockCardNum: unlockCardNum ?? this.unlockCardNum,
    price: price ?? this.price,
  );

  factory ChaterModel.fromRawJson(String str) => ChaterModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChaterModel.fromJson(Map<String, dynamic> json) => ChaterModel(
    id: json["vhxdej"],
    age: json["htqcfm"],
    aboutMe: json["npcejw"],
    media: json["qxcvyk"] == null ? null : Media.fromJson(json["qxcvyk"]),
    images: json["images"] == null ? [] : List<RoleImage>.from(json["images"]!.map((x) => RoleImage.fromJson(x))),
    avatar: json["mjjlmx"],
    avatarVideo: json["avatar_video"],
    name: json["yvosho"],
    platform: json["qubqwo"],
    renderStyle: json["zuckcd"],
    likes: json["zbcter"],
    greetings: json["gtibvy"] == null ? [] : List<String>.from(json["gtibvy"]!.map((x) => x)),
    greetingsVoice: json["cxnsjw"] == null ? [] : List<dynamic>.from(json["cxnsjw"]!.map((x) => x)),
    sessionCount: json["meievp"],
    vip: json["ezxnby"],
    orderNum: json["emhjdj"],
    tags: json["jskdne"] == null ? [] : List<String>.from(json["jskdne"]!.map((x) => x)),
    tagType: json["tag_type"],
    scenario: json["scenario"],
    temperature: json["temperature"]?.toDouble(),
    voiceId: json["akerge"],
    engine: json["coxhkj"],
    gender: json["wldzbd"],
    videoChat: json["xhfnla"],
    characterVideoChat: json["dlruzy"] == null ? [] : List<CharacterVideoChat>.from(json["dlruzy"]!.map((x) => CharacterVideoChat.fromJson(x))),
    genPhotoTags: json["ewvzax"] == null ? [] : List<String>.from(json["ewvzax"]!.map((x) => x)),
    genVideoTags: json["gen_video_tags"] == null ? [] : List<String>.from(json["gen_video_tags"]!.map((x) => x)),
    genPhoto: json["giusat"],
    genVideo: json["plpeso"],
    gems: json["cuyhea"],
    collect: json["collect"],
    lastMessage: json["afogji"],
    intro: json["intro"],
    changeClothing: json["nniivi"],
    changeClothes: json["change_clothes"] == null ? [] : List<ChangeClothe>.from(json["change_clothes"]!.map((x) => ChangeClothe.fromJson(x))),
    updateTime: json["cnbcid"],
    chatNum: json["chat_num"],
    msgNum: json["msg_num"],
    mode: json["mode"],
    cid: json["uqdyrd"],
    cardNum: json["fhssgc"],
    unlockCardNum: json["chrauy"],
    price: json["ffgewn"],
  );

  Map<String, dynamic> toJson() => {
    "vhxdej": id,
    "htqcfm": age,
    "npcejw": aboutMe,
    "qxcvyk": media?.toJson(),
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
    "mjjlmx": avatar,
    "avatar_video": avatarVideo,
    "yvosho": name,
    "qubqwo": platform,
    "zuckcd": renderStyle,
    "zbcter": likes,
    "gtibvy": greetings == null ? [] : List<dynamic>.from(greetings!.map((x) => x)),
    "cxnsjw": greetingsVoice == null ? [] : List<dynamic>.from(greetingsVoice!.map((x) => x)),
    "meievp": sessionCount,
    "ezxnby": vip,
    "emhjdj": orderNum,
    "jskdne": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "tag_type": tagType,
    "scenario": scenario,
    "temperature": temperature,
    "akerge": voiceId,
    "coxhkj": engine,
    "wldzbd": gender,
    "xhfnla": videoChat,
    "dlruzy": characterVideoChat == null ? [] : List<dynamic>.from(characterVideoChat!.map((x) => x.toJson())),
    "ewvzax": genPhotoTags == null ? [] : List<dynamic>.from(genPhotoTags!.map((x) => x)),
    "gen_video_tags": genVideoTags == null ? [] : List<dynamic>.from(genVideoTags!.map((x) => x)),
    "giusat": genPhoto,
    "plpeso": genVideo,
    "cuyhea": gems,
    "collect": collect,
    "afogji": lastMessage,
    "intro": intro,
    "nniivi": changeClothing,
    "change_clothes": changeClothes == null ? [] : List<dynamic>.from(changeClothes!.map((x) => x.toJson())),
    "cnbcid": updateTime,
    "chat_num": chatNum,
    "msg_num": msgNum,
    "mode": mode,
    "uqdyrd": cid,
    "fhssgc": cardNum,
    "chrauy": unlockCardNum,
    "ffgewn": price,
  };
}

class CharacterVideoChat {
  int? id;
  String? characterId;
  String? tag;
  int? duration;
  String? url;
  String? gifUrl;
  dynamic createTime;
  dynamic updateTime;

  CharacterVideoChat({this.id, this.characterId, this.tag, this.duration, this.url, this.gifUrl, this.createTime, this.updateTime});

  CharacterVideoChat copyWith({int? id, String? characterId, String? tag, int? duration, String? url, String? gifUrl, dynamic createTime, dynamic updateTime}) => CharacterVideoChat(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    tag: tag ?? this.tag,
    duration: duration ?? this.duration,
    url: url ?? this.url,
    gifUrl: gifUrl ?? this.gifUrl,
    createTime: createTime ?? this.createTime,
    updateTime: updateTime ?? this.updateTime,
  );

  factory CharacterVideoChat.fromRawJson(String str) => CharacterVideoChat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CharacterVideoChat.fromJson(Map<String, dynamic> json) => CharacterVideoChat(
    id: json["vhxdej"],
    characterId: json["okpeqa"],
    tag: json["tag"],
    duration: json["xyqkkp"],
    url: json["fnjbja"],
    gifUrl: json["gif_url"],
    createTime: json["tldysq"],
    updateTime: json["cnbcid"],
  );

  Map<String, dynamic> toJson() => {"vhxdej": id, "okpeqa": characterId, "tag": tag, "xyqkkp": duration, "fnjbja": url, "gif_url": gifUrl, "tldysq": createTime, "cnbcid": updateTime};
}

class RoleImage {
  int? id;
  dynamic createTime;
  dynamic updateTime;
  String? imageUrl;
  String? modelId;
  int? gems;
  int? imgType;
  dynamic imgRemark;
  bool? unlocked;

  RoleImage({this.id, this.createTime, this.updateTime, this.imageUrl, this.modelId, this.gems, this.imgType, this.imgRemark, this.unlocked});

  RoleImage copyWith({int? id, dynamic createTime, dynamic updateTime, String? imageUrl, String? modelId, int? gems, int? imgType, dynamic imgRemark, bool? unlocked}) => RoleImage(
    id: id ?? this.id,
    createTime: createTime ?? this.createTime,
    updateTime: updateTime ?? this.updateTime,
    imageUrl: imageUrl ?? this.imageUrl,
    modelId: modelId ?? this.modelId,
    gems: gems ?? this.gems,
    imgType: imgType ?? this.imgType,
    imgRemark: imgRemark ?? this.imgRemark,
    unlocked: unlocked ?? this.unlocked,
  );

  factory RoleImage.fromRawJson(String str) => RoleImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RoleImage.fromJson(Map<String, dynamic> json) => RoleImage(
    id: json["vhxdej"],
    createTime: json["tldysq"],
    updateTime: json["cnbcid"],
    imageUrl: json["image_url"],
    modelId: json["zeierr"],
    gems: json["cuyhea"],
    imgType: json["img_type"],
    imgRemark: json["img_remark"],
    unlocked: json["unlocked"],
  );

  Map<String, dynamic> toJson() => {
    "vhxdej": id,
    "tldysq": createTime,
    "cnbcid": updateTime,
    "image_url": imageUrl,
    "zeierr": modelId,
    "cuyhea": gems,
    "img_type": imgType,
    "img_remark": imgRemark,
    "unlocked": unlocked,
  };
}

class Media {
  List<String>? characterImages;

  Media({this.characterImages});

  Media copyWith({List<String>? characterImages}) => Media(characterImages: characterImages ?? this.characterImages);

  factory Media.fromRawJson(String str) => Media.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Media.fromJson(Map<String, dynamic> json) => Media(characterImages: json["swjztf"] == null ? [] : List<String>.from(json["swjztf"]!.map((x) => x)));

  Map<String, dynamic> toJson() => {"swjztf": characterImages == null ? [] : List<dynamic>.from(characterImages!.map((x) => x))};
}

// ChaterModel扩展
const kNSFW = 'NSFW';
const kBDSM = 'BDSM';

extension ChaterModelExtension on ChaterModel {
  /// 提取标签构建逻辑，避免build方法中重复计算
  List<String> buildDisplayTags() {
    final tags = this.tags;
    List<String> result = (tags != null && tags.length > 3) ? tags.take(3).toList() : tags ?? [];

    final tagType = this.tagType;
    if (tagType != null) {
      if (tagType.contains(kNSFW) && !result.contains(kNSFW)) {
        result.insert(0, kNSFW);
      }
      if (tagType.contains(kBDSM) && !result.contains(kBDSM)) {
        result.insert(0, kBDSM);
      }
    }

    return result.take(3).toList(); // 确保最多3个标签
  }
}
