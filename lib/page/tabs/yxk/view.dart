import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wb_base_widget/state_widget/app_bar_widget.dart';
import 'package:wb_base_widget/state_widget/state_less_widget.dart';
import 'package:yyb/utils/stack_position.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';
import 'package:wb_base_widget/text_widget/bank_text.dart';
import 'package:yyb/utils/sticky_widget.dart';

import 'logic.dart';
import 'state.dart';

class YxkPage extends BaseStateless {
  YxkPage({Key? key}) : super(key: key);

  final YxkLogic logic = Get.put(YxkLogic());
  final YxkState state = Get.find<YxkLogic>().state;

  @override
  bool get isShowAppBar => false;

  @override
  AppBarController? get appBarController => state.appBarController;

  @override
  Color? get background => Colors.white;





  @override
  Widget initBody(BuildContext context) {
    return Stack(
      children: [
        ListView(
          controller: logic.controller,
          padding: EdgeInsets.zero,
          children: [
            Image(image: "yxk_1".png3x, fit: BoxFit.fitWidth, width: 1.sw),
            Image(image: "yxk_2".png3x, fit: BoxFit.fitWidth, width: 1.sw),
            Image(image: "yxk_3".png3x, fit: BoxFit.fitWidth, width: 1.sw),
            Image(image: "yxk_4".png3x, fit: BoxFit.fitWidth, width: 1.sw),
            Image(image: "yxk_5".png3x, fit: BoxFit.fitWidth, width: 1.sw),
            Image(image: "yxk_6".png3x, fit: BoxFit.fitWidth, width: 1.sw),
            Image(image: "yxk_7".png3x, fit: BoxFit.fitWidth, width: 1.sw),
            Image(image: "yxk_8".png3x, fit: BoxFit.fitWidth, width: 1.sw),
          ],
        ),
        Image(image: "yxk_top".png, fit: BoxFit.fitWidth, width: 1.sw),
        StickyWidget.withController(
          controller: logic.stickyController,
          child: Image(image: "yxk_2".png3x, fit: BoxFit.fitWidth, width: 1.sw),
          initialOffset: 1.sw/1080 * 1312 - 1.sw/1080 * 253,
          stickyOffset: 1.sw/1080 * 253,
        ),
      ],
    );
  }
}
