class ImageStyle {
  int? id;
  String? name;
  String? remark;
  String? cover;
  int? styleType;
  String? modelName;
  String? loraModel;
  double? loraStrength;
  String? loraPath;
  int? orderNum;
  String? platform;
  String? createTime;
  String? updateTime;
  bool? del;

  ImageStyle({
    this.id,
    this.name,
    this.remark,
    this.cover,
    this.styleType,
    this.modelName,
    this.loraModel,
    this.loraStrength,
    this.loraPath,
    this.orderNum,
    this.platform,
    this.createTime,
    this.updateTime,
    this.del,
  });

  ImageStyle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    remark = json['remark'];
    cover = json['cover'];
    styleType = json['style_type'];
    modelName = json['model_name'];
    loraModel = json['lora_model'];
    loraStrength = json['lora_strength'];
    loraPath = json['lora_path'];
    orderNum = json['order_num'];
    platform = json['platform'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    del = json['del'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['remark'] = remark;
    data['cover'] = cover;
    data['style_type'] = styleType;
    data['model_name'] = modelName;
    data['lora_model'] = loraModel;
    data['lora_strength'] = loraStrength;
    data['lora_path'] = loraPath;
    data['order_num'] = orderNum;
    data['platform'] = platform;
    data['create_time'] = createTime;
    data['update_time'] = updateTime;
    data['del'] = del;
    return data;
  }
}
