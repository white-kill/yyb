import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';
import 'package:wb_base_widget/state_widget/state_less_widget.dart';

import 'fixed_nav_logic.dart';
import 'fixed_nav_state.dart';

class FixedNavPage extends BaseStateless {
  FixedNavPage({Key? key})
      : super(key: key, title: Get.arguments?['title'] ?? '无title参数');

  final FixedNavLogic logic = Get.put(FixedNavLogic());
  final FixedNavState state = Get.find<FixedNavLogic>().state;

  @override
  Color? get navColor => Get.arguments?['navColor'] ?? Colors.white;

  @override
  Color? get titleColor => Get.arguments?['titleColor'] ?? Colors.black;

  @override
  Color? get background => Get.arguments?['background'];

  @override
  Color? get backColor =>
      Get.arguments?['backColor'] ??
      Get.arguments?['titleColor'] ??
      Colors.black;

  @override
  List<Widget>? get rightAction => [
        Get.arguments?['right'] == true
            ? Image(
                image: 'ic_sz_more'.png3x,
                width: 24.w,
                height: 24.w,
              ).withPadding(
                right: 20.w,
              )
            : SizedBox.shrink()
      ];

  @override
  Widget? get leftItem => InkWell(
    child: Obx(() => Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 30.h,
      ),
    )),
    onTap: () => Get.back(),
  );

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
          buildImageList()
      ],
    );
  }

  buildImageList() {
    List<Widget> images = [];
    for (String assets in logic.state.assetsImagePathList!) {
      images.add(Image(
        image: assets.png3x,
        fit: BoxFit.fitWidth,
        width: 1.sw,
      ));
    }
    return Column(
      children: images,
    );
  }
}
