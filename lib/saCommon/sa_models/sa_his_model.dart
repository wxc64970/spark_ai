import 'dart:convert';

class SAImageHistroy {
  final int? id;
  final String? url;

  SAImageHistroy({this.id, this.url});

  factory SAImageHistroy.fromRawJson(String str) => SAImageHistroy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAImageHistroy.fromJson(Map<String, dynamic> json) => SAImageHistroy(id: json['vhxdej'], url: json['fnjbja']);

  Map<String, dynamic> toJson() => {'vhxdej': id, 'fnjbja': url};
}
