# App Installer Plugin - 插件总结

## 📦 插件信息

- **名称**: app_installer_plugin
- **版本**: 1.0.0
- **位置**: `/modules/app_installer_plugin`
- **类型**: Flutter Plugin (纯功能，无UI)

## ✅ 已完成内容

### 1. Dart 代码

| 文件 | 说明 |
|------|------|
| `lib/app_installer_plugin.dart` | 插件入口，导出所有API |
| `lib/src/download_task.dart` | 下载任务模型，状态管理 |
| `lib/src/app_download_manager.dart` | 下载管理器，核心功能 |
| `lib/src/app_installer.dart` | 应用安装器 |
| `lib/src/permission_util.dart` | 权限管理工具 |

### 2. Android 原生代码

| 文件 | 说明 |
|------|------|
| `android/src/main/kotlin/.../AppInstallerPlugin.kt` | Android插件实现 |
| `android/build.gradle` | Android构建配置 |
| `android/src/main/AndroidManifest.xml` | 权限声明 |
| `android/src/main/res/xml/file_paths.xml` | FileProvider配置 |

### 3. 配置文件

| 文件 | 说明 |
|------|------|
| `pubspec.yaml` | 插件依赖配置 |
| `README.md` | 使用文档 |
| `CHANGELOG.md` | 版本记录 |
| `LICENSE` | MIT许可证 |

### 4. 示例应用

| 文件 | 说明 |
|------|------|
| `example/lib/main.dart` | 完整示例代码 |
| `example/pubspec.yaml` | 示例配置 |

## 🎯 功能特性

- ✅ 下载APK文件
- ✅ 实时进度回调（字节、百分比）
- ✅ 状态变化回调
- ✅ 错误回调
- ✅ 安装APK
- ✅ 多任务管理
- ✅ 暂停/取消/重试
- ✅ 权限管理
- ✅ 检查应用是否已安装
- ✅ 打开已安装应用

## 📁 完整目录结构

```
modules/app_installer_plugin/
├── lib/
│   ├── app_installer_plugin.dart          # 插件入口
│   └── src/
│       ├── download_task.dart              # 任务模型
│       ├── app_download_manager.dart       # 下载管理器
│       ├── app_installer.dart              # 安装器
│       └── permission_util.dart            # 权限工具
├── android/
│   ├── build.gradle                        # Android构建配置
│   └── src/main/
│       ├── kotlin/com/example/app_installer_plugin/
│       │   └── AppInstallerPlugin.kt      # Android实现
│       ├── AndroidManifest.xml            # 权限声明
│       └── res/xml/
│           └── file_paths.xml             # FileProvider配置
├── example/
│   ├── lib/
│   │   └── main.dart                      # 示例代码
│   └── pubspec.yaml                       # 示例配置
├── pubspec.yaml                           # 插件配置
├── README.md                              # 使用文档
├── CHANGELOG.md                           # 版本记录
└── LICENSE                                # 许可证
```

## 🚀 如何使用插件

### 1. 在主项目中引入

在 `yyb/pubspec.yaml` 中添加：

```yaml
dependencies:
  app_installer_plugin:
    path: modules/app_installer_plugin
```

### 2. 导入插件

```dart
import 'package:app_installer_plugin/app_installer_plugin.dart';
```

### 3. 使用示例

```dart
// 创建下载管理器
final manager = AppDownloadManager();

// 请求权限
await PermissionUtil.requestStoragePermission();

// 下载APK
await manager.startDownload(
  url: 'https://example.com/app.apk',
  appName: '微信',
  onProgress: (received, total, progress) {
    print('进度: ${(progress * 100).toInt()}%');
  },
  onStatusChange: (status, task) {
    if (status == DownloadStatus.completed) {
      print('下载完成！');
    }
  },
  onError: (error, task) {
    print('错误: $error');
  },
);

// 安装APK
await PermissionUtil.requestInstallPermission();
await AppInstaller().installApk(task);
```

## 🔧 主项目配置

### 在主应用的 `AndroidManifest.xml` 中添加 FileProvider：

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

### 在主应用创建 `android/app/src/main/res/xml/file_paths.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <external-path name="external_files" path="." />
    <files-path name="internal_files" path="." />
    <cache-path name="cache_files" path="." />
    <external-cache-path name="external_cache_files" path="." />
</paths>
```

## 📖 API 概览

### AppDownloadManager

```dart
Future<DownloadTask> startDownload({...})  // 开始下载
void pauseDownload(String url)             // 暂停
void cancelDownload(String url)            // 取消
Future<DownloadTask> retryDownload(String url)  // 重试
DownloadTask? getTask(String url)          // 获取任务
Map<String, DownloadTask> get tasks        // 所有任务
void clearCompletedTasks()                 // 清理完成任务
static String formatBytes(int bytes)       // 格式化大小
```

### AppInstaller

```dart
Future<bool> installApk(DownloadTask task, {...})  // 安装APK
Future<bool> installApkFromPath(String path)       // 直接安装
Future<bool> isAppInstalled(String packageName)    // 检查已安装
Future<bool> openApp(String packageName)           // 打开应用
```

### PermissionUtil

```dart
static Future<bool> requestStoragePermission()     // 请求存储权限
static Future<bool> requestInstallPermission()     // 请求安装权限
static Future<bool> checkStoragePermission()       // 检查存储权限
static Future<bool> checkInstallPermission()       // 检查安装权限
static Future<void> openAppSettings()              // 打开设置
```

## ⚠️ 注意事项

1. **Channel名称**: 插件使用的MethodChannel名称是 `app_installer_plugin`
2. **权限配置**: 主应用需要配置FileProvider
3. **最低SDK**: Android minSdkVersion 21
4. **仅Android**: iOS不支持APK安装

## 🎉 优势

- ✅ **独立插件**: 可在多个项目中复用
- ✅ **纯功能**: 无UI依赖，灵活度高
- ✅ **回调驱动**: 实时反馈，易于集成
- ✅ **完整文档**: README和示例齐全
- ✅ **标准结构**: 符合Flutter插件规范

## 🔄 与原代码的区别

| 项目 | 原代码 | 插件版本 |
|------|--------|---------|
| 位置 | `lib/install_app/` | `modules/app_installer_plugin/` |
| 导入方式 | 项目内部导入 | 插件依赖 |
| MethodChannel | `app_installer` | `app_installer_plugin` |
| 复用性 | 仅限当前项目 | 可跨项目使用 |
| 版本管理 | 无 | 有版本号和CHANGELOG |

## 📝 下一步

插件已经完全封装好，可以：

1. ✅ 在主项目 `pubspec.yaml` 中引入插件
2. ✅ 配置主应用的 FileProvider
3. ✅ 运行示例应用测试功能
4. ✅ 在主应用中使用插件

**插件封装完成！可以开始使用了！** 🎊

