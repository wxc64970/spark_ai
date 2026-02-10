import 'dart:convert';

import 'package:in_app_purchase/in_app_purchase.dart';

class SASkModel {
  final String? id;
  final String? sku;
  final String? name;
  final int? number;
  final int? orderNum; // 排序

  /// 默认选中
  final bool? defaultSku;
  final bool? lifetime;

  ///  GEMS(0, "钻石"),   VIP(1, "VIP"), SVIP(2, "SVIP"),   NOT_VIP(3, "非VIP");
  // final int? skuLevel;
  // GEMS(0, "钻石"), WEEK(1, "周卡"),  MONTH(2, "月卡"), YEAR(3, "年卡"),  LIFETIME(4, "永久订阅"),
  final int? skuType;
  final int? createImg;
  final int? createVideo;

  /// 是否上架
  final bool? shelf;

  //是否显示
  final bool? displayHide;

  ///  @VL(value = "1", label = "Best Value"),
  /// @VL(value = "2", label = "Most Popular"),
  /// @VL(value = "3", label = "\uD83D\uDD25Save 75%")
  final int? tag;

  ProductDetails? productDetails;

  SASkModel({
    this.id,
    this.sku,
    this.name,
    this.number,
    this.defaultSku,
    this.lifetime,
    this.skuType,
    this.createImg,
    this.createVideo,
    this.shelf,
    this.tag,
    this.orderNum,
    this.displayHide,
  });

  factory SASkModel.fromRawJson(String str) =>
      SASkModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SASkModel.fromJson(Map<String, dynamic> json) => SASkModel(
    id: json["vhxdej"],
    sku: json["sku"],
    name: json["yvosho"],
    number: json["number"],
    defaultSku: json["default_sku"],
    lifetime: json["lifetime"],
    skuType: json["sku_type"],
    createImg: json["ximjsl"],
    createVideo: json["sfuweu"],
    shelf: json["shelf"],
    tag: json["tag"],
    orderNum: json["emhjdj"],
    displayHide: json["display_hide"],
  );

  Map<String, dynamic> toJson() => {
    "vhxdej": id,
    "sku": sku,
    "yvosho": name,
    "number": number,
    "default_sku": defaultSku,
    "lifetime": lifetime,
    "sku_type": skuType,
    "ximjsl": createImg,
    "sfuweu": createVideo,
    "shelf": shelf,
    "tag": tag,
    "emhjdj": orderNum,
    "display_hide": displayHide,
  };
}
