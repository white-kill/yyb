import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yyb/page/tabs/home/state.dart';
import 'package:wb_base_widget/state_widget/app_bar_widget.dart';
import 'package:wb_base_widget/state_widget/state_less_widget.dart';
import 'package:yyb/utils/stack_position.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';
import 'package:wb_base_widget/text_widget/bank_text.dart';

import 'logic.dart';
import 'state.dart';

class MinePage extends BaseStateless {
  MinePage({Key? key}) : super(key: key);

  final MineLogic logic = Get.put(MineLogic());
  final MineState state = Get.find<MineLogic>().state;

  @override
  bool get isChangeNav => true;

  @override
  Color get navColor => Colors.white;

  @override
  Widget? get leftItem => Container();

  @override
  double get lefItemWidth => 0.w;

  @override
  List<Widget>? get rightAction => [
    Image(
      image: 'mine_message'.png3x,
      width: 24.w,
      height: 24.w,
    ).withPadding(right: 20.w),
    Image(
      image: 'mine_setting'.png3x,
      width: 24.w,
      height: 24.w,
    ).withPadding(right: 20.w),
  ];

  Color? get background => Color(0xFFEEEEEE);

  @override
  Widget initBody(BuildContext context) {
    StackPosition stackPosition = StackPosition(
      designWidth: 1080,
      designHeight: 318,
      deviceWidth: 1.sw,
    );
    return Scaffold(
      body:  ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 80.w,
              color: Color(0xFFF7F7F7),
              padding: EdgeInsets.only(top: 20.w),
              child: Row(
                children: [
                  Image(
                    image: 'mine_user'.png3x,
                    width: 35.w,
                    height: 35.w,
                  ).withPadding(left: 20.w, right: 8.w),
                  BaseText(text: '立即登录', color: Colors.black),
                ],
              ).withOnTap(onTap: (){
                print('22222');
              }),
            ),
            Stack(
              children: [
                Image(
                  image: ('mine_1').png3x,
                  fit: BoxFit.fitWidth,
                  width: 1.sw,
                ),
              ],
            ),
            Stack(
              children: [
                Image(
                  image: ('mine_2').png3x,
                  fit: BoxFit.fitWidth,
                  width: 1.sw,
                ),
              ],
            ),
          ]
      ),
    );
  }
}
