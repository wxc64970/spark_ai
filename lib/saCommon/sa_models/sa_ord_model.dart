import "dart:convert";

class SAOrderModel {
  final int? id;
  final String? orderNo;

  SAOrderModel({this.id, this.orderNo});

  factory SAOrderModel.fromRawJson(String str) => SAOrderModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAOrderModel.fromJson(Map<String, dynamic> json) => SAOrderModel(id: json["id"], orderNo: json["order_no"]);

  Map<String, dynamic> toJson() => {"id": id, "order_no": orderNo};
}
