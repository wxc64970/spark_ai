import 'dart:io';

// 在终端中直接运行 main 方法：
/*
dart run /Users/wangchao/Documents/work/soul_talk/test/tet.dart
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
    "ajswzz": "undress",
    "alemox": "editMsg",
    "atbkwp": "verify",
    "bihmnq": "getUndressWithVideoResult",
    "bqzvqq": "price",
    "btmrti": "characterMedia",
    "curtvn": "platformConfig",
    "dbjwao": "unlock",
    "dmfezb": "creationCharacter",
    "duowmu": "getUndressResult",
    "ebdbre": "saveMessage",
    "ejmlyd": "getStyleConfig",
    "esxkpr": "google",
    "fdvzka": "consumption",
    "fiwsqs": "register",
    "ftovbx": "message",
    "gkvofx": "aiWrite",
    "gogiws": "creationStyleOptions",
    "hfcpel": "config",
    "ibcnif": "getUndressWith",
    "jkjgbm": "getUndressWithResult",
    "jmrfzr": "characters",
    "jpjlvg": "history",
    "kobrsh": "noDress",
    "mcomry": "undressResult",
    "mgyaez": "gift",
    "mrqhox": "chatLevelConf",
    "mwhyub": "getRecommendRole",
    "nbnatt": "userProfile",
    "nfciox": "roleplay",
    "nvkwbm": "isNaked",
    "nybjpo": "appUserReport",
    "oezugw": "setChatBackground",
    "pdychc": "randomOne",
    "preedu": "getByRole",
    "ptmyjv": "aiChatConversation",
    "rviput": "create",
    "tavjlz": "getClothingConf",
    "tyicbr": "creationMoreDetails",
    "ufsdwq": "conversation",
    "vbucnb": "getAll",
    "vcpatc": "gems",
    "vezqoi": "system",
    "vhhnfv": "voices",
    "vnxqrt": "upinfo",
    "vpejxh": "characterProfile",
    "vqpeck": "selectGenImg",
    "vurnbe": "subscription",
    "wwbbfs": "appUser",
    "xcetkg": "rechargeOrders",
    "xsqwav": "translate",
    "xvkuzg": "clothes",
    "xxdjob": "undressOutcome",
    "xyytye": "user",
    "xzyzrj": "subscriptionTransactions",
    "ycmryk": "noDressHis",
    "yfjygk": "getGiftConf",
    "ygpbul": "pay",
    "ylgojq": "lang",
    "zgueey": "getUndressWithVideo",
    "zhnrxq": "getGenImg",
    "zhsixn": "getChatLevel",
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
    final String newPathSegment = entry.value; // 原路径中的片段（如register）
    final String oldPathSegment = entry.key; // 要替换成的片段（如auiasv）
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
    "anmdzt": "translate_answer",
    "atxiru": "gtype",
    "axqlrf": "age",
    "belybc": "device_id",
    "bgfmwx": "total",
    "bgpokc": "character_video_chat",
    "bhaaeu": "create_time",
    "bydadx": "result_path",
    "byuibq": "chat_audio_price",
    "bzpwhx": "price",
    "ceemch": "pages",
    "cguhpe": "original_transaction_id",
    "ckquuw": "create_video",
    "ckvtcp": "gen_video",
    "cmpmjx": "gender",
    "cnzdsn": "height",
    "derzjj": "size",
    "dfzkky": "vip",
    "dhdgbh": "gen_photo_tags",
    "dkkpss": "video_chat",
    "dlcyes": "character_name",
    "dravyd": "engine",
    "dvsmqa": "token",
    "dymknr": "change_clothing",
    "ecepcp": "name",
    "efpvto": "visibility",
    "ekhdcy": "audit_time",
    "fdrmxr": "gen_img_id",
    "fhhiib": "ctype",
    "fmdaft": "records",
    "fpofen": "idfa",
    "fwtvyo": "card_num",
    "fxfxji": "describe_img",
    "fzqdod": "order_no",
    "gdakxc": "planned_msg_id",
    "girqdo": "title",
    "gkkdpi": "voice_duration",
    "glsnli": "style_id",
    "gocwti": "profile_change",
    "gqxkfr": "photo_message",
    "gxqhgi": "likes",
    "hcvmld": "nick_name",
    "hdgkrn": "undress_count",
    "hejosr": "thumbnail_url",
    "hfnjwa": "audit_status",
    "ievhuj": "gems",
    "ifanni": "password",
    "igeini": "subscription_end",
    "ihxkkh": "user_id",
    "ijphux": "chat_video_price",
    "ilnogt": "product_id",
    "inmrid": "platform",
    "ionbar": "approved_character_id",
    "iukgei": "receipt",
    "jirrpq": "hide_character",
    "jljelq": "lock_level",
    "jlzwak": "avatar",
    "jnyckn": "amount",
    "jpwzua": "free_overrun",
    "jruagq": "duration",
    "juwyba": "target_language",
    "jvqymv": "greetings_voice",
    "jvwpdx": "characterId",
    "kixmpd": "scene_change",
    "koozky": "msg_id",
    "kpdawv": "style",
    "kutixv": "chat_image_price",
    "kwubdr": "character_id",
    "kyudzr": "email",
    "kzhiqc": "reward",
    "lazqsz": "app_user_chat_level",
    "lejcti": "lock_level_media",
    "llmxmx": "taskId",
    "llruxr": "nsfw",
    "louafp": "lora_model",
    "lxrcym": "cid",
    "lybmgi": "style_path",
    "lyoxab": "profile_id",
    "mbqzsv": "scene",
    "mfkgdc": "render_style",
    "mgdzgp": "fileMd5",
    "mobicv": "recharge_status",
    "moxehb": "conv_id",
    "mqblzk": "visual_style",
    "mvafyw": "key",
    "mvvzca": "video_unlock",
    "mxsvrh": "url",
    "nacoze": "text_message",
    "nezhvc": "unlock_card_num",
    "njcffz": "adid",
    "nmptpa": "translate_question",
    "nmyrpz": "enable_auto_translate",
    "nonvlh": "lora_strength",
    "npihqd": "uid",
    "nqjhyq": "image_path",
    "ohkxcp": "about_me",
    "oorahw": "audio_message",
    "ovybaf": "nickname",
    "oxynsn": "video_message",
    "paeedx": "transaction_id",
    "plipkg": "voice_id",
    "pmclpa": "shelving",
    "pmzfmp": "subscription",
    "prgjhe": "sign",
    "qmnzol": "rewards",
    "qpfrjq": "question",
    "qwdsau": "choose_env",
    "qwewkg": "order_type",
    "qyrhrw": "currency_symbol",
    "rbxwvj": "chat",
    "rfgwmr": "generate_video",
    "rgvbyk": "message",
    "rumzpy": "update_time",
    "ryyotg": "level",
    "rzsjgu": "time_need",
    "sbiyri": "gen_photo",
    "seksbb": "source",
    "sgefhi": "template_id",
    "sjcyld": "generate_image",
    "skudaj": "call_ai_characters",
    "skvpuk": "style_type",
    "ssuxkt": "source_language",
    "suhuoy": "conversation_id",
    "svntrp": "session_count",
    "tinidq": "voice_url",
    "tmvbyk": "creation_id",
    "tnowlc": "visual",
    "toatyt": "model_id",
    "tpaask": "id",
    "tuvkta": "lora_path",
    "txrmzh": "character_images",
    "uscphg": "price",
    "uyeurm": "estimated_time",
    "uygtfu": "currency_code",
    "vhbjmf": "free_message",
    "vpkjrx": "chat_model",
    "vvusun": "signature",
    "wioxvu": "cname",
    "wtyeqk": "greetings",
    "wwbxtp": "report_type",
    "wzcksu": "answer",
    "xeqlih": "auto_translate",
    "xolsxb": "order_num",
    "xutdhx": "more_details",
    "xwgchr": "tags",
    "xxzmhn": "create_img",
    "xysqqj": "pay",
    "yjqban": "activate",
    "ykwinz": "upgrade",
    "ypozjc": "next_msgs",
    "yrhcip": "value",
    "zaroqm": "deserved_gems",
    "zjbhha": "gname",
    "zksqzi": "last_message",
    "zljeme": "media",
    "znjutt": "current",
    "zzlujv": "prompt",
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
        final String oldKey = entry.value;
        final String newValue = entry.key;

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
