import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

/// 权限请求工具
class PermissionUtil {
  /// 请求存储权限
  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    // Android 13及以上不需要存储权限
    if (Platform.version.contains('Android 13') ||
        Platform.version.contains('Android 14') ||
        Platform.version.contains('Android 15')) {
      return true;
    }

    // 检查权限状态
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    // 请求权限
    status = await Permission.storage.request();
    return status.isGranted;
  }

  /// 请求安装权限
  static Future<bool> requestInstallPermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    // Android 8.0及以上需要安装权限
    var status = await Permission.requestInstallPackages.status;
    if (status.isGranted) {
      return true;
    }

    // 请求权限
    status = await Permission.requestInstallPackages.request();
    return status.isGranted;
  }

  /// 打开应用设置页面
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// 检查存储权限
  static Future<bool> checkStoragePermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    // Android 13及以上不需要存储权限
    if (Platform.version.contains('Android 13') ||
        Platform.version.contains('Android 14') ||
        Platform.version.contains('Android 15')) {
      return true;
    }

    final status = await Permission.storage.status;
    return status.isGranted;
  }

  /// 检查安装权限
  static Future<bool> checkInstallPermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final status = await Permission.requestInstallPackages.status;
    return status.isGranted;
  }
}

