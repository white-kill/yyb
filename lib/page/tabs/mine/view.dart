import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yyb/config/yyb_config/yyb_logic.dart';
import 'package:yyb/routes/app_pages.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';
import 'package:wb_base_widget/state_widget/state_less_widget.dart';


import 'logic.dart';
import 'state.dart';

class MinePage extends BaseStateless {
  MinePage({Key? key}) : super(key: key);

  final MineLogic logic = Get.put(MineLogic());
  final MineState state = Get.find<MineLogic>().state;

  @override
  bool get isChangeNav => true;

  @override
  Color? get navColor => Colors.white;

  // @override
  // List<Widget>? get rightAction => [
  //   InkWell(
  //     child: Image(image: "mine_right_1".png, width: 20.w, color: Colors.black),
  //   ),
  //   SizedBox(width: 20.w),
  //   InkWell(
  //     child: Image(image: "mine_right_2".png, width: 20.w, color: Colors.black),
  //   ),
  //   SizedBox(width: 20.w),
  //   InkWell(
  //     child: Image(image: "mine_right_3".png, width: 20.w, color: Colors.black),
  //     onTap: () => Get.toNamed(Routes.settingPage),
  //   ),
  //   SizedBox(width: 20.w),
  // ];

  // @override
  // Widget? get leftItem => Center(
  //   child: Image(image: "mine_back".png, width: 20.w, color: Colors.black)
  //       .withOnTap(
  //         onTap: () {
  //           Get.find<YybLogic>().logoutWithUI();
  //         },
  //       ),
  // );

  @override
  Widget initBody(BuildContext context) {
    return Container();
  }
}
