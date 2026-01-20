// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_test/flutter_test.dart';
import 'package:spark_ai/saCommon/index.dart';

//运行命令： flutter test test/widget_test1.dart
void main() {
  setUpAll(() async {
    // 初始化环境配置
    await EnvConfig.initialize(.dev);
  });

  test('ACryptoFactory encrypt and decrypt test', () {
    String imageUrl = 'images/1998220440831078402';

    String videoUrl = 'images/1926887945078358018';

    // 测试加密和解密往返
    final encryptedImageUrl = SACryptoUtil.encrypt(imageUrl);
    final decryptedImageUrl = SACryptoUtil.decrypt(encryptedImageUrl);
    print('Encrypted imageUrl: $encryptedImageUrl');
    print('Decrypted imageUrl: $decryptedImageUrl');

    final encryptedVideoUrl = SACryptoUtil.encrypt(videoUrl);
    final decryptedVideoUrl = SACryptoUtil.decrypt(encryptedVideoUrl);
    print('Encrypted videoUrl: $encryptedVideoUrl');
    print('Decrypted videoUrl: $decryptedVideoUrl');
  });
}
