import 'package:get/get.dart';
import 'package:app_checker_plugin/app_checker_plugin.dart';
import '../../../../models/app_model.dart';

class YzState {
  Rx<AppModel?> appModel = Rx<AppModel?>(null);
  RxBool isChecking = false.obs;
  RxBool isInstalled = false.obs;
  RxBool isDownloading = false.obs;
  RxDouble downloadProgress = 0.0.obs;
  Rx<AppInfo?> appInfo = Rx<AppInfo?>(null);

  YzState();
}
