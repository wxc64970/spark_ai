import 'package:flutter/services.dart';
import 'package:spark_ai/main.dart';

class SASimBook {
  static const MethodChannel _channel = MethodChannel('cj_sim_check');

  static Future<bool> cjHasSimCard() async {
    try {
      final bool result = await _channel.invokeMethod('cjHasSimCard');
      return result;
    } on PlatformException catch (e) {
      log.e("Failed to get sim card status: '${e.message}'.");
      return false;
    }
  }
}
