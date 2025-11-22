# App Installer Plugin

一个Flutter插件，用于下载和安装APK文件，支持进度回调和状态监听。

## 功能特性

- ✅ 通过URL下载APK文件
- ✅ 实时进度回调（字节数、百分比）
- ✅ 状态变化回调
- ✅ 错误回调
- ✅ 下载完成后安装APK
- ✅ 多任务管理
- ✅ 暂停、取消、重试
- ✅ 权限管理

## 安装

在你的 `pubspec.yaml` 中添加：

```yaml
dependencies:
  app_installer_plugin:
    path: modules/app_installer_plugin
```

## 使用方法

### 1. 导入插件

```dart
import 'package:app_installer_plugin/app_installer_plugin.dart';
```

### 2. 下载APK

```dart
final manager = AppDownloadManager();

// 请求权限
await PermissionUtil.requestStoragePermission();

// 开始下载
await manager.startDownload(
  url: 'https://example.com/app.apk',
  appName: '微信',
  
  // 进度回调
  onProgress: (received, total, progress) {
    print('进度: ${(progress * 100).toInt()}%');
  },
  
  // 状态回调
  onStatusChange: (status, task) {
    if (status == DownloadStatus.completed) {
      print('下载完成！');
    }
  },
  
  // 错误回调
  onError: (error, task) {
    print('错误: $error');
  },
);
```

### 3. 安装APK

```dart
// 请求安装权限
await PermissionUtil.requestInstallPermission();

// 安装
await AppInstaller().installApk(
  task,
  onStatusChange: (success, message) {
    print(success ? '安装成功' : '安装失败');
  },
);
```

## API文档

### AppDownloadManager - 下载管理器

```dart
// 开始下载
Future<DownloadTask> startDownload({
  required String url,
  required String appName,
  String? appIcon,
  String? packageName,
  DownloadProgressCallback? onProgress,
  DownloadStatusCallback? onStatusChange,
  DownloadErrorCallback? onError,
});

// 暂停下载
void pauseDownload(String url);

// 取消下载
void cancelDownload(String url);

// 重试下载
Future<DownloadTask> retryDownload(String url);

// 获取任务
DownloadTask? getTask(String url);

// 所有任务
Map<String, DownloadTask> get tasks;

// 清理完成任务
void clearCompletedTasks();

// 格式化文件大小
static String formatBytes(int bytes);
```

### AppInstaller - 应用安装器

```dart
// 安装APK
Future<bool> installApk(DownloadTask task, {
  InstallStatusCallback? onStatusChange,
});

// 直接安装APK文件
Future<bool> installApkFromPath(String filePath);

// 检查应用是否已安装
Future<bool> isAppInstalled(String packageName);

// 打开应用
Future<bool> openApp(String packageName);
```

### PermissionUtil - 权限工具

```dart
// 请求存储权限
static Future<bool> requestStoragePermission();

// 请求安装权限
static Future<bool> requestInstallPermission();

// 检查存储权限
static Future<bool> checkStoragePermission();

// 检查安装权限
static Future<bool> checkInstallPermission();

// 打开应用设置
static Future<void> openAppSettings();
```

## Android配置

### 1. 在 `android/app/build.gradle` 中设置最低SDK版本：

```gradle
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

### 2. 在 `AndroidManifest.xml` 中添加FileProvider：

```xml
<application>
    <!-- 其他配置 -->
    
    <provider
        android:name="androidx.core.content.FileProvider"
        android:authorities="${applicationId}.fileprovider"
        android:exported="false"
        android:grantUriPermissions="true">
        <meta-data
            android:name="android.support.FILE_PROVIDER_PATHS"
            android:resource="@xml/file_paths" />
    </provider>
</application>
```

### 3. 创建 `android/app/src/main/res/xml/file_paths.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <external-path name="external_files" path="." />
    <files-path name="internal_files" path="." />
    <cache-path name="cache_files" path="." />
    <external-cache-path name="external_cache_files" path="." />
</paths>
```

## 注意事项

1. **权限**: 使用前必须请求存储权限和安装权限
2. **Android版本**: Android 8.0及以上需要"允许安装未知来源应用"权限
3. **真实URL**: 需要使用真实的APK下载地址
4. **仅Android**: iOS不支持APK安装功能

## 示例

查看 `example` 目录获取完整示例。

## 许可证

MIT License

