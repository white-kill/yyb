import 'package:get/get.dart';

import 'common_nav_state.dart';

class CommonNavLogic extends GetxController {
  final CommonNavState state = CommonNavState();

  @override
  void onInit() {
    super.onInit();
    state.assetsImagePath = Get.arguments?['image']??'';
    state.assetsImagePathList = Get.arguments?["imageList"];
    state.navRigntList = Get.arguments?["right"] ?? [];
    state.bottomNav = Get.arguments?["bottomNav"];
    state.navRightWidgetList = Get.arguments?["rightWidget"];
  }
}
