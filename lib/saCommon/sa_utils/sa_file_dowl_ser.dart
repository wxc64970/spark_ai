import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

/// Represents different types of files that can be downloaded.
///
/// Each file type has specific properties that determine how files
/// of that type are stored and named in the file system.
enum FileType {
  /// Audio files like mp3, wav, etc.
  audio('Audio', 'audios_files', true),

  /// Video files like mp4, mov, etc.
  video('Video', 'video_files', false),

  /// Image files like jpg, png, etc.
  image('Image', 'image_files', true),

  /// Document files like pdf, doc, etc.
  document('Document', 'document_files', false),

  /// Other file types not covered by specific categories.
  other('File', 'downloads', false);

  /// Display label for the file type.
  final String label;

  /// Default folder name where files of this type are stored.
  final String folderName;

  /// Whether to use hash-based naming for this file type.
  final bool useHashName;

  /// Creates a file type with the specified properties.
  const FileType(this.label, this.folderName, this.useHashName);

  @override
  String toString() => label;
}

/// 下载异常类 - 提供统一的下载错误处理机制
class DownloadException implements Exception {
  /// 错误类型
  final DownloadErrorType type;

  /// 详细错误信息
  final String message;

  /// 原始异常对象
  final dynamic originalException;

  DownloadException(this.type, this.message, [this.originalException]);

  @override
  String toString() => '${type.name}: $message';
}

/// 下载错误类型枚举
enum DownloadErrorType {
  /// 网络连接错误
  connection('连接错误'),

  /// 服务器响应错误
  server('服务器错误'),

  /// 超时错误
  timeout('请求超时'),

  /// 存储错误（写入文件系统失败等）
  storage('存储错误'),

  /// 取消下载
  cancelled('已取消'),

  /// 无效的输入（如空URL等）
  invalidInput('无效输入'),

  /// 其他未分类错误
  other('未知错误');

  final String description;

  const DownloadErrorType(this.description);
}

/// 文件下载进度事件
class DownloadProgressEvent {
  /// 下载URL
  final String url;

  /// 已接收的字节数
  final int received;

  /// 总字节数 (-1表示未知)
  final int total;

  /// 下载进度百分比 (0-100)
  final double progress;

  /// 创建进度事件
  DownloadProgressEvent(this.url, this.received, this.total) : progress = total > 0 ? (received / total * 100) : 0.0;

  @override
  String toString() => 'Progress: ${progress.toStringAsFixed(1)}% ($received/$total)';
}

/// 下载任务状态
enum DownloadStatus {
  /// 等待中
  pending,

  /// 下载中
  downloading,

  /// 已完成
  completed,

  /// 失败
  failed,

  /// 已取消
  cancelled,
}

/// 下载任务信息
class DownloadTask {
  /// 唯一任务ID
  final String id;

  /// 下载URL
  final String url;

  /// 文件类型
  final FileType fileType;

  /// 当前状态
  DownloadStatus status;

  /// 目标文件路径
  String? filePath;

  /// 进度控制器
  final StreamController<DownloadProgressEvent> _progressController;

  /// 取消令牌
  final CancelToken cancelToken;

  /// 下载进度流
  Stream<DownloadProgressEvent> get progressStream => _progressController.stream;

  /// 完成时的回调
  final Completer<String?> completer;

  /// 附加选项
  final Map<String, dynamic> options;

  DownloadTask({required this.url, required this.fileType, required this.options})
    : id = _generateTaskId(url),
      status = DownloadStatus.pending,
      _progressController = StreamController<DownloadProgressEvent>.broadcast(),
      cancelToken = CancelToken(),
      completer = Completer<String?>();

  /// 生成唯一任务ID
  static String _generateTaskId(String url) {
    final bytes = utf8.encode(url);
    final hash = sha256.convert(bytes);
    return hash.toString().substring(0, 16);
  }

  /// 更新下载进度
  void updateProgress(int received, int total) {
    if (!_progressController.isClosed) {
      final progressEvent = DownloadProgressEvent(url, received, total);
      _progressController.add(progressEvent);
      // debugPrint('[DownloadTask] $id $progressEvent');
    }
  }

  /// 取消下载任务
  void cancel() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel('用户取消下载');
      status = DownloadStatus.cancelled;
      if (!completer.isCompleted) {
        completer.completeError(DownloadException(DownloadErrorType.cancelled, '下载已取消'));
      }
    }
  }

  /// 清理资源
  void dispose() {
    if (!_progressController.isClosed) {
      _progressController.close();
    }
  }
}

class FileDownloadService {
  static final FileDownloadService _instance = FileDownloadService._internal();
  FileDownloadService._internal();
  static FileDownloadService get instance => _instance;

  /// 下载锁 - 用于处理并发创建文件夹的竞态条件
  final Map<String, Completer<void>> _folderLock = <String, Completer<void>>{};

  /// 最大并发下载数
  final int _maxConcurrentDownloads = 3;

  /// 活跃的下载任务列表
  final Map<String, DownloadTask> _activeDownloads = {};

  /// 等待中的下载任务队列
  final List<DownloadTask> _downloadQueue = [];

  /// 下载文件
  Future<String?> downloadFile(String url, {String? folderName, bool? useHashName, String? fileExtension, required FileType fileType, void Function(DownloadProgressEvent)? onProgress}) async {
    if (url.isEmpty) {
      debugPrint('[FileDownloadService] Download failed: Empty URL provided');
      throw DownloadException(DownloadErrorType.invalidInput, 'Invalid download URL');
    }

    // Apply configuration with defaults from FileType and optional overrides
    final String actualFolderName = folderName ?? fileType.folderName;
    final bool actualUseHashName = useHashName ?? fileType.useHashName;

    // 创建下载任务
    final task = DownloadTask(url: url, fileType: fileType, options: {'folderName': folderName, 'useHashName': useHashName, 'fileExtension': fileExtension});

    // 注册进度回调
    if (onProgress != null) {
      task.progressStream.listen(onProgress);
    }

    // 检查是否已有相同任务在下载
    if (_activeDownloads.containsKey(task.id)) {
      debugPrint('[FileDownloadService] 任务已存在，复用现有下载: ${task.id}');
      return _activeDownloads[task.id]!.completer.future;
    }

    try {
      // 获取文档目录
      final appDocDir = await path_provider.getApplicationDocumentsDirectory();
      Directory docDir = Directory(appDocDir.path);
      String folderPath = path.join(docDir.path, actualFolderName);

      // 安全创建文件夹（解决race condition）
      await _createFolderSafely(folderPath);

      // 确定文件名和保存路径
      String fileName;
      String savePath;
      String targetFilePath;

      if (actualUseHashName) {
        // 使用哈希命名方式
        String originalFileName = generateFileNameFromUrl(url);
        savePath = path.join(folderPath, originalFileName);

        // 获取文件的扩展名
        String currentExtension = path.extension(originalFileName).toLowerCase();
        String fileNameWithoutExtension = path.basenameWithoutExtension(originalFileName);

        // 如果提供了扩展名覆盖，则使用它
        String finalExtension = fileExtension ?? currentExtension;
        targetFilePath = path.join(folderPath, '$fileNameWithoutExtension$finalExtension');
      } else {
        // 使用原始文件名
        fileName = Uri.parse(url).pathSegments.last;
        savePath = path.join(folderPath, fileName);
        targetFilePath = savePath;

        // 如果提供了扩展名覆盖，则替换原始扩展名
        if (fileExtension != null) {
          String fileNameWithoutExtension = path.basenameWithoutExtension(fileName);
          targetFilePath = path.join(folderPath, '$fileNameWithoutExtension$fileExtension');
        }
      }

      // 规范化路径，确保分隔符一致
      targetFilePath = path.normalize(targetFilePath);

      // 检查文件是否已存在
      bool fileExists = await File(targetFilePath).exists();
      if (fileExists) {
        debugPrint('[FileDownloadService] $fileType already exists, path: $targetFilePath');
        task.filePath = targetFilePath;
        task.status = DownloadStatus.completed;
        task.completer.complete(targetFilePath);
        return targetFilePath;
      } else {
        debugPrint('[FileDownloadService] $fileType does not exist, path: $targetFilePath');
      }

      // 将任务添加到活跃下载列表或等待队列
      if (_activeDownloads.length < _maxConcurrentDownloads) {
        // 使用this调用实例方法
        return _startDownload(task, savePath, targetFilePath);
      } else {
        // 添加到等待队列
        debugPrint('[FileDownloadService] 队列已满，任务进入等待: ${task.id}');
        _downloadQueue.add(task);
        return task.completer.future;
      }
    } catch (e, stackTrace) {
      // 处理异常并转换为标准化的DownloadException
      final exception = _convertToDownloadException(e, url);
      debugPrint('[FileDownloadService] $fileType download failed: ${exception.message}, URL: $url');
      debugPrint('[FileDownloadService] Stack trace: $stackTrace');

      // 更新任务状态
      if (_activeDownloads.containsKey(task.id)) {
        _activeDownloads[task.id]!.status = DownloadStatus.failed;
        _activeDownloads.remove(task.id);

        // 处理等待队列中的下一个任务
        _processNextQueuedDownload();
      }

      // 完成任务（失败）
      if (!task.completer.isCompleted) {
        task.completer.completeError(exception);
      }

      return null;
    }
  }

  /// 启动下载任务
  Future<String?> _startDownload(DownloadTask task, String savePath, String targetFilePath) async {
    // 将任务添加到活跃下载列表
    _activeDownloads[task.id] = task;
    task.status = DownloadStatus.downloading;

    debugPrint('[FileDownloadService] Starting download: ${task.url}');

    try {
      final dio = Dio();

      // 配置超时和请求头
      final options = Options(receiveTimeout: const Duration(minutes: 5), sendTimeout: const Duration(minutes: 2));

      await dio.download(
        task.url,
        savePath,
        options: options,
        cancelToken: task.cancelToken,
        onReceiveProgress: (received, total) {
          task.updateProgress(received, total);
        },
      );

      // 下载完成，处理重命名
      if (savePath != targetFilePath) {
        File downloadedFile = File(savePath);
        if (downloadedFile.existsSync()) {
          File newFile = await downloadedFile.rename(targetFilePath);
          debugPrint('[FileDownloadService] ${task.fileType} downloaded and renamed successfully, path: $targetFilePath');
          task.filePath = newFile.path;
        }
      } else {
        task.filePath = savePath;
        debugPrint('[FileDownloadService] ${task.fileType} download completed, path: $savePath');
      }

      // 更新任务状态并从活跃列表中移除
      task.status = DownloadStatus.completed;
      _activeDownloads.remove(task.id);

      // 完成任务（成功）
      if (!task.completer.isCompleted) {
        task.completer.complete(task.filePath);
      }

      // 处理等待队列中的下一个任务
      _processNextQueuedDownload();

      return task.filePath;
    } catch (e, stackTrace) {
      // 错误处理
      final exception = _convertToDownloadException(e, task.url);
      debugPrint('[FileDownloadService] ${task.fileType} download failed: ${exception.message}, URL: ${task.url}');
      debugPrint('[FileDownloadService] Stack trace: $stackTrace');

      // 更新任务状态并从活跃列表中移除
      task.status = DownloadStatus.failed;
      _activeDownloads.remove(task.id);

      // 完成任务（失败）
      if (!task.completer.isCompleted) {
        task.completer.completeError(exception);
      }

      // 处理等待队列中的下一个任务
      _processNextQueuedDownload();

      return null;
    }
  }

  /// 处理队列中的下一个下载任务
  void _processNextQueuedDownload() {
    if (_downloadQueue.isNotEmpty && _activeDownloads.length < _maxConcurrentDownloads) {
      final nextTask = _downloadQueue.removeAt(0);

      // 创建下载参数
      Map<String, dynamic> options = {};
      if (nextTask.options['folderName'] != null) {
        options['folderName'] = nextTask.options['folderName'];
      }
      if (nextTask.options['useHashName'] != null) {
        options['useHashName'] = nextTask.options['useHashName'];
      }
      if (nextTask.options['fileExtension'] != null) {
        options['fileExtension'] = nextTask.options['fileExtension'];
      }

      // 启动下载（会自动加入到活跃下载列表）并保持原始completer
      String? folderName = nextTask.options['folderName'];
      bool? useHashName = nextTask.options['useHashName'];
      String? fileExtension = nextTask.options['fileExtension'];

      // 直接重用已有的completer，不创建新的Promise链
      _startNextDownloadTask(nextTask, folderName, useHashName, fileExtension);
    }
  }

  /// 启动队列中的下一个下载任务（内部辅助方法）
  Future<void> _startNextDownloadTask(DownloadTask task, String? folderName, bool? useHashName, String? fileExtension) async {
    try {
      // 获取文档目录
      final appDocDir = await path_provider.getApplicationDocumentsDirectory();
      Directory docDir = Directory(appDocDir.path);
      String folderPath = path.join(docDir.path, folderName ?? task.fileType.folderName);

      // 安全创建文件夹（解决race condition）
      await _createFolderSafely(folderPath);

      // 确定文件名和保存路径
      bool actualUseHashName = useHashName ?? task.fileType.useHashName;
      String fileName;
      String savePath;

      if (actualUseHashName) {
        fileName = generateFileNameFromUrl(task.url);
      } else {
        fileName = Uri.parse(task.url).pathSegments.last;
      }

      savePath = path.join(folderPath, fileName);
      String targetFilePath = savePath;

      // 如果提供了扩展名覆盖，则替换原始扩展名
      if (fileExtension != null) {
        String fileNameWithoutExtension = path.basenameWithoutExtension(fileName);
        targetFilePath = path.join(folderPath, '$fileNameWithoutExtension$fileExtension');
      }

      // 规范化路径，确保分隔符一致
      targetFilePath = path.normalize(targetFilePath);

      // 检查文件是否已存在
      bool fileExists = await File(targetFilePath).exists();
      if (fileExists) {
        debugPrint('[FileDownloadService] ${task.fileType} already exists, path: $targetFilePath');
        task.filePath = targetFilePath;
        task.status = DownloadStatus.completed;
        if (!task.completer.isCompleted) {
          task.completer.complete(targetFilePath);
        }
      } else {
        // 直接使用_startDownload开始下载
        final result = await _startDownload(task, savePath, targetFilePath);
        if (!task.completer.isCompleted) {
          task.completer.complete(result);
        }
      }
    } catch (error) {
      if (!task.completer.isCompleted) {
        task.completer.completeError(error);
      }
    }
  }

  /// 安全创建文件夹（解决race condition）
  Future<void> _createFolderSafely(String folderPath) async {
    // 已存在则直接返回
    if (Directory(folderPath).existsSync()) {
      return;
    }

    // 检查是否已有创建过程在进行中
    if (_folderLock.containsKey(folderPath)) {
      // 等待已有的创建过程完成
      await _folderLock[folderPath]!.future;
      return;
    }

    // 创建锁
    final completer = Completer<void>();
    _folderLock[folderPath] = completer;

    try {
      // 再次检查，可能在获取锁期间被其他线程创建
      if (!Directory(folderPath).existsSync()) {
        await Directory(folderPath).create(recursive: true);
      }
      completer.complete();
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _folderLock.remove(folderPath);
    }
  }

  /// 将异常转换为统一的DownloadException
  DownloadException _convertToDownloadException(dynamic error, String url) {
    if (error is DownloadException) {
      return error;
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return DownloadException(DownloadErrorType.timeout, '请求超时', error);
        case DioExceptionType.badResponse:
          return DownloadException(DownloadErrorType.server, '服务器错误: ${error.response?.statusCode ?? "Unknown"}', error);
        case DioExceptionType.connectionError:
          return DownloadException(DownloadErrorType.connection, '网络连接错误', error);
        case DioExceptionType.cancel:
          return DownloadException(DownloadErrorType.cancelled, '下载已取消', error);
        default:
          return DownloadException(DownloadErrorType.other, '下载失败: ${error.message}', error);
      }
    } else if (error is FileSystemException) {
      return DownloadException(DownloadErrorType.storage, '存储错误: ${error.message}', error);
    }

    return DownloadException(DownloadErrorType.other, '下载错误: ${error.toString()}', error);
  }

  /// 获取活跃的下载任务列表
  List<DownloadTask> getActiveDownloads() {
    return _activeDownloads.values.toList();
  }

  /// 获取等待中的下载任务队列
  List<DownloadTask> getQueuedDownloads() {
    return List.from(_downloadQueue);
  }

  /// 取消下载任务
  Future<void> cancelDownload(String taskId) async {
    // 检查活跃下载
    if (_activeDownloads.containsKey(taskId)) {
      _activeDownloads[taskId]!.cancel();
      _activeDownloads.remove(taskId);

      // 处理等待队列中的下一个任务
      _processNextQueuedDownload();
      return;
    }

    // 检查等待队列
    final queueIndex = _downloadQueue.indexWhere((task) => task.id == taskId);
    if (queueIndex >= 0) {
      final task = _downloadQueue.removeAt(queueIndex);
      task.cancel();
    }
  }

  /// 取消所有下载任务
  Future<void> cancelAllDownloads() async {
    // 取消活跃下载
    for (final task in _activeDownloads.values) {
      task.cancel();
    }
    _activeDownloads.clear();

    // 取消等待队列
    for (final task in _downloadQueue) {
      task.cancel();
    }
    _downloadQueue.clear();
  }

  /// 根据URL生成唯一的文件名
  String generateFileNameFromUrl(String url) {
    final bytes = utf8.encode(url);
    final hash = sha256.convert(bytes);
    final fileName = Uri.parse(url).pathSegments.isEmpty ? 'file' : Uri.parse(url).pathSegments.last;
    final hashedPrefix = hash.toString().substring(0, 16);
    return '$hashedPrefix-$fileName';
  }
}
