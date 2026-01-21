import "dart:convert";

class SAOrderModel {
  final int? id;
  final String? orderNo;

  SAOrderModel({this.id, this.orderNo});

  factory SAOrderModel.fromRawJson(String str) => SAOrderModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAOrderModel.fromJson(Map<String, dynamic> json) => SAOrderModel(id: json["vhxdej"], orderNo: json["vhcstt"]);

  Map<String, dynamic> toJson() => {"vhxdej": id, "vhcstt": orderNo};
}
