import 'package:flutter/services.dart';
import 'package:spark_ai/main.dart';

class SASimBook {
  static const MethodChannel _channel = MethodChannel('sa_sim_check');

  static Future<bool> saHasSimCard() async {
    try {
      final bool result = await _channel.invokeMethod('saHasSimCard');
      return result;
    } on PlatformException catch (e) {
      log.e("Failed to get sim card status: '${e.message}'.");
      return false;
    }
  }
}
