import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yyb/page/tabs/home/state.dart';
import 'package:wb_base_widget/state_widget/app_bar_widget.dart';
import 'package:wb_base_widget/state_widget/state_less_widget.dart';
import 'package:yyb/routes/app_pages.dart';
import 'package:yyb/utils/stack_position.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';
import 'package:wb_base_widget/text_widget/bank_text.dart';

import 'logic.dart';

class HomePage extends BaseStateless {
  HomePage({Key? key}) : super(key: key);
  final HomeLogic logic = Get.put(HomeLogic());
  final HomeState state = Get.find<HomeLogic>().state;

  @override
  bool get isShowAppBar => false;

  @override
  AppBarController? get appBarController => state.appBarController;

  @override
  Color? get background => Colors.white;

  @override
  Widget initBody(BuildContext context) {
    StackPosition stackPosition = StackPosition(
      designWidth: 1080,
      designHeight: 318,
      deviceWidth: 1.sw,
    );
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.searchPage);
                },
                child: Image(
                  image: ('home_1').png3x,
                  fit: BoxFit.fitWidth,
                  width: 1.sw,
                ),
              ),
              Positioned(
                left: stackPosition.getX(240),
                top: stackPosition.getY(110),
                child: Container(
                  height: stackPosition.getHeight(80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BaseText(
                        text: '快对AI',
                        style: TextStyle(fontSize: 13.w, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
      "home_2",
      "home_3",
      "home_4",
      "home_5",
      "home_6",
      "home_7",
      "home_8",
    ]) {
      images.add(Image(image: assets.png3x, fit: BoxFit.fitWidth, width: 1.sw));
    }
    return Column(children: images);
  }
}
