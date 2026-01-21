import 'dart:convert';

import 'package:spark_ai/saCommon/index.dart';

class SAMsgReplayModel {
  final String? convId;
  final String? msgId;
  final MessageAnswerModel? answer;

  SAMsgReplayModel({this.convId, this.msgId, this.answer});

  factory SAMsgReplayModel.fromRawJson(String str) => SAMsgReplayModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAMsgReplayModel.fromJson(Map<String, dynamic> json) =>
      SAMsgReplayModel(convId: json['plpzei'], msgId: json['wdnsho'], answer: json['wdilno'] == null ? null : MessageAnswerModel.fromJson(json['wdilno']));

  Map<String, dynamic> toJson() => {'plpzei': convId, 'wdnsho': msgId, 'wdilno': answer?.toJson()};
}

class MessageAnswerModel {
  final String? content;
  final String? src;
  final String? lockLvl;
  final String? lockMed;
  final String? voiceUrl;
  final int? voiceDur;
  final String? resUrl;
  final int? duration;
  final String? thumbUrl;
  final String? translateContent;
  final bool? upgrade;
  final int? rewards;
  final ChatAnserLevel? appUserChatLevel;

  MessageAnswerModel({
    this.content,
    this.src,
    this.lockLvl,
    this.lockMed,
    this.voiceUrl,
    this.voiceDur,
    this.resUrl,
    this.duration,
    this.thumbUrl,
    this.translateContent,
    this.upgrade,
    this.rewards,
    this.appUserChatLevel,
  });

  factory MessageAnswerModel.fromRawJson(String str) => MessageAnswerModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageAnswerModel.fromJson(Map<String, dynamic> json) => MessageAnswerModel(
    content: json['content'],
    src: json['azaobf'],
    lockLvl: json['zoyxby'],
    lockMed: json['ivezhk'],
    voiceUrl: json['kddoxf'],
    voiceDur: json['ujgsbx'],
    resUrl: json['res_url'],
    duration: json['xyqkkp'],
    thumbUrl: json['wfjqwb'],
    translateContent: json['translate_content'],
    upgrade: json['qpdbps'],
    rewards: json['wcqaou'],
    appUserChatLevel: json['ojsnld'] == null ? null : ChatAnserLevel.fromJson(json['ojsnld']),
  );

  Map<String, dynamic> toJson() => {
    'content': content,
    'azaobf': src,
    'zoyxby': lockLvl,
    'ivezhk': lockMed,
    'kddoxf': voiceUrl,
    'ujgsbx': voiceDur,
    'res_url': resUrl,
    'xyqkkp': duration,
    'wfjqwb': thumbUrl,
    'translate_content': translateContent,
    'qpdbps': upgrade,
    'wcqaou': rewards,
    'ojsnld': appUserChatLevel,
  };
}
