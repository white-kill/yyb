import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';
import 'package:wb_base_widget/state_widget/state_less_widget.dart';

import '../../../utils/nav_icon_util.dart';
import 'common_nav_logic.dart';
import 'common_nav_state.dart';

class CommonNavPage extends BaseStateless {
  CommonNavPage({Key? key})
    : super(key: key, title: Get.arguments?['title'] ?? '无title参数');

  final CommonNavLogic logic = Get.put(CommonNavLogic());
  final CommonNavState state = Get.find<CommonNavLogic>().state;

  @override
  Color? get navColor => Get.arguments?['navColor'] ?? Colors.white;

  @override
  Color? get titleColor => Get.arguments?['titleColor'] ?? Colors.black;

  @override
  Color? get background => Get.arguments?['background'];

  // @override
  // Color? get titleWidget => BaseText(text: '12312312');

  @override
  Color? get backColor =>
      Get.arguments?['backColor'] ??
      Get.arguments?['titleColor'] ??
      Colors.black;

  @override
  List<Widget>? get rightAction =>
      state.navRightWidgetList ??
      (logic.state.navRigntList != null
          ? NavIconUtil.getNavIconsFromStringList(logic.state.navRigntList!)
          : []);


  @override
  // TODO: implement bottomNav
  Widget? get bottomNav => logic.state.bottomNav ?? SizedBox();

  @override
  Widget initBody(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: (Get.arguments?['top'] ?? 0).toDouble()),
      children: [
        if (logic.state.assetsImagePath != '')
          Image(
            image: logic.state.assetsImagePath.png3x,
            fit: BoxFit.fitWidth,
            width: 1.sw,
          )
        else if (logic.state.assetsImagePathList != null)
          buildImageList(),
      ],
    );
  }

  buildImageList() {
    List<Widget> images = [];
    for (String assets in logic.state.assetsImagePathList!) {
      images.add(Image(image: assets.png3x, fit: BoxFit.fitWidth, width: 1.sw));
    }
    return Column(children: images);
  }
}
