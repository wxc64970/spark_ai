import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:spark_ai/saCommon/index.dart';

class ImageAPI {
  /// 获取风格配置
  static Future<List<SAImgStyle>> fetchStyleConf() async {
    final resp = await api.post(SAApiUrl.styleConf);
    final data = SABaseModel.fromJson(resp.data, null);
    final list = data.data;
    return list == null
        ? []
        : (list as List).map((e) {
            return SAImgStyle.fromJson(e);
          }).toList();
  }

  /// ai生成图片历史
  static Future<List<SAImageHistroy>?> getHistory(String characterId) async {
    try {
      const path = SAApiUrl.aiGetHistroy;
      final baseRes = await api.post(path, data: {"character_id": characterId});
      final resp = SAPagesModel.fromJson(
        baseRes.data,
        (json) => SAImageHistroy.fromJson(json),
      );
      // final resp = baseRes.data["records"];
      return (resp.records ?? []).map((e) {
        return e;
      }).toList();
    } catch (e) {
      SALoading.close();
      return null;
    }
  }

  /// 上传图片, ai 图片
  /// 角色
  static Future<SAImgUpModle?> uploadRoleImage({
    required String style,
    required String characterId,
  }) async {
    try {
      // 上传图片
      final formData = dio.FormData.fromMap({
        'style': style,
        'characterId': characterId,
      });
      final ops = dio.Options(
        receiveTimeout: const Duration(seconds: 160),
        contentType: 'multipart/form-data',
      );

      const path = SAApiUrl.upImageForAiImage;
      final response = await api.uploadFile(path, data: formData, options: ops);
      final json = response.data['data'];
      final data = SAImgUpModle.fromJson(json);
      return data;
    } catch (e) {
      return null;
    }
  }

  static Future<SAImgUpModle?> uploadAiImage({
    required String imagePath,
    required String style,
  }) async {
    try {
      // 选择图片
      final file = File(imagePath);

      // 压缩和转换后的文件
      final processedFile = await SAImageUtils.processImage(file);
      if (processedFile == null) {
        return null;
      }

      // 上传图片
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(
          processedFile.path,
          filename: 'img_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
        'style': style,
      });

      final ops = dio.Options(
        receiveTimeout: const Duration(seconds: 180),
        contentType: 'multipart/form-data',
        method: 'POST',
      );

      const path = SAApiUrl.upImageForAiImage;

      var response = await api.uploadFile(path, data: formData, options: ops);
      final json = response.data['data'];
      final data = SAImgUpModle.fromJson(json);
      return data;
    } catch (e) {
      return null;
    }
  }

  /// 获取任务结果 ai 图片
  static Future<ImageResultRes?> getImageResult(
    String taskId, {
    int attempt = 0,
    int maxAttempts = 30,
  }) async {
    try {
      final res = await api.post(
        SAApiUrl.aiImageResult,
        queryParameters: {'taskId': taskId},
      );
      var baseResponse = SABaseModel.fromJson(res.data, null);
      final json = baseResponse.data;

      if (json == null) {
        await Future.delayed(const Duration(seconds: 15));
        return await getImageResult(
          taskId,
          attempt: attempt + 1,
          maxAttempts: maxAttempts,
        );
      } else {
        final data = ImageResultRes.fromJson(json);
        if (data.status == 2) {
          return data;
        } else if (attempt < maxAttempts) {
          await Future.delayed(const Duration(seconds: 15));
          return await getImageResult(
            taskId,
            attempt: attempt + 1,
            maxAttempts: maxAttempts,
          );
        } else {
          return null; // 达到最大递归次数后返回null
        }
      }
    } catch (e) {
      return null;
    }
  }

  /// 上传图片, ai 视频
  static Future<SAImgUpModle?> uploadImgToVideo({
    required String imagePath,
    required String enText,
  }) async {
    try {
      // 选择图片
      final file = File(imagePath);

      /// 文件 md5
      var md5 = await SAImageUtils.calculateMd5(file);

      // 压缩和转换后的文件
      final processedFile = await SAImageUtils.processImage(file);
      if (processedFile == null) {
        return null;
      }

      // 上传图片
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(
          processedFile.path,
          filename: 'img_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
        'style': enText,
        'fileMd5': md5,
      });

      final ops = dio.Options(
        receiveTimeout: const Duration(seconds: 180),
        contentType: 'multipart/form-data',
        method: 'POST',
      );

      const path = SAApiUrl.upImageForAiVideo;

      final response = await api.uploadFile(path, data: formData, options: ops);
      final json = response.data['data'];
      final data = SAImgUpModle.fromJson(json);
      return data;
    } catch (e) {
      return null;
    }
  }

  /// 获取任务结果 ai 视频
  static Future<ImageVideoResItem?> getVideoResult(
    String taskId, {
    int attempt = 0,
    int maxAttempts = 30,
  }) async {
    try {
      final res = await api.post(
        SAApiUrl.aiVideoResult,
        queryParameters: {'taskId': taskId},
      );
      final json = res.data['data'];

      if (json == null) {
        await Future.delayed(const Duration(seconds: 15));
        return await getVideoResult(
          taskId,
          attempt: attempt + 1,
          maxAttempts: maxAttempts,
        );
      } else {
        final data = ImageVideoResult.fromJson(json);
        final item = data.item;

        if (item != null && item.resultPath?.isNotEmpty == true) {
          return item;
        } else if (attempt < maxAttempts) {
          await Future.delayed(const Duration(seconds: 15));
          return await getVideoResult(
            taskId,
            attempt: attempt + 1,
            maxAttempts: maxAttempts,
          );
        } else {
          return null; // 达到最大递归次数后返回null
        }
      }
    } catch (e) {
      return null;
    }
  }

  /// sku 列表
  static Future<List<SASkModel>?> getSkuList() async {
    return await Api.getSkuList();
  }
}
