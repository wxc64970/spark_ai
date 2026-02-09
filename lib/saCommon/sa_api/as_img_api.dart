import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/saCommon/sa_models/sa_account_assets.dart';
import 'package:spark_ai/saCommon/sa_models/sa_ai_avatar_options.dart';

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

  /// 获取AI Photo页配置
  static Future<List<ItemConfigs>?> getAiPhoto() async {
    try {
      final res = await api.get(SAApiUrl.aiphoto);
      var baseResponse = AiPhoto.fromJson(res.data);
      return baseResponse.itemConfigs;
    } catch (e) {
      return null;
    }
  }

  /// 获取 ImageStyle 数据
  static Future<List<ImageStyle>?> getImageStyle() async {
    try {
      final res = await api.get(SAApiUrl.imageStyle);
      final data = SABaseModel.fromJson(res.data, null);
      final list = data.data;
      return list == null
          ? []
          : (list as List).map((e) {
              return ImageStyle.fromJson(e);
            }).toList();
    } catch (e) {
      return null;
    }
  }

  // 头像 选项
  static Future<List<AiAvatarOptions>?> getDetailOptions() async {
    try {
      var response = await api.get(SAApiUrl.detailOptionsUrl);
      final result = SABaseModel.fromJson(response.data, null);
      final data = result.data;
      if (data != null && data is List) {
        return data.map((e) => AiAvatarOptions.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      log.e(e);
      return null;
    }
  }

  // 用户资产
  static Future<AccountAssets?> getUserAsset() async {
    try {
      var result = await api.get(SAApiUrl.userAssets);
      var res = SABaseModel.fromJson(
        result.data,
        (data) => AccountAssets.fromJson(data),
      );
      return res.data;
    } catch (e) {
      return null;
    }
  }

  // 头像 AI写作 - 图片提示词
  static Future<String?> avatarAiWriteWords(Map<String, dynamic> params) async {
    try {
      var response = await api.post(SAApiUrl.aiWriteAvatarUrl, data: params);
      final result = SABaseModel.fromJson(response.data, null);
      final data = result.data;
      if (data != null && data is Map) {
        return data['prompt'];
      }
      return null;
    } catch (e) {
      log.e(e);
      return null;
    }
  }

  // 生成头像
  static Future<int?> avatarAiGenerate(Map<String, dynamic> params) async {
    try {
      var res = await api.post(SAApiUrl.generateAvatarUrl, data: params);
      final result = SABaseModel.fromJson(res.data, null);
      final data = result.data;
      if (data != null && data is int) {
        return data;
      }
      return null;
    } catch (e) {
      log.e(e);
      return null;
    }
  }

  // 生成头像结果
  static Future<GenAvatarResulut?> avatarAiGenerateResult(int id) async {
    try {
      log.d('Requesting avatar generation result for id: $id');
      Map<String, String> query = {"id": id.toString()};
      var response = await api.get(
        SAApiUrl.generateAvatarResultUrl,
        queryParameters: query,
      );
      log.d('API Response success: ${response.data}');
      var res = SABaseModel.fromJson(
        response.data,
        (json) => GenAvatarResulut.fromJson(json),
      );
      return res.data;
    } catch (e) {
      log.e('avatarAiGenerateResult error: $e');
      return null;
    }
  }

  /// AI photo 历史记录列表查询
  static Future<List<CreationsHistory>> getAiPhotoHistoryList({
    required int page,
    required int size,
    int? type,
  }) async {
    try {
      var data = {'page': page, 'size': size, 'type': type};
      var res = await api.request(
        SAApiUrl.generateAvatarHistoryUrl,
        data: data,
        method: HttpMethod.post,
      );

      final baseModel = SABaseModel.fromJson(res.data, null);
      final list = SAPagesModel.fromJson(
        baseModel.data,
        (json) => CreationsHistory.fromJson(json),
      );
      return (list.records ?? []).map((e) {
        return e;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // 获取AI photo 历史记录列表总数
  static Future getAiPhotoHistoryCount() async {
    try {
      var response = await api.get(SAApiUrl.generateAvatarHistoryCountUrl);
      final result = SABaseModel.fromJson(response.data, (json) => json);
      final datas = result.data;

      return datas;
    } catch (e) {
      log.e(e);
      return {};
    }
  }

  //AI photo 历史记录删除
  static Future<bool> deleteAiPhotoHistory(List<int> ids) async {
    try {
      var response = await api.post(
        SAApiUrl.generateAvatarHistoryDeleteUrl,
        data: {'ids': ids},
      );
      final result = SABaseModel.fromJson(response.data, null);
      return result.data;
    } catch (e) {
      log.e(e);
      return false;
    }
  }
}
