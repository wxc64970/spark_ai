import 'dart:io';

// 在终端中直接运行 main 方法：
/*
dart run /Users/wangchao/Documents/work/spark_ai/test/tet.dart
*/
/// 入口方法
void main() {
  // 指定文件夹路径（你的开发机上的绝对路径）
  const String folderPath = '/Users/wangchao/Documents/work/spark_ai/lib/saCommon/sa_models';
  // 调用替换方法
  replaceJsonModel(folderPath);

  // 替换 api path 中的字符串
  const String filePath = '/Users/wangchao/Documents/work/spark_ai/lib/saCommon/sa_api/as_api_url.dart';
  replaceApiPath(filePath);
}

/// 替换 api path 路径
void replaceApiPath(String filePath) {
  print('开始处理文件: $filePath');
  // 替换规则
  final Map<String, String> replacementMap = {
    "afruug": "getChatLevel",
    "aknawm": "gems",
    "bxkbaw": "saveMessage",
    "crfqon": "undress",
    "digoir": "getGenImg",
    "dqjodh": "getUndressWithVideo",
    "ecsyis": "unlock",
    "eobllc": "user",
    "fwxltr": "characterMedia",
    "gkrwwk": "create",
    "gppcan": "register",
    "hijcfy": "history",
    "htbkqm": "conversation",
    "htmrzc": "lang",
    "hzbpek": "getUndressWithVideoResult",
    "ihpzvy": "getUndressWith",
    "imbhcx": "verify",
    "iodpzr": "aiChatConversation",
    "ixhmws": "creationCharacter",
    "iymvrp": "selectGenImg",
    "jeereb": "system",
    "kfaqxd": "config",
    "ktoicn": "appUser",
    "kusfxw": "price",
    "lkmgim": "getUndressWithResult",
    "llqjid": "roleplay",
    "lmaorv": "rechargeOrders",
    "lnzltt": "aiWrite",
    "mezrth": "getUndressResult",
    "mvpllf": "getClothingConf",
    "mxqakc": "creationStyleOptions",
    "nwjinz": "clothes",
    "omiuqr": "randomOne",
    "owjdca": "creationMoreDetails",
    "pkcach": "setChatBackground",
    "pnebjj": "translate",
    "pupavw": "consumption",
    "qpwidp": "getAll",
    "rktfsn": "noDress",
    "shdzjx": "getGiftConf",
    "skifon": "getStyleConfig",
    "sxpbjq": "google",
    "taagbh": "message",
    "thupvq": "characters",
    "tireic": "unlockDynamicVideo",
    "ucalbk": "pay",
    "ueozeg": "getByRole",
    "unfkae": "voices",
    "vmjoni": "editMsg",
    "vmzyuy": "appUserReport",
    "vttflp": "platformConfig",
    "vycyao": "subscriptionTransactions",
    "woydtu": "characterProfile",
    "wwpnjf": "noDressHis",
    "xifyik": "gift",
    "xirpaw": "subscription",
    "yajhqe": "userProfile",
    "ybjjrk": "undressResult",
    "ydftcp": "chatLevelConf",
    "ymnzry": "getRecommendRole",
    "ypajks": "upinfo",
    "zwxuax": "isNaked",
    "zxaocc": "undressOutcome",
  };

  // 判断文件是否存在
  final File file = File(filePath);
  if (!file.existsSync()) {
    print('文件不存在: $filePath');
    return;
  }
  print('文件存在，开始读取内容');

  String fileContent = file.readAsStringSync();
  String replacedContent = fileContent;

  // 遍历替换：只替换等号后单引号内的路径内容
  for (final entry in replacementMap.entries) {
    final String newPathSegment = entry.key; // 原路径中的片段（如register）
    final String oldPathSegment = entry.value; // 要替换成的片段（如auiasv）
    print('替换 $oldPathSegment 为 $newPathSegment');

    // 正则匹配规则：
    // 匹配 = 后面的单引号内容中包含 oldPathSegment 的部分
    // 只替换单引号内的目标片段，保留其他内容和变量名
    replacedContent = replacedContent.replaceAllMapped(
      RegExp(
        r'=.*?\'
                "'(.*?" +
            oldPathSegment +
            ".*?)'",
      ),
      (match) {
        // 按路径段替换，只替换被 / 包围的完整路径段
        String matchedContent = match.group(1)!;
        String replacedString = matchedContent.replaceAll(RegExp(r'(?<=^|/)' + RegExp.escape(oldPathSegment) + r'(?=/|$)'), newPathSegment);
        return "= '$replacedString'";
      },
    );
  }

  file.writeAsStringSync(replacedContent);
  print('文件已成功替换: $filePath');
}

/// 替换 model
void replaceJsonModel(String folderPath) {
  // 替换规则
  final Map<String, String> replacementMap = {
    "acokxm": "value",
    "aeduie": "call_ai_characters",
    "afogji": "last_message",
    "akerge": "voice_id",
    "almgyb": "video_message",
    "aosdja": "profile_id",
    "awkaqx": "nsfw",
    "azaobf": "source",
    "azwmwk": "total",
    "bdcxbl": "more_details",
    "bhvgpi": "subscription_end",
    "bjxoft": "profile_change",
    "bpymqb": "gtype",
    "btbvhe": "currency_code",
    "bwmimg": "video_unlock",
    "bxtirl": "chat",
    "bzplez": "generate_video",
    "chrauy": "unlock_card_num",
    "cnbcid": "update_time",
    "cnbkzn": "currency_symbol",
    "coxhkj": "engine",
    "crzcba": "receipt",
    "cuyhea": "gems",
    "cvubbg": "scene",
    "cwctdd": "result_path",
    "cxnsjw": "greetings_voice",
    "dcbzuv": "title",
    "dgfhbb": "next_msgs",
    "dlruzy": "character_video_chat",
    "dnrbes": "style",
    "dolnba": "key",
    "dxgdzw": "visibility",
    "eecvgv": "scene_change",
    "ehajym": "visual",
    "ejtgyq": "adid",
    "emhjdj": "order_num",
    "epmmlz": "image_path",
    "ewvzax": "gen_photo_tags",
    "ezxnby": "vip",
    "fcdxdd": "level",
    "fetoil": "free_message",
    "ffgewn": "price",
    "fhssgc": "card_num",
    "fnjbja": "url",
    "fobttk": "dynamic_encry_time",
    "ftnnit": "shelving",
    "gemadx": "source_language",
    "giusat": "gen_photo",
    "goiscj": "records",
    "gpcyam": "media_text",
    "gpfrfv": "chat_video_price",
    "grgqjo": "reward",
    "gtibvy": "greetings",
    "hbjprx": "original_transaction_id",
    "hdxfjf": "pages",
    "hiacby": "transaction_id",
    "hnvglc": "chat_model",
    "hptwlm": "style_path",
    "htqcfm": "age",
    "huqwyk": "token",
    "iaoapq": "height",
    "icybxg": "translate_answer",
    "ifexox": "lora_strength",
    "itjglp": "text_message",
    "itvyfq": "pay",
    "ivckbi": "gen_img_id",
    "ivezhk": "lock_level_media",
    "jkcnis": "character_name",
    "jskdne": "tags",
    "kcpsov": "audit_status",
    "kddoxf": "voice_url",
    "kfuons": "audio_message",
    "kggdvg": "lora_model",
    "kgzodz": "product_id",
    "knxolc": "choose_env",
    "ktjsuq": "sign",
    "kwtihr": "gname",
    "leidjw": "undress_count",
    "lkdsud": "question",
    "lnoypv": "user_id",
    "maeowl": "uid",
    "mahvzv": "characterId",
    "meievp": "session_count",
    "mjjlmx": "avatar",
    "mphbmo": "message",
    "naokow": "recharge_status",
    "ncbeif": "current",
    "ngqymy": "taskId",
    "nivfuv": "dynamic_encry_status",
    "nlygih": "subscription",
    "nmmgxr": "translate_question",
    "nniivi": "change_clothing",
    "npcejw": "about_me",
    "nxxiam": "amount",
    "nzejps": "signature",
    "ofngwj": "describe_img",
    "ojsnld": "app_user_chat_level",
    "okdqzs": "order_type",
    "okpeqa": "character_id",
    "oteglu": "approved_character_id",
    "pbkrmw": "creation_id",
    "pilmqf": "deserved_gems",
    "plpeso": "gen_video",
    "plpzei": "conv_id",
    "pnpknb": "target_language",
    "pzhczk": "report_type",
    "pztsjn": "style_type",
    "qpdbps": "upgrade",
    "qpghan": "hide_character",
    "qubqwo": "platform",
    "qxcvyk": "media",
    "qxhsyj": "nick_name",
    "qyqvhx": "generate_image",
    "rcixxe": "auto_translate",
    "rhngve": "planned_msg_id",
    "rvaqlw": "size",
    "rxskda": "device_id",
    "sdyukc": "ctype",
    "sfuweu": "create_video",
    "shgjyh": "email",
    "swjztf": "character_images",
    "szleff": "lora_path",
    "tcnbnr": "estimated_time",
    "tfcfdl": "conversation_id",
    "tldysq": "create_time",
    "ttcefd": "idfa",
    "ujgsbx": "voice_duration",
    "unppjw": "password",
    "uqdyrd": "cid",
    "vhcstt": "order_no",
    "vhxdej": "id",
    "vjwrzt": "photo_message",
    "vqfxfw": "audit_time",
    "vubsjl": "enable_auto_translate",
    "wcqaou": "rewards",
    "wdilno": "answer",
    "wdnsho": "msg_id",
    "wfjqwb": "thumbnail_url",
    "wldzbd": "gender",
    "wpdvcs": "style_id",
    "wwqtde": "nickname",
    "xamupl": "fileMd5",
    "xhfnla": "video_chat",
    "xhxxks": "template_id",
    "ximjsl": "create_img",
    "xizstl": "cname",
    "xpobip": "price",
    "xuipur": "activate",
    "xyqkkp": "duration",
    "yclfif": "chat_image_price",
    "yhvtqh": "prompt",
    "ypefqq": "visual_style",
    "yvosho": "name",
    "zbcter": "likes",
    "zckjtp": "free_overrun",
    "zeierr": "model_id",
    "zgczob": "time_need",
    "zoyxby": "lock_level",
    "zrfqrz": "chat_audio_price",
    "zuckcd": "render_style",
  };

  // 获取文件夹
  final Directory directory = Directory(folderPath);
  if (!directory.existsSync()) {
    print('文件夹不存在: $folderPath');
    return;
  }
  final List<FileSystemEntity> files = directory.listSync();

  for (final FileSystemEntity entity in files) {
    if (entity is File) {
      String fileContent = entity.readAsStringSync();

      // 使用简单的字符串替换来避免正则表达式格式化问题
      String replacedContent = fileContent;

      // 遍历所有需要替换的值
      for (final entry in replacementMap.entries) {
        final String oldKey = entry.key;
        final String newValue = entry.value;

        // 替换 JSON 对象中的键名: "key": value
        replacedContent = replacedContent.replaceAll('"$newValue":', '"$oldKey":');

        // 替换 JSON 访问: json['key'] 和 json["key"]
        replacedContent = replacedContent.replaceAll("json['$newValue']", "json['$oldKey']");
        replacedContent = replacedContent.replaceAll('json["$newValue"]', 'json["$oldKey"]');

        // 替换 Map 字面量中的键名: 'key': value 和 "key": value
        replacedContent = replacedContent.replaceAll("'$newValue':", "'$oldKey':");
        replacedContent = replacedContent.replaceAll('"$newValue":', '"$oldKey":');
      }

      entity.writeAsStringSync(replacedContent);
      print('文件已成功替换: ${entity.path}');
    }
  }
}
