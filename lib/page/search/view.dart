import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yyb/routes/app_pages.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';

import 'logic.dart';
import 'state.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final SearchLogic logic = Get.put(SearchLogic());
  final SearchState state = Get.find<SearchLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image(image: 'search_top_bar'.png),
            Positioned(
              left: 0,
              top: 30.w,
              child: SizedBox(width: 50.w, height: 50.w,).withOnTap(
                onTap: () {
                  Get.back();
                },
              ),
            ),
            Positioned(
              right: 0,
              top: 30.w,
              child: SizedBox(width: 50.w, height: 50.w).withOnTap(
                onTap: () {
                  logic.pageIndex.value = 1;
                },
              ),
            ),
          ],
        ),
        Obx(() {
          return buildPage();
        }),
      ],
    );
  }

  buildPage() {
    if (logic.pageIndex.value == 0) {
      return buildPage0();
    } else if (logic.pageIndex.value == 1) {
      return buildPage1();
    }
  }

  buildPage0() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image(image: "search_1".png, gaplessPlayback: true,),
                Positioned(
                  top: 85.w,
                  left: 0,
                  child:
                      Container(
                        width: 120.w,
                        height: 30.w,
                      ).withOnTap(
                        onTap: () {
                          Get.toNamed(Routes.provePage);
                        },
                      ),
                ),
              ],
            ),
            Image(image: "search_2".png, gaplessPlayback: true,),
          ],
        ),
      ),
    );
  }

  buildPage1() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image(image: "search_main_1_top_1".png, gaplessPlayback: true,),
                Positioned(
                  top: 85.w,
                  left: 0,
                  child:
                  SizedBox(
                    width: 100.w,
                    height: 80.w,
                  ).withOnTap(
                    onTap: () {
                      Get.toNamed(Routes.provePage);
                    },
                  ),
                ),
                Positioned(
                  top: 85.w,
                  left: 180.w,
                  child:
                  SizedBox(
                    width: 100.w,
                    height: 80.w,
                  ).withOnTap(
                    onTap: () {
                      Get.toNamed(Routes.billPage,);
                    },
                  ),
                ),
              ],
            ),
            Image(image: "search_main_1_top_2".png, gaplessPlayback: true,),
          ],
        ),
      ),
    );
  }
}
