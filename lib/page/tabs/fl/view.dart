import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class FlPage extends BaseStateless {
  FlPage({Key? key}) : super(key: key);

  final FlLogic logic = Get.put(FlLogic());
  final FlState state = Get.find<FlLogic>().state;

  @override
  bool get isShowAppBar => true;

  @override
  AppBarController? get appBarController => state.appBarController;

  @override
  Color? get background => Color(0xFFF5F6FA);

  @override
  // TODO: implement scrollDistance
  double? get scrollDistance => 150.w;


  @override
  Function(bool change, double percentage)? get onNotificationNavChange => (v, p) {
    logic.navColor.value = Color(0xFFF5F6FA).withOpacity(p);
    logic.searchBarColor.value = Color(0xFFE4E4E6).withOpacity(p);
    logic.iconColor.value = Colors.black.withOpacity(p);
    // 设置状态栏颜色
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFF5F6FA).withOpacity(p),
      statusBarIconBrightness: Brightness.dark, // 状态栏图标颜色（深色）
    ));
  };




  @override
  // TODO: implement titleWidget
  Widget? get titleWidget => Obx(() {
    return Container(
      width: 1.sw,
      height: 200.w,
      color: logic.navColor.value,
      child: Row(
        children: [
          SizedBox(width: 15.w),
          Container(
            height: 30.w,
            padding: EdgeInsets.only(left: 10.w),
            width: 1.sw - 65.w,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: logic.searchBarColor.value,
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Image(image: "scan".png, width: 15.w,  color: logic.iconColor.value,),
          ),
          SizedBox(width: 15.w,),
          Image(image: "download".png, width: 18.w, color: logic.iconColor.value,),
        ],
      ),
    );
  });

  @override
  // TODO: implement lefItemWidth
  double? get lefItemWidth => 0;

  @override
  // TODO: implement leftItem
  Widget? get leftItem => SizedBox();

  @override
  // TODO: implement isChangeNav
  bool get isChangeNav => true;

  @override
  Widget initBody(BuildContext context) {
    return Stack(
      children: [
        ListView(
          controller: logic.controller,
          padding: EdgeInsets.zero,
          children: [
            Image(image: "fl_1".png3x, fit: BoxFit.fitWidth, width: 1.sw),
            Image(image: "fl_2".png3x, fit: BoxFit.fitWidth, width: 1.sw),
            Image(image: "fl_3".png3x, fit: BoxFit.fitWidth, width: 1.sw),
            Image(image: "fl_4".png3x, fit: BoxFit.fitWidth, width: 1.sw),
            Image(image: "fl_5".png3x, fit: BoxFit.fitWidth, width: 1.sw),
            Image(image: "fl_6".png3x, fit: BoxFit.fitWidth, width: 1.sw),
            Image(image: "fl_7".png3x, fit: BoxFit.fitWidth, width: 1.sw),
          ],
        ),
        StickyWidget.withController(
          controller: logic.stickyController,
          child: Image(image: "fl_2".png3x, fit: BoxFit.fitWidth, width: 1.sw),
          initialOffset: 1.sw/1080 * 972 - ScreenUtil().statusBarHeight - kToolbarHeight,
          stickyOffset: ScreenUtil().statusBarHeight + kToolbarHeight,
        ),
      ],
    );
  }

}
