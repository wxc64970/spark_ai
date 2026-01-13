import 'dart:convert';

class SAClothModel {
  final int? id;
  final String? togsName;
  final int? togsType;
  final String? img;
  final dynamic cdesc;
  final int? itemPrice;

  SAClothModel({this.id, this.togsName, this.togsType, this.img, this.cdesc, this.itemPrice});

  factory SAClothModel.fromRawJson(String str) => SAClothModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAClothModel.fromJson(Map<String, dynamic> json) =>
      SAClothModel(id: json["id"], togsName: json["cname"], togsType: json["ctype"], img: json["img"], cdesc: json["cdesc"], itemPrice: json["price"]);

  Map<String, dynamic> toJson() => {"id": id, "togs_name": togsName, "ctype": togsType, "img": img, "cdesc": cdesc, "price": itemPrice};
}

class ChangeClothe {
  final int? id;
  final int? clothingType;
  final String? modelId;

  ChangeClothe({this.id, this.clothingType, this.modelId});

  factory ChangeClothe.fromRawJson(String str) => ChangeClothe.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChangeClothe.fromJson(Map<String, dynamic> json) => ChangeClothe(id: json["id"], clothingType: json["clothing_type"], modelId: json["loylzj"]);

  Map<String, dynamic> toJson() => {"id": id, "clothing_type": clothingType, "loylzj": modelId};
}
