import 'package:get/get.dart';
import 'package:app_checker_plugin/app_checker_plugin.dart';
import 'package:app_installer_plugin/app_installer_plugin.dart';
import '../../../../models/app_model.dart';

import 'state.dart';

class ZsLogic extends GetxController {
  final ZsState state = ZsState();

  final _checker = AppChecker();
  final _installer = AppDownloadManager();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is AppModel) {
      state.appModel.value = Get.arguments as AppModel;
    }
    checkAppInstalled();
  }

  Future<void> checkAppInstalled() async {
    final app = state.appModel.value;
    if (app?.bundleId == null) return;

    state.isChecking.value = true;
    try {
      final isInstalled = await _checker.isAppInstalled(app!.bundleId!);
      state.isInstalled.value = isInstalled;

      if (isInstalled) {
        final appInfo = await _checker.getAppInfo(app.bundleId!);
        if (appInfo != null) {
          state.appInfo.value = appInfo;
        }
      }
    } finally {
      state.isChecking.value = false;
    }
  }

  Future<void> openApp() async {
    final bundleId = state.appModel.value?.bundleId;
    if (bundleId == null) return;

    final success = await _checker.openApp(bundleId);
    if (!success) {
      Get.snackbar('提示', '打开失败');
    }
  }

  Future<void> downloadAndInstall() async {
    final app = state.appModel.value;
    if (app == null || app.downloadUrl == null || app.bundleId == null) {
      Get.snackbar('提示', '应用信息不完整');
      return;
    }

    if (!await PermissionUtil.requestStoragePermission()) {
      Get.snackbar('提示', '需要存储权限才能下载');
      return;
    }

    state.isDownloading.value = true;

    try {
      await _installer.startDownload(
        url: app.downloadUrl!,
        appName: app.fileName ?? '应用',
        packageName: app.bundleId!,
        onProgress: (received, total, progress) {
          state.downloadProgress.value = progress;
        },
        onStatusChange: (status, task) async {
          if (status == DownloadStatus.completed) {
            state.isDownloading.value = false;

            if (await PermissionUtil.requestInstallPermission()) {
              await AppInstaller().installApk(
                task,
                onStatusChange: (success, message) {
                  if (success) {
                    Get.snackbar('提示', '安装成功');
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
