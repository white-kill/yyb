/// 应用信息
class AppInfo {
  /// 包名
  final String packageName;
  
  /// 应用名称
  final String appName;
  
  /// 版本名称 (e.g. "1.0.0")
  final String versionName;
  
  /// 版本号 (e.g. 1)
  final int versionCode;
  
  /// 图标路径
  final String? iconPath;
  
  /// 首次安装时间
  final DateTime? firstInstallTime;
  
  /// 最后更新时间
  final DateTime? lastUpdateTime;

  AppInfo({
    required this.packageName,
    required this.appName,
    required this.versionName,
    required this.versionCode,
    this.iconPath,
    this.firstInstallTime,
    this.lastUpdateTime,
  });

  factory AppInfo.fromMap(Map<String, dynamic> map) {
    return AppInfo(
      packageName: map['packageName'] as String,
      appName: map['appName'] as String,
      versionName: map['versionName'] as String,
      versionCode: map['versionCode'] as int,
      iconPath: map['iconPath'] as String?,
      firstInstallTime: map['firstInstallTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['firstInstallTime'] as int)
          : null,
      lastUpdateTime: map['lastUpdateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastUpdateTime'] as int)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'packageName': packageName,
      'appName': appName,
      'versionName': versionName,
      'versionCode': versionCode,
      'iconPath': iconPath,
      'firstInstallTime': firstInstallTime?.millisecondsSinceEpoch,
      'lastUpdateTime': lastUpdateTime?.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'AppInfo(packageName: $packageName, appName: $appName, version: $versionName($versionCode))';
  }
}

