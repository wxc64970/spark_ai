import 'dart:convert';

class AccountAssets {
  final int? id;
  final String? userId;
  final int? createImgNum;
  final int? infoAiWriteNum;
  final int? imgAiWriteNum;
  final int? recommendNum;
  final int? usePrivateNum;
  final int? privateNum;

  AccountAssets({
    this.id,
    this.userId,
    this.createImgNum,
    this.infoAiWriteNum,
    this.imgAiWriteNum,
    this.recommendNum,
    this.usePrivateNum,
    this.privateNum,
  });

  AccountAssets copyWith({
    int? id,
    String? userId,
    int? createImgNum,
    int? infoAiWriteNum,
    int? imgAiWriteNum,
    int? recommendNum,
    int? usePrivateNum,
    int? privateNum,
  }) => AccountAssets(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    createImgNum: createImgNum ?? this.createImgNum,
    infoAiWriteNum: infoAiWriteNum ?? this.infoAiWriteNum,
    imgAiWriteNum: imgAiWriteNum ?? this.imgAiWriteNum,
    recommendNum: recommendNum ?? this.recommendNum,
    usePrivateNum: usePrivateNum ?? this.usePrivateNum,
    privateNum: privateNum ?? this.privateNum,
  );

  factory AccountAssets.fromRawJson(String str) =>
      AccountAssets.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccountAssets.fromJson(Map<String, dynamic> json) => AccountAssets(
    id: json["vhxdej"],
    userId: json["lnoypv"],
    createImgNum: json["create_img_num"],
    infoAiWriteNum: json["info_ai_write_num"],
    imgAiWriteNum: json["img_ai_write_num"],
    recommendNum: json["recommend_num"],
    usePrivateNum: json["use_private_num"],
    privateNum: json["private_num"],
  );

  Map<String, dynamic> toJson() => {
    "vhxdej": id,
    "lnoypv": userId,
    "create_img_num": createImgNum,
    "info_ai_write_num": infoAiWriteNum,
    "img_ai_write_num": imgAiWriteNum,
    "recommend_num": recommendNum,
    "use_private_num": usePrivateNum,
    "private_num": privateNum,
  };
}
