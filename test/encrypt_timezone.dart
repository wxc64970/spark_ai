import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:encrypt/encrypt.dart';

void main() {
  // 使用项目中的密钥和 IV
  final key = Key.fromUtf8('MvnB6A0kVzLY3CnF');
  final iv = IV.fromUtf8('VAsuFScd6f9UBhwE');
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

  String encrypt(String content) {
    if (content.isEmpty) return content;
    final encrypted = encrypter.encrypt(content, iv: iv);
    return hex.encode(encrypted.bytes);
  }

  // 需要加密的时区字符串
  final timeZones = [
    'Shanghai',
    'Urumqi',
    'Chongqing',
    'Chungking',
    'Harbin',
    'Kashgar',
    'Beijing',
    'Hong_Kong',
    'Macau',
    'PRC',
  ];

  print('加密后的时区字符串：\n');
  for (var tz in timeZones) {
    final encrypted = encrypt(tz);
    print("'$encrypted', // $tz");
  }
}
