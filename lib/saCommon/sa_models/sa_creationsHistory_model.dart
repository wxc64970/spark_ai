class CreationsHistory {
  int? id;
  int? type;
  String? originUrl;
  String? resultUrl;
  String? style;
  int? genImgId;
  String? taskId;
  int? createTime;
  String? genStatus;

  CreationsHistory({
    this.id,
    this.type,
    this.originUrl,
    this.resultUrl,
    this.style,
    this.genImgId,
    this.taskId,
    this.createTime,
    this.genStatus,
  });

  CreationsHistory.fromJson(Map<String, dynamic> json) {
    id = json['vhxdej'];
    type = json['type'];
    originUrl = json['origin_url'];
    resultUrl = json['result_url'];
    style = json['dnrbes'];
    genImgId = json['ivckbi'];
    taskId = json['task_id'];
    createTime = json['tldysq'];
    genStatus = json['gen_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['origin_url'] = originUrl;
    data['result_url'] = resultUrl;
    data['style'] = style;
    data['gen_img_id'] = genImgId;
    data['task_id'] = taskId;
    data['create_time'] = createTime;
    data['gen_status'] = genStatus;
    return data;
  }
}
