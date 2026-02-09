import 'dart:convert';

class GenAvatarResulut {
  final int? id;
  final String? imgs;
  final List<ExtAvatar>? results;

  GenAvatarResulut({this.id, this.imgs, this.results});

  GenAvatarResulut copyWith({
    int? id,
    String? imgs,
    List<ExtAvatar>? results,
  }) => GenAvatarResulut(
    id: id ?? this.id,
    imgs: imgs ?? this.imgs,
    results: results ?? this.results,
  );

  factory GenAvatarResulut.fromRawJson(String str) =>
      GenAvatarResulut.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenAvatarResulut.fromJson(Map<String, dynamic> json) =>
      GenAvatarResulut(
        id: json["vhxdej"],
        imgs: json["imgs"],
        results: json["results"] == null
            ? []
            : List<ExtAvatar>.from(
                json["results"]!.map((x) => ExtAvatar.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "vhxdej": id,
    "imgs": imgs,
    "results": results == null
        ? []
        : List<dynamic>.from(results!.map((x) => x.toJson())),
  };

  // imgs 是逗号分隔的字符串格式
  List<String>? get imageList => imgs
      ?.split(',')
      .map((url) => url.trim())
      .where((url) => url.isNotEmpty)
      .toList();
}

class ExtAvatar {
  final int? id;
  final int? genImgId;
  final String? imgPath;

  ExtAvatar({this.id, this.genImgId, this.imgPath});

  ExtAvatar copyWith({int? id, int? genImgId, String? imgPath}) => ExtAvatar(
    id: id ?? this.id,
    genImgId: genImgId ?? this.genImgId,
    imgPath: imgPath ?? this.imgPath,
  );

  factory ExtAvatar.fromRawJson(String str) =>
      ExtAvatar.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExtAvatar.fromJson(Map<String, dynamic> json) => ExtAvatar(
    id: json["vhxdej"],
    genImgId: json["ivckbi"],
    imgPath: json["img_path"],
  );

  Map<String, dynamic> toJson() => {
    "vhxdej": id,
    "ivckbi": genImgId,
    "img_path": imgPath,
  };
}
