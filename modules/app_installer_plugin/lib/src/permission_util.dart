import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// 权限请求工具
class PermissionUtil {
  static int? _androidSdkInt;

  static Future<int> _getSdkInt() async {
    if (_androidSdkInt != null) return _androidSdkInt!;
    final info = await DeviceInfoPlugin().androidInfo;
    _androidSdkInt = info.version.sdkInt;
    return _androidSdkInt!;
  }

  /// 请求存储权限
  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    final sdk = await _getSdkInt();

    // Android 13+（SDK 33+）使用分类媒体权限，下载到公共目录不需要额外申请
    if (sdk >= 33) return true;

    var status = await Permission.storage.status;
    if (status.isGranted) return true;

    status = await Permission.storage.request();
    return status.isGranted;
  }

  /// 请求安装权限
  static Future<bool> requestInstallPermission() async {
    if (!Platform.isAndroid) return true;

    var status = await Permission.requestInstallPackages.status;
    if (status.isGranted) return true;

    status = await Permission.requestInstallPackages.request();
    return status.isGranted;
  }

  /// 打开应用设置页面
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// 检查存储权限
  static Future<bool> checkStoragePermission() async {
    if (!Platform.isAndroid) return true;

    final sdk = await _getSdkInt();
    if (sdk >= 33) return true;

    final status = await Permission.storage.status;
    return status.isGranted;
  }

  /// 检查安装权限
  static Future<bool> checkInstallPermission() async {
    if (!Platform.isAndroid) return true;

    final status = await Permission.requestInstallPackages.status;
    return status.isGranted;
  }
}

