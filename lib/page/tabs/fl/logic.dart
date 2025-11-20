import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yyb/utils/sticky_widget.dart';

import 'state.dart';

class FlLogic extends GetxController {
  final FlState state = FlState();


  var navColor = Colors.transparent.obs;

  var searchBarColor = Colors.transparent.obs;

  var iconColor = Colors.transparent.obs;

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
