import 'package:flutter/foundation.dart';

/// 下载状态
enum DownloadStatus {
  downloading, // 下载中
  paused, // 已暂停
  completed, // 已完成
  failed, // 失败
  cancelled, // 已取消
  installing, // 安装中
  installed, // 已安装
}

/// 下载进度回调
typedef DownloadProgressCallback = void Function(
  int receivedBytes,
  int totalBytes,
  double progress,
);

/// 下载状态回调
typedef DownloadStatusCallback = void Function(
  DownloadStatus status,
  DownloadTask task,
);

/// 下载错误回调
typedef DownloadErrorCallback = void Function(
  String error,
  DownloadTask task,
);

/// 下载任务
class DownloadTask extends ChangeNotifier {
  final String url;
  final String appName;
  final String? appIcon;
  final String? packageName;
  final String savePath;

  DownloadStatus status;
  double progress;
  int downloadedBytes;
  int totalBytes;
  String? error;
  DateTime createTime;

  // 回调函数
  final DownloadProgressCallback? onProgress;
  final DownloadStatusCallback? onStatusChange;
  final DownloadErrorCallback? onError;

  DownloadTask({
    required this.url,
    required this.appName,
    this.appIcon,
    this.packageName,
    required this.savePath,
    this.status = DownloadStatus.downloading,
    this.progress = 0.0,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
    this.error,
    DateTime? createTime,
    this.onProgress,
    this.onStatusChange,
    this.onError,
  }) : createTime = createTime ?? DateTime.now();

  /// 获取状态文本
  String get statusText {
    switch (status) {
      case DownloadStatus.downloading:
        return '下载中';
      case DownloadStatus.paused:
        return '已暂停';
      case DownloadStatus.completed:
        return '下载完成';
      case DownloadStatus.failed:
        return '下载失败';
      case DownloadStatus.cancelled:
        return '已取消';
      case DownloadStatus.installing:
        return '安装中';
      case DownloadStatus.installed:
        return '已安装';
    }
  }

  /// 获取进度百分比文本
  String get progressText {
    return '${(progress * 100).toStringAsFixed(1)}%';
  }

  /// 是否可以重试
  bool get canRetry {
    return status == DownloadStatus.failed || status == DownloadStatus.cancelled;
  }

  /// 是否可以安装
  bool get canInstall {
    return status == DownloadStatus.completed;
  }

  /// 是否正在下载
  bool get isDownloading {
    return status == DownloadStatus.downloading;
  }
}

