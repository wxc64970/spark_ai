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

  // 需要加密的 URL
  final videoBgUrl = 'https://static.amorai.net/images/2000809388044529665.mp4';
  final videoFirstFrameUrl = 'https://static.amorai.net/images/2000809388044529665.mp4?x-oss-process=video/snapshot,t_0,f_jpg,w_900,h_1600,m_fast';

  print('加密后的 URL：\n');
  print('_videoBgUrl:');
  print("'${encrypt(videoBgUrl)}'");
  print('\n_videoFirstFrameUrl:');
  print("'${encrypt(videoFirstFrameUrl)}'");
}
