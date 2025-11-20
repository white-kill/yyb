import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wb_base_widget/state_widget/app_bar_widget.dart';
import 'package:wb_base_widget/state_widget/state_less_widget.dart';
import 'package:yyb/utils/stack_position.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';
import 'package:wb_base_widget/text_widget/bank_text.dart';

import 'logic.dart';
import 'state.dart';


class FlPage extends BaseStateless {
  FlPage({Key? key}) : super(key: key);

  final FlLogic logic = Get.put(FlLogic());
  final FlState state = Get.find<FlLogic>().state;

  @override
  bool get isShowAppBar => false;

  @override
  AppBarController? get appBarController => state.appBarController;

  @override
  Color? get background => Colors.white;

  @override
  Widget initBody(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Stack(
          //   children: [
          //     Image(image: ('fl_1').png3x, fit: BoxFit.fitWidth, width: 1.sw),
          //     Positioned(
          //       left: stackPosition.getX(240),
          //       top: stackPosition.getY(110),
          //       child: SizedBox(),
          //     ),
          //   ],
          // ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [buildImageList()],
            ),
          ),
        ],
      ),
    );
  }

  buildImageList() {
    List<Widget> images = [];
    for (String assets in [
      "fl_1",
      "fl_2",
      "fl_3",
      "fl_4",
      "fl_5",
      "fl_6",
      "fl_7",
    ]) {
      images.add(Image(image: assets.png3x, fit: BoxFit.fitWidth, width: 1.sw));
    }
    return Column(children: images);
  }
}