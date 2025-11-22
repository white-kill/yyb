/// Flutter plugin for downloading and installing APK files.
/// 
/// 应用下载和安装插件（纯功能，无UI）
/// 
/// 功能特性：
/// - 通过URL下载APK文件
/// - 实时进度回调（字节数、百分比）
/// - 状态变化回调
/// - 错误回调
/// - 下载完成后安装APK
/// - 多任务管理
/// - 暂停、取消、重试
/// - 权限管理
library app_installer_plugin;

export 'src/app_download_manager.dart';
export 'src/download_task.dart';
export 'src/app_installer.dart';
export 'src/permission_util.dart';

