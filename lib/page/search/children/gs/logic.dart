import 'package:get/get.dart';
import 'package:app_checker_plugin/app_checker_plugin.dart';
import 'package:app_installer_plugin/app_installer_plugin.dart';

import 'state.dart';

class GsLogic extends GetxController {
  final GsState state = GsState();

  final _checker = AppChecker();
  final _installer = AppDownloadManager();

  // 应用包名
  static const String packageName = 'com.example.gs';
  // APK下载地址（请替换为实际地址）
  static const String apkUrl = 'https://your-server.com/gs.apk';

  @override
  void onInit() {
    super.onInit();
    checkAppInstalled();
  }

  /// 检查应用是否已安装
  Future<void> checkAppInstalled() async {
    state.isChecking.value = true;
    try {
      final isInstalled = await _checker.isAppInstalled(packageName);
      state.isInstalled.value = isInstalled;

      // 如果已安装，获取应用信息
      if (isInstalled) {
        final appInfo = await _checker.getAppInfo(packageName);
        if (appInfo != null) {
          state.appInfo.value = appInfo;
        }
      }
    } finally {
      state.isChecking.value = false;
    }
  }

  /// 打开应用
  Future<void> openApp() async {
    final success = await _checker.openApp(packageName);
    if (!success) {
      Get.snackbar('提示', '打开失败');
    }
  }

  /// 下载并安装应用
  Future<void> downloadAndInstall() async {
    // 请求权限
    if (!await PermissionUtil.requestStoragePermission()) {
      Get.snackbar('提示', '需要存储权限才能下载');
      return;
    }

    state.isDownloading.value = true;

    try {
      await _installer.startDownload(
        url: apkUrl,
        appName: 'GS应用',
        packageName: packageName,

        // 进度回调
        onProgress: (received, total, progress) {
          state.downloadProgress.value = progress;
        },

        // 状态回调
        onStatusChange: (status, task) async {
          if (status == DownloadStatus.completed) {
            // 下载完成，准备安装
            state.isDownloading.value = false;

            if (await PermissionUtil.requestInstallPermission()) {
              await AppInstaller().installApk(
                task,
                onStatusChange: (success, message) {
                  if (success) {
                    Get.snackbar('提示', '安装成功');
                    // 重新检查安装状态
                    checkAppInstalled();
                  } else {
                    Get.snackbar('提示', message ?? '安装失败');
                  }
                },
              );
            } else {
              Get.snackbar('提示', '需要安装权限');
            }
          }
        },

        // 错误回调
        onError: (error, task) {
          state.isDownloading.value = false;
          Get.snackbar('下载失败', error);
        },
      );
    } catch (e) {
      state.isDownloading.value = false;
      Get.snackbar('错误', e.toString());
    }
  }
}
