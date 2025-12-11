import 'package:get/get.dart';
import 'package:app_checker_plugin/app_checker_plugin.dart';
import '../../../../models/app_model.dart';

class JsState {
  // 应用数据
  Rx<AppModel?> appModel = Rx<AppModel?>(null);
  
  // 是否正在检查
  RxBool isChecking = false.obs;
  
  // 应用是否已安装
  RxBool isInstalled = false.obs;
  
  // 是否正在下载
  RxBool isDownloading = false.obs;
  
  // 下载进度 0.0 - 1.0
  RxDouble downloadProgress = 0.0.obs;
  
  // 本地应用信息
  Rx<AppInfo?> appInfo = Rx<AppInfo?>(null);
  
  JsState() {
    ///Initialize variables
  }
}

