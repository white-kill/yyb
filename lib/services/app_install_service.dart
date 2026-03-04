import 'package:app_checker_plugin/app_checker_plugin.dart';
import 'package:app_installer_plugin/app_installer_plugin.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../models/app_model.dart';

/// 单个 App 的安装/下载状态，以 bundleId 为 key 保存在服务中
class AppInstallState {
  final isChecking = false.obs;
  final isInstalled = false.obs;
  final isDownloading = false.obs;
  final downloadProgress = 0.0.obs;
  final Rx<AppInfo?> appInfo = Rx<AppInfo?>(null);
}

/// 全局下载安装单例服务
/// - 生命周期与 App 相同，退出页面下载不中断
/// - 每个 bundleId 维护独立的响应式状态
/// - 页面重新进入时直接读取当前状态，无需重新开始
/// - App 从后台回到前台时自动刷新所有已追踪应用的安装状态
class AppInstallService extends GetxService with WidgetsBindingObserver {
  static AppInstallService get to => Get.find<AppInstallService>();

  final _checker = AppChecker();
  final _manager = AppDownloadManager();
  final _installer = AppInstaller();

  final Map<String, AppInstallState> _states = {};

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  /// App 回到前台时刷新所有已追踪应用的安装状态
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshAllInstallStates();
    }
  }

  void _refreshAllInstallStates() {
    for (final bundleId in _states.keys) {
      if (bundleId.isNotEmpty) {
        checkInstalled(bundleId);
      }
    }
  }

  /// 获取某个 bundleId 的状态（不存在则自动创建）
  AppInstallState stateFor(String bundleId) {
    return _states.putIfAbsent(bundleId, () => AppInstallState());
  }

  /// 检查是否已安装
  Future<void> checkInstalled(String bundleId) async {
    final s = stateFor(bundleId);
    if (s.isChecking.value) return;

    s.isChecking.value = true;
    try {
      final installed = await _checker.isAppInstalled(bundleId);
      s.isInstalled.value = installed;
      if (installed) {
        final info = await _checker.getAppInfo(bundleId);
        s.appInfo.value = info;
      }
    } finally {
      s.isChecking.value = false;
    }
  }

  /// 下载并安装
  Future<void> downloadAndInstall(AppModel app) async {
    final bundleId = app.bundleId;
    final url = app.downloadUrl;

    if (bundleId == null || url == null) {
      Get.snackbar('提示', '应用信息不完整');
      return;
    }

    final s = stateFor(bundleId);

    // 已在下载中，不重复触发
    if (s.isDownloading.value) return;

    if (!await PermissionUtil.requestStoragePermission()) {
      Get.snackbar('提示', '需要存储权限才能下载');
      return;
    }

    // // 检查是否已有下载好的文件，有则直接安装跳过下载
    // final existingPath = await _manager.getExistingApkPath(bundleId);
    const existingPath = null;
    if (existingPath != null) {
      final fakeTask = DownloadTask(
        url: url,
        appName: app.fileName ?? '应用',
        packageName: bundleId,
        savePath: existingPath,
        status: DownloadStatus.completed,
        progress: 1.0,
      );
      await _triggerInstall(fakeTask, bundleId);
      return;
    }

    s.isDownloading.value = true;
    s.downloadProgress.value = 0.0;

    try {
      await _manager.startDownload(
        url: url,
        appName: app.fileName ?? '应用',
        packageName: bundleId,
        onProgress: (received, total, progress) {
          s.downloadProgress.value = progress;
        },
        onStatusChange: (status, task) async {
          if (status == DownloadStatus.completed) {
            s.isDownloading.value = false;
            await _triggerInstall(task, bundleId);
          } else if (status == DownloadStatus.failed ||
              status == DownloadStatus.cancelled) {
            s.isDownloading.value = false;
          }
        },
        onError: (error, task) {
          s.isDownloading.value = false;
          Get.snackbar('下载失败', error);
        },
      );
    } catch (e) {
      s.isDownloading.value = false;
      Get.snackbar('错误', e.toString());
    }
  }

  Future<void> _triggerInstall(DownloadTask task, String bundleId) async {
    if (!await PermissionUtil.requestInstallPermission()) {
      Get.snackbar('提示', '需要安装权限');
      return;
    }
    // 只负责跳转到系统安装界面
    // 安装结果由 App 回到前台时 _refreshAllInstallStates 自动检测
    final launched = await _installer.installApk(task);
    if (!launched) {
      Get.snackbar('提示', '启动安装界面失败');
    }
  }

  /// 打开已安装的 App
  Future<void> openApp(String bundleId) async {
    final success = await _checker.openApp(bundleId);
    if (!success) {
      Get.snackbar('提示', '打开失败');
    }
  }
}
