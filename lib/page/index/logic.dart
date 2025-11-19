import 'package:get/get.dart';
import 'package:yyb/config/yyb_config/yyb_logic.dart';

import '../../config/dio/network.dart';
import '../../utils/sp_util.dart';
import 'state.dart';

class IndexLogic extends GetxController {
  final IndexState state = IndexState();

  @override
  void onInit() {
    Http.setHeaders({'Authorization':token});
    Get.find<YybLogic>();

    super.onInit();
  }

  void onTabChanged(int index) {
    state.currentIndex.value = index;
  }
}
