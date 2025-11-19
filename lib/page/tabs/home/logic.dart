import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';

class HomeLogic extends GetxController {
  var navActionColor = Colors.white.obs;
  // var navTextColor = Colors.black.obs;
  final HomeState state = HomeState();

  @override
  void onInit() {

    state.refreshController1.headerMode?.addListener(() {
      update(['updateUI']);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.refreshController1.position?.jumpTo(0);
      update(['updateUI']);
    });
    super.onInit();
  }
}
