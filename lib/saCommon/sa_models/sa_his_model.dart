import 'dart:convert';

class SAImageHistroy {
  final int? id;
  final String? url;

  SAImageHistroy({this.id, this.url});

  factory SAImageHistroy.fromRawJson(String str) => SAImageHistroy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAImageHistroy.fromJson(Map<String, dynamic> json) => SAImageHistroy(id: json['id'], url: json['url']);

  Map<String, dynamic> toJson() => {'id': id, 'url': url};
}
