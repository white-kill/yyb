import 'dart:io';
import 'package:flutter/services.dart';
import 'download_task.dart';

/// 安装状态回调
typedef InstallStatusCallback = void Function(bool success, String? message);

/// 应用安装器
class AppInstaller {
  static final AppInstaller _instance = AppInstaller._internal();
  factory AppInstaller() => _instance;
  AppInstaller._internal();

  static const MethodChannel _channel = MethodChannel('app_installer_plugin');

  /// 安装APK（仅Android）
  /// 
  /// [task] 下载任务
  /// [onStatusChange] 安装状态回调（可选）
  Future<bool> installApk(
    DownloadTask task, {
    InstallStatusCallback? onStatusChange,
  }) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('仅支持Android平台安装APK');
    }

    if (task.status != DownloadStatus.completed) {
      throw Exception('任务未完成，无法安装');
    }

    final file = File(task.savePath);
    if (!file.existsSync()) {
      throw Exception('APK文件不存在');
    }

    try {
      // 调用原生方法跳转到系统安装界面
      // startActivity 立即返回，true 只代表跳转成功，不代表安装完成
      final result = await _channel.invokeMethod('installApk', {
        'filePath': task.savePath,
      });

      if (result == true) {
        // 保持 completed 状态，等 App 回到前台后由生命周期监听检测真实安装结果
        task.status = DownloadStatus.installing;
        task.onStatusChange?.call(DownloadStatus.installing, task);
        task.notifyListeners();
        return true;
      } else {
        task.status = DownloadStatus.completed;
        task.error = '启动安装界面失败';
        task.onError?.call('启动安装界面失败', task);
        task.notifyListeners();
        onStatusChange?.call(false, '启动安装界面失败');
        return false;
      }
    } catch (e) {
      final errorMsg = '安装出错: $e';
      task.status = DownloadStatus.completed;
      task.error = errorMsg;
      task.onError?.call(errorMsg, task);
      task.notifyListeners();
      onStatusChange?.call(false, errorMsg);
      return false;
    }
  }

  /// 直接安装APK文件
  /// 
  /// [filePath] APK文件路径
  Future<bool> installApkFromPath(String filePath) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('仅支持Android平台安装APK');
    }

    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception('APK文件不存在');
    }

    try {
      final result = await _channel.invokeMethod('installApk', {
        'filePath': filePath,
      });
      return result == true;
    } catch (e) {
      return false;
    }
  }

  /// 检查是否已安装某个应用
  Future<bool> isAppInstalled(String packageName) async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod('isAppInstalled', {
        'packageName': packageName,
      });
      return result == true;
    } catch (e) {
      return false;
    }
  }

  /// 打开已安装的应用
  Future<bool> openApp(String packageName) async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod('openApp', {
        'packageName': packageName,
      });
      return result == true;
    } catch (e) {
      return false;
    }
  }
}

