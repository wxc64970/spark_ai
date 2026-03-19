class StyleConfig {
  StyleConfigItem? example;
  List<StyleConfigItem>? text2img;
  List<StyleConfigItem>? image;
  List<StyleConfigItem>? video;

  StyleConfig({this.text2img, this.image, this.video});

  StyleConfig.fromJson(Map<String, dynamic> json) {
    example = json['example'] != null
        ? StyleConfigItem.fromJson(json['example'])
        : null;
    if (json['text2img'] != null) {
      text2img = <StyleConfigItem>[];
      json['text2img'].forEach((v) {
        text2img!.add(StyleConfigItem.fromJson(v));
      });
    }
    if (json['image'] != null) {
      image = <StyleConfigItem>[];
      json['image'].forEach((v) {
        image!.add(StyleConfigItem.fromJson(v));
      });
    }
    if (json['video'] != null) {
      video = <StyleConfigItem>[];
      json['video'].forEach((v) {
        video!.add(StyleConfigItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (example != null) {
      data['example'] = example!.toJson();
    }
    if (text2img != null) {
      data['text2img'] = text2img!.map((v) => v.toJson()).toList();
    }
    if (image != null) {
      data['image'] = image!.map((v) => v.toJson()).toList();
    }
    if (video != null) {
      data['video'] = video!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StyleConfigItem {
  String? name;
  String? style;
  String? url;
  String? icon;
  String? price;

  StyleConfigItem({this.name, this.style, this.url, this.icon, this.price});

  StyleConfigItem.fromJson(Map<String, dynamic> json) {
    name = json['yvosho'];
    style = json['dnrbes'];
    url = json['fnjbja'];
    icon = json['icon'];
    price = json['ffgewn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['style'] = style;
    data['url'] = url;
    data['icon'] = icon;
    data['price'] = price;
    return data;
  }
}
