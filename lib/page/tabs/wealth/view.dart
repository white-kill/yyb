import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wb_base_widget/state_widget/state_less_widget.dart';
import 'logic.dart';
import 'state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wb_base_widget/component/placeholder_search_widget.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';


class WealthPage extends BaseStateless {
  WealthPage({Key? key}) : super(key: key);

  final WealthLogic logic = Get.put(WealthLogic());
  final WealthState state = Get.find<WealthLogic>().state;

  @override
  bool get isChangeNav => false;

  @override
  // TODO: implement navColor
  Color? get navColor => Colors.black.withOpacity(0.03);

  @override
  Widget? get leftItem => Container(
    alignment: Alignment.center,
    height: 12.w,
    child: PlaceholderSearchWidget(
      width: 1.sw - 50.w,
      rightIcon: Text(
        "搜索",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
          fontFamily: "PingFang",
        ),
      ),
      contentList: ['金橙福利社', '日日惊喜 月月豪礼', '零活宝，即冲即用'],
      bgColor: Colors.white,
      textColor: Colors.black,
      border: BoxBorder.all(color: Colors.grey.withOpacity(0.2)),
    ).paddingOnly(right: 25.w, left: 15.w, top: 5.w, bottom: 5.w),
  );

  @override
  // TODO: implement lefItemWidth
  double? get lefItemWidth => 1.sw - 30.w;

  //
  @override
  List<Widget>? get rightAction => [
    SizedBox(width: 15.w),
    Image(image: "dog".png, width: 25.w),
    SizedBox(width: 15.w),
  ];

  @override
  Color? get background => Colors.white;

  @override
  Widget initBody(BuildContext context) {
    return Container();
  }
}
