import 'dart:io';
import 'package:flutter/services.dart';
import 'app_info.dart';

/// 应用检测器
class AppChecker {
  static final AppChecker _instance = AppChecker._internal();
  factory AppChecker() => _instance;
  AppChecker._internal();

  static const MethodChannel _channel = MethodChannel('app_checker_plugin');

  /// 检查应用是否已安装
  ///
  /// [packageName] 应用包名，例如：'com.tencent.mm'
  /// 返回 true 表示已安装，false 表示未安装
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

  /// 批量检查应用是否已安装
  ///
  /// [packageNames] 应用包名列表
  /// 返回 Map<String, bool>，key为包名，value为是否已安装
  Future<Map<String, bool>> checkMultipleApps(List<String> packageNames) async {
    if (!Platform.isAndroid) {
      return {for (var name in packageNames) name: false};
    }

    try {
      final result = await _channel.invokeMethod('checkMultipleApps', {
        'packageNames': packageNames,
      });
      return Map<String, bool>.from(result as Map);
    } catch (e) {
      return {for (var name in packageNames) name: false};
    }
  }

  /// 获取应用信息
  ///
  /// [packageName] 应用包名
  /// 返回 AppInfo 对象，如果应用未安装返回 null
  Future<AppInfo?> getAppInfo(String packageName) async {
    if (!Platform.isAndroid) {
      return null;
    }

    try {
      final result = await _channel.invokeMethod('getAppInfo', {
        'packageName': packageName,
      });

      if (result != null) {
        return AppInfo.fromMap(Map<String, dynamic>.from(result as Map));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 获取已安装的应用列表
  ///
  /// [includeSystemApps] 是否包含系统应用，默认为 false
  /// 返回已安装应用的信息列表
  Future<List<AppInfo>> getInstalledApps({bool includeSystemApps = false}) async {
    if (!Platform.isAndroid) {
      return [];
    }

    try {
      final result = await _channel.invokeMethod('getInstalledApps', {
        'includeSystemApps': includeSystemApps,
      });

      if (result != null) {
        final List<dynamic> list = result as List<dynamic>;
        return list.map((item) => AppInfo.fromMap(Map<String, dynamic>.from(item as Map))).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// 打开已安装的应用
  ///
  /// [packageName] 应用包名
  /// 返回 true 表示成功打开，false 表示打开失败
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

  /// 打开应用详情页面
  ///
  /// [packageName] 应用包名
  /// 返回 true 表示成功打开，false 表示打开失败
  Future<bool> openAppDetails(String packageName) async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod('openAppDetails', {
        'packageName': packageName,
      });
      return result == true;
    } catch (e) {
      return false;
    }
  }

  /// 检查应用版本是否匹配
  ///
  /// [packageName] 应用包名
  /// [versionName] 期望的版本名称
  /// 返回 true 表示版本匹配，false 表示不匹配或应用未安装
  Future<bool> isVersionMatch(String packageName, String versionName) async {
    final appInfo = await getAppInfo(packageName);
    if (appInfo == null) {
      return false;
    }
    return appInfo.versionName == versionName;
  }

  /// 检查应用版本号是否大于等于指定版本
  ///
  /// [packageName] 应用包名
  /// [versionCode] 期望的版本号
  /// 返回 true 表示版本号大于等于指定版本，false 表示小于或应用未安装
  Future<bool> isVersionCodeAtLeast(String packageName, int versionCode) async {
    final appInfo = await getAppInfo(packageName);
    if (appInfo == null) {
      return false;
    }
    return appInfo.versionCode >= versionCode;
  }

  /// 常用应用检测快捷方法

  /// 检查微信是否已安装
  Future<bool> isWeChatInstalled() => isAppInstalled('com.tencent.mm');

  /// 检查QQ是否已安装
  Future<bool> isQQInstalled() => isAppInstalled('com.tencent.mobileqq');

  /// 检查支付宝是否已安装
  Future<bool> isAlipayInstalled() => isAppInstalled('com.eg.android.AlipayGphone');

  /// 检查抖音是否已安装
  Future<bool> isDouyinInstalled() => isAppInstalled('com.ss.android.ugc.aweme');

  /// 检查淘宝是否已安装
  Future<bool> isTaobaoInstalled() => isAppInstalled('com.taobao.taobao');
}
