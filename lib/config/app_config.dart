import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yyb/utils/sp_util.dart';
import 'package:sp_util/sp_util.dart';
import 'dart:io' show Platform;
import '../utils/local_notifications.dart';
import '../services/app_install_service.dart';
import 'yyb_config/yyb_logic.dart';
import 'net_config/net_config.dart';

class AppProxy {
  Config? config;

  static AppProxy? _instance;

  static AppProxy get instance => _instance ??= AppProxy._internal();

  AppProxy._internal() {
    config = Config();
  }
}

/// 全局配置统一在此处处理
class Config {
  ///网络配置
  NetConfig netConfig = NetConfig();

  bool isA12 = false;

  late YybLogic yybLogic;

  ///其他配置
  Future initApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    await SpUtil.getInstance();
    if (Platform.isAndroid) {
      isA12 = await isAndroid12OrHigher();
      await _requestAndroidPermissions();
    }
    // netConfig.baseUrl = 'http://47.102.135.129:8001';
    // netConfig.baseUrl = 'http://api.jiansheccb.com';
    // netConfig.baseUrl = 'http://api.chinajianse.com';
    netConfig.baseUrl = 'https://www.cbmchian.com/dev-api/app';
    '仅收入'.saveSearchHistory;
    NotificationHelper.getInstance().initialize();
    NotificationHelper.getInstance().initPermission();
    await Get.putAsync(() async => AppInstallService());
    yybLogic = Get.put(YybLogic());
  }

  Future<void> _requestAndroidPermissions() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      // Android 13+ 使用分类媒体权限
      await [
        Permission.photos,
        Permission.videos,
        Permission.audio,
      ].request();
    } else {
      // Android 12 及以下使用传统存储权限
      await [
        Permission.storage,
      ].request();
    }

    // 安装 APK 权限（跳转系统设置页授权）
    if (!(await Permission.requestInstallPackages.isGranted)) {
      await Permission.requestInstallPackages.request();
    }
  }

  Future<bool> isAndroid12OrHigher() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt >= 31;
  }
}

///
/// 全局配置
///
class AppConfig {
  AppConfig._();

  static Config config = AppProxy.instance.config!;
}
