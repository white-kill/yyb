import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';
import 'package:wb_base_widget/state_widget/state_less_widget.dart';
import 'package:wb_base_widget/text_widget/bank_text.dart';

import '../../../../../utils/scale_point_widget.dart';

import 'change_navi_logic.dart';
import 'change_navi_state.dart';

class ChangeNavPage extends BaseStateless {
  final bool isOffset;
  ChangeNavPage({super.key}):
        isOffset = Get.arguments?['isOffset'] ?? false, super(
      title: Get.arguments?['title'] ?? '无title参数'
  );

  final ChangeNavLogic logic = Get.put(ChangeNavLogic());
  final ChangeNavState state = Get.find<ChangeNavLogic>().state;

  @override
  bool get isChangeNav => true;

  @override
  Color? get navColor => Get.arguments?['navColor'] ?? Colors.white;

  @override
  List<Widget>? get rightAction => [

    Obx(()=>ScalePointWidget(
      icColor: logic.navActionColor.value,
    ).withPadding(right: 6.w),),


    Obx(()=> Icon(
      Icons.clear,
      color: logic.navActionColor.value,
    ).withOnTap(onTap: () {
      Get.back();
    }).withPadding(
      right: 16.w,
    ))
  ];

  @override
  Widget? get leftItem => InkWell(
    child: Obx(() => Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 30.h,
        color: logic.navActionColor.value,
      ),
    )),
    onTap: () => Get.back(),
  );

  @override
  Widget? get titleWidget => Obx(
        () => BaseText(
        text: title ?? '',
        fontSize: 18.sp,
        color: logic.navActionColor.value),
  );

  @override
  Function(bool change)? get onNotificationNavChange => (v) {
    logic.navActionColor.value = v
        ? Get.arguments['changeTitleColor'] ?? Colors.black
        : Get.arguments['defTitleColor'] ?? Colors.white;
  };
  @override
  Widget initBody(BuildContext context) {
    return ListView(
      padding: isOffset? EdgeInsets.zero : EdgeInsets.only(top: ScreenUtil().statusBarHeight + kToolbarHeight),
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
