class PriceConfig {
  int? i2i;
  int? i2v;
  T2i? t2i;

  PriceConfig({this.i2i, this.i2v, this.t2i});

  PriceConfig.fromJson(Map<String, dynamic> json) {
    i2i = json['i2i'];
    i2v = json['i2v'];
    t2i = json['t2i'] != null ? new T2i.fromJson(json['t2i']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['i2i'] = i2i;
    data['i2v'] = i2v;
    if (t2i != null) {
      data['t2i'] = t2i!.toJson();
    }
    return data;
  }
}

class T2i {
  int? i1;
  int? i2;
  int? i4;
  int? i6;

  T2i({this.i1, this.i2, this.i4, this.i6});

  T2i.fromJson(Map<String, dynamic> json) {
    i1 = json['1'];
    i2 = json['2'];
    i4 = json['4'];
    i6 = json['6'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['1'] = i1;
    data['2'] = i2;
    data['4'] = i4;
    data['6'] = i6;
    return data;
  }
}
