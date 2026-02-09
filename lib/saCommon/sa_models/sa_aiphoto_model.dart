class AiPhoto {
  String? platform;
  List<ItemConfigs>? itemConfigs;

  AiPhoto({this.platform, this.itemConfigs});

  AiPhoto.fromJson(Map<String, dynamic> json) {
    platform = json['platform'];
    if (json['item_configs'] != null) {
      itemConfigs = <ItemConfigs>[];
      json['item_configs'].forEach((v) {
        itemConfigs!.add(new ItemConfigs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['platform'] = platform;
    if (itemConfigs != null) {
      data['item_configs'] = itemConfigs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemConfigs {
  String? itemType;
  String? title;
  String? text;
  String? imageUrl;
  int? orderNum;

  ItemConfigs({
    this.itemType,
    this.title,
    this.text,
    this.imageUrl,
    this.orderNum,
  });

  ItemConfigs.fromJson(Map<String, dynamic> json) {
    itemType = json['item_type'];
    title = json['title'];
    text = json['text'];
    imageUrl = json['image_url'];
    orderNum = json['order_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_type'] = itemType;
    data['title'] = title;
    data['text'] = text;
    data['image_url'] = imageUrl;
    data['order_num'] = orderNum;
    return data;
  }
}
