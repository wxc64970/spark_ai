import 'dart:io';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:http/http.dart' as http;
import 'package:photo_manager/photo_manager.dart';

import 'index.dart';

class SaaigenerateresultController extends GetxController {
  SaaigenerateresultController();

  final state = SaaigenerateresultState();

  static const Duration _actionDebounceDuration = Duration(milliseconds: 800);
  DateTime? _lastDownloadClickAt;
  bool _isDownloading = false;

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    state.reslut = Get.arguments;
    state.imageUrls = state.reslut?.imageList ?? [];
    SA.login.fetchUserInfo();
  }

  bool _isDebouncedClick(DateTime? lastClickAt) {
    if (lastClickAt == null) {
      return false;
    }
    return DateTime.now().difference(lastClickAt) < _actionDebounceDuration;
  }

  Future<void> downloadImageToGallery() async {
    if (_isDownloading || _isDebouncedClick(_lastDownloadClickAt)) {
      return;
    }
    _lastDownloadClickAt = DateTime.now();
    _isDownloading = true;
    try {
      // 检查权限
      final hasPermission = await _requestPermission();
      if (!hasPermission) {
        SAToast.show(SATextData.imagePermission);
        return;
      }

      // 下载图片
      SALoading.show();
      final imageUrl = state.imageUrls[state.selectedIndex];
      final response = await http.get(Uri.parse(imageUrl));
      await SALoading.close();

      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;
        // 保存到相册
        await PhotoManager.editor.saveImage(
          imageBytes,
          filename: 'AI_Character_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        SAToast.show(SATextData.imageSaved);
      } else {
        SAToast.show(SATextData.downloadFailed);
      }
    } catch (e) {
      log.e('Error: ${e.toString()}');
      SAToast.show('Error: ${e.toString()}');
    } finally {
      _isDownloading = false;
    }
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      // Android 13+ 使用新的权限模型
      if (await Permission.photos.isGranted) {
        return true;
      }

      final status = await Permission.photos.request();
      if (status.isGranted) {
        return true;
      }

      // 如果photos权限被拒绝，尝试storage权限（适用于旧版本Android）
      if (await Permission.storage.isGranted) {
        return true;
      }

      final storageStatus = await Permission.storage.request();
      return storageStatus.isGranted;
    } else if (Platform.isIOS) {
      // iOS 使用photos权限
      if (await Permission.photos.isGranted) {
        return true;
      }

      final status = await Permission.photos.request();
      return status.isGranted;
    }

    return false;
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
