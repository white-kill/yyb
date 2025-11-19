import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yyb/page/tabs/home/state.dart';
import 'package:yyb/utils/nav_icon_util.dart';
import 'package:wb_base_widget/component/placeholder_search_widget.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';
import 'package:wb_base_widget/state_widget/app_bar_widget.dart';
import 'package:yyb/utils/stack_position.dart';
import '../../../routes/app_pages.dart';
import 'package:wb_base_widget/state_widget/state_less_widget.dart';
import 'logic.dart';

class HomePage extends BaseStateless {
  HomePage({Key? key}) : super(key: key);
  final HomeLogic logic = Get.put(HomeLogic());
  final HomeState state = Get.find<HomeLogic>().state;

  @override
  bool get isChangeNav => true;

  @override
  Widget? get titleWidget => PlaceholderSearchWidget(
    width: 211.w,
    rightIcon: SizedBox.shrink(),
    contentList: ['账单', '优惠活动', '明细查询'],
    bgColor: Colors.white,
    textColor: Colors.black,
    border: BoxBorder.all(color: Colors.grey),
  ).paddingOnly(right: 15.w);

  @override
  Widget? get leftItem => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(width: 10.w),
      Obx(() {
        return Column(
          children: [
            SizedBox(height: 15.w),
            Image(
              width: 22.w,
              height: 22.w,
              image: ('home_nav_scan').png3x,
              color: logic.navActionColor.value,
            ),
          ],
        ).withOnTap(onTap: () {});
      }),
    ],
  );

  @override
  List<Widget>? get rightAction => [
    _customWidget('home_nav_dog').withOnTap(onTap: () {}),
    _customWidget('home_nav_add').withOnTap(onTap: () {}),
  ];

  Widget _customWidget(String imgName) {
    return Obx(() {
      return Column(
        children: [
          SizedBox(height: 15.w),
          Image(
            width: 22.w,
            height: 22.w,
            image: imgName.png3x,
            color: logic.navActionColor.value,
          ),
        ],
      ).paddingOnly(right: 15.w);
    });
  }

  @override
  Function(bool change)? get onNotificationNavChange => (v) {
    logic.navActionColor.value = v ? Colors.black : Colors.white;
    // logic.navTextColor.value = v ? Colors.white : Colors.black;
  };

  @override
  AppBarController? get appBarController => state.appBarController;

  @override
  Color? get background => Colors.white;

  @override
  Widget initBody(BuildContext context) {
    return Container();
  }
}
