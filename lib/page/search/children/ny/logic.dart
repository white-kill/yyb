import 'package:get/get.dart';
import '../../../../models/app_model.dart';
import '../../../../services/app_install_service.dart';
import 'state.dart';

class NyLogic extends GetxController {
  final NyState state = NyState();

  AppInstallState get installState =>
      AppInstallService.to.stateFor(state.appModel.value?.bundleId ?? '');

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is AppModel) {
      state.appModel.value = Get.arguments as AppModel;
    }
    final bundleId = state.appModel.value?.bundleId;
    if (bundleId != null) {
      AppInstallService.to.checkInstalled(bundleId);
    }
  }

  Future<void> downloadAndInstall() =>
      AppInstallService.to.downloadAndInstall(state.appModel.value!);

  Future<void> openApp() =>
      AppInstallService.to.openApp(state.appModel.value!.bundleId!);
}
