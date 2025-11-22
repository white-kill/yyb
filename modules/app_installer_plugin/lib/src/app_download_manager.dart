import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'download_task.dart';

/// 应用下载管理器
class AppDownloadManager {
  static final AppDownloadManager _instance = AppDownloadManager._internal();
  factory AppDownloadManager() => _instance;
  AppDownloadManager._internal();

  final Dio _dio = Dio();
  final Map<String, DownloadTask> _downloadTasks = {};
  final Map<String, CancelToken> _cancelTokens = {};

  /// 获取所有下载任务
  Map<String, DownloadTask> get tasks => _downloadTasks;

  /// 开始下载
  /// 
  /// [url] 下载链接
  /// [appName] 应用名称
  /// [appIcon] 应用图标URL（可选）
  /// [packageName] 包名（可选）
  /// [onProgress] 进度回调（可选）
  /// [onStatusChange] 状态变化回调（可选）
  /// [onError] 错误回调（可选）
  Future<DownloadTask> startDownload({
    required String url,
    required String appName,
    String? appIcon,
    String? packageName,
    DownloadProgressCallback? onProgress,
    DownloadStatusCallback? onStatusChange,
    DownloadErrorCallback? onError,
  }) async {
    // 如果已经存在该任务，返回现有任务
    if (_downloadTasks.containsKey(url)) {
      return _downloadTasks[url]!;
    }

    // 获取下载目录
    final directory = await _getDownloadDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.apk';
    final savePath = '${directory.path}/$fileName';

    // 创建下载任务
    final task = DownloadTask(
      url: url,
      appName: appName,
      appIcon: appIcon,
      packageName: packageName,
      savePath: savePath,
      status: DownloadStatus.downloading,
      progress: 0.0,
      onProgress: onProgress,
      onStatusChange: onStatusChange,
      onError: onError,
    );

    _downloadTasks[url] = task;

    // 触发状态变化回调
    onStatusChange?.call(DownloadStatus.downloading, task);

    // 创建取消令牌
    final cancelToken = CancelToken();
    _cancelTokens[url] = cancelToken;

    try {
      // 开始下载
      await _dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            task.progress = progress;
            task.downloadedBytes = received;
            task.totalBytes = total;
            
            // 触发进度回调
            task.onProgress?.call(received, total, progress);
            task.notifyListeners();
          }
        },
      );

      // 下载完成
      task.status = DownloadStatus.completed;
      task.progress = 1.0;
      task.onStatusChange?.call(DownloadStatus.completed, task);
      task.notifyListeners();
    } on DioException catch (e) {
      // 下载失败
      if (CancelToken.isCancel(e)) {
        task.status = DownloadStatus.cancelled;
        task.onStatusChange?.call(DownloadStatus.cancelled, task);
      } else {
        task.status = DownloadStatus.failed;
        task.error = e.message ?? e.toString();
        task.onError?.call(task.error!, task);
        task.onStatusChange?.call(DownloadStatus.failed, task);
      }
      task.notifyListeners();
    } catch (e) {
      // 其他错误
      task.status = DownloadStatus.failed;
      task.error = e.toString();
      task.onError?.call(task.error!, task);
      task.onStatusChange?.call(DownloadStatus.failed, task);
      task.notifyListeners();
    } finally {
      _cancelTokens.remove(url);
    }

    return task;
  }

  /// 暂停下载
  void pauseDownload(String url) {
    if (_cancelTokens.containsKey(url)) {
      _cancelTokens[url]!.cancel('用户暂停');
      final task = _downloadTasks[url];
      if (task != null) {
        task.status = DownloadStatus.paused;
        task.onStatusChange?.call(DownloadStatus.paused, task);
        task.notifyListeners();
      }
    }
  }

  /// 取消下载
  void cancelDownload(String url) {
    if (_cancelTokens.containsKey(url)) {
      _cancelTokens[url]!.cancel('用户取消');
      _cancelTokens.remove(url);
    }
    
    final task = _downloadTasks[url];
    if (task != null) {
      task.status = DownloadStatus.cancelled;
      task.onStatusChange?.call(DownloadStatus.cancelled, task);
      task.notifyListeners();
      
      // 删除已下载的文件
      final file = File(task.savePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
    
    _downloadTasks.remove(url);
  }

  /// 重试下载
  Future<DownloadTask> retryDownload(String url) async {
    final task = _downloadTasks[url];
    if (task != null) {
      // 删除旧任务
      cancelDownload(url);
      
      // 创建新的下载任务
      return await startDownload(
        url: url,
        appName: task.appName,
        appIcon: task.appIcon,
        packageName: task.packageName,
      );
    }
    throw Exception('任务不存在');
  }

  /// 获取下载任务
  DownloadTask? getTask(String url) {
    return _downloadTasks[url];
  }

  /// 清除已完成的任务
  void clearCompletedTasks() {
    _downloadTasks.removeWhere((key, value) {
      if (value.status == DownloadStatus.completed) {
        // 删除文件
        final file = File(value.savePath);
        if (file.existsSync()) {
          file.deleteSync();
        }
        return true;
      }
      return false;
    });
  }

  /// 获取下载目录
  Future<Directory> _getDownloadDirectory() async {
    Directory directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      // 创建专门的下载目录
      final downloadDir = Directory('${directory.path}/downloads');
      if (!downloadDir.existsSync()) {
        downloadDir.createSync(recursive: true);
      }
      return downloadDir;
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
      return directory;
    } else {
      throw UnsupportedError('不支持的平台');
    }
  }

  /// 格式化文件大小
  static String formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }
}

