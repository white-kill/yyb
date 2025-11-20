import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yyb/utils/sticky_widget.dart';

import 'state.dart';

class YxkLogic extends GetxController {
  final YxkState state = YxkState();
  ScrollController controller = ScrollController();

  StickyController stickyController = StickyController();
  @override
  void onInit() {
    super.onInit();



    // 方式一：使用 StickyController
    controller.addListener(() {
      stickyController.updateScrollOffset(controller.offset);
    });
  }

}
