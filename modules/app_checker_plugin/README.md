# App Checker Plugin

一个轻量级的Flutter插件，用于检查应用是否已安装并获取应用信息。

## 功能特性

- ✅ 检查应用是否已安装
- ✅ 批量检查多个应用
- ✅ 获取应用详细信息（版本号、版本名称等）
- ✅ 获取已安装应用列表
- ✅ 打开已安装的应用
- ✅ 打开应用详情页面
- ✅ 版本号比较
- ✅ 常用应用快捷检测

## 安装

在你的 `pubspec.yaml` 中添加：

```yaml
dependencies:
  app_checker_plugin:
    path: modules/app_checker_plugin
```

## 使用方法

### 1. 导入插件

```dart
import 'package:app_checker_plugin/app_checker_plugin.dart';
```

### 2. 检查应用是否已安装

```dart
final checker = AppChecker();

// 检查单个应用
bool isInstalled = await checker.isAppInstalled('com.tencent.mm');
print('微信已安装: $isInstalled');

// 使用快捷方法
bool hasWeChat = await checker.isWeChatInstalled();
bool hasQQ = await checker.isQQInstalled();
bool hasAlipay = await checker.isAlipayInstalled();
```

### 3. 批量检查应用

```dart
final packageNames = [
  'com.tencent.mm',
  'com.tencent.mobileqq',
  'com.eg.android.AlipayGphone',
];

Map<String, bool> results = await checker.checkMultipleApps(packageNames);
results.forEach((packageName, isInstalled) {
  print('$packageName: $isInstalled');
});
```

### 4. 获取应用信息

```dart
AppInfo? appInfo = await checker.getAppInfo('com.tencent.mm');
if (appInfo != null) {
  print('应用名称: ${appInfo.appName}');
  print('包名: ${appInfo.packageName}');
  print('版本名称: ${appInfo.versionName}');
  print('版本号: ${appInfo.versionCode}');
  print('首次安装: ${appInfo.firstInstallTime}');
  print('最后更新: ${appInfo.lastUpdateTime}');
}
```

### 5. 获取已安装应用列表

```dart
// 获取用户应用（不包含系统应用）
List<AppInfo> apps = await checker.getInstalledApps();
for (var app in apps) {
  print('${app.appName} - ${app.packageName}');
}

// 包含系统应用
List<AppInfo> allApps = await checker.getInstalledApps(includeSystemApps: true);
```

### 6. 打开应用

```dart
// 打开应用
bool success = await checker.openApp('com.tencent.mm');
if (success) {
  print('成功打开微信');
}

// 打开应用详情页面
await checker.openAppDetails('com.tencent.mm');
```

### 7. 版本检测

```dart
// 检查版本名称是否匹配
bool isMatch = await checker.isVersionMatch('com.tencent.mm', '8.0.0');

// 检查版本号是否大于等于指定版本
bool isAtLeast = await checker.isVersionCodeAtLeast('com.tencent.mm', 2000);
```

## API文档

### AppChecker

```dart
// 检查单个应用是否已安装
Future<bool> isAppInstalled(String packageName);

// 批量检查应用
Future<Map<String, bool>> checkMultipleApps(List<String> packageNames);

// 获取应用信息
Future<AppInfo?> getAppInfo(String packageName);

// 获取已安装应用列表
Future<List<AppInfo>> getInstalledApps({bool includeSystemApps = false});

// 打开应用
Future<bool> openApp(String packageName);

// 打开应用详情页面
Future<bool> openAppDetails(String packageName);

// 版本检测
Future<bool> isVersionMatch(String packageName, String versionName);
Future<bool> isVersionCodeAtLeast(String packageName, int versionCode);

// 快捷方法
Future<bool> isWeChatInstalled();
Future<bool> isQQInstalled();
Future<bool> isAlipayInstalled();
Future<bool> isDouyinInstalled();
Future<bool> isTaobaoInstalled();
```

### AppInfo

```dart
class AppInfo {
  final String packageName;      // 包名
  final String appName;           // 应用名称
  final String versionName;       // 版本名称
  final int versionCode;          // 版本号
  final String? iconPath;         // 图标路径
  final DateTime? firstInstallTime;   // 首次安装时间
  final DateTime? lastUpdateTime;     // 最后更新时间
}
```

## 常用应用包名

```dart
// 社交
'com.tencent.mm'                    // 微信
'com.tencent.mobileqq'              // QQ
'com.sina.weibo'                    // 微博

// 支付
'com.eg.android.AlipayGphone'       // 支付宝

// 电商
'com.taobao.taobao'                 // 淘宝
'com.jingdong.app.mall'             // 京东

// 短视频
'com.ss.android.ugc.aweme'          // 抖音
'com.kuaishou.nebula'               // 快手
```

## Android配置

### 在 `AndroidManifest.xml` 中添加查询权限（可选）：

如果需要查询所有应用，在Android 11+需要添加：

```xml
<queries>
    <intent>
        <action android:name="android.intent.action.MAIN" />
    </intent>
</queries>
```

或者指定具体的包名：

```xml
<queries>
    <package android:name="com.tencent.mm" />
    <package android:name="com.tencent.mobileqq" />
</queries>
```

## 注意事项

1. **仅支持Android**: iOS有严格的沙盒限制，无法检测其他应用
2. **Android 11+**: 需要在AndroidManifest.xml中声明查询权限
3. **系统应用**: 默认不包含系统应用，可通过参数控制

## 使用场景

- ✅ 检测用户是否安装了必需的应用
- ✅ 应用市场统计已安装应用
- ✅ 版本更新检测
- ✅ 应用推荐（检测未安装的应用）
- ✅ 第三方登录前检测（微信、QQ等）

## 示例

查看 `example` 目录获取完整示例。

## 许可证

MIT License

