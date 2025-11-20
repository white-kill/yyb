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
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Image(image: "search".png, width: 1.sw),
          Positioned(
            top: 80.w,
            left: 0,
            child: SizedBox(
              width: 1.sw,
              height: 50.w,
              child: Row(
                children: [
                  Container(
                      width: 80.w,
                  ).withOnTap(onTap: () {
                    // 工商
                    Get.toNamed(Routes.gsPage);
                  }),
                  Container(
                      width: 80.w,
                ),

                  Expanded(
                    flex: 1,
                    child: Container().withOnTap(onTap: () {
                      // 平安
                      Get.toNamed(Routes.paPage);
                    }),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container().withOnTap(onTap: () {
                      // 建设
                      Get.toNamed(Routes.jsPage);
                    }),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container().withOnTap(onTap: () {
                      // 招商
                      // Get.toNamed(Routes.zsPage);
                    }),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container().withOnTap(onTap: () {
                      // 农业
                      Get.toNamed(Routes.nyPage);
                    }),
                  ),
                  SizedBox(width: 15.w,),

                ],
              ),
            ),
          ),
        ],
      ),
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
                Image(image: "search_1".png, gaplessPlayback: true),
                Positioned(
                  top: 85.w,
                  left: 0,
                  child: Container(width: 120.w, height: 30.w).withOnTap(
                    onTap: () {
                      // Get.toNamed(Routes.provePage);
                    },
                  ),
                ),
              ],
            ),
            Image(image: "search_2".png, gaplessPlayback: true),
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
                Image(image: "search_main_1_top_1".png, gaplessPlayback: true),
                Positioned(
                  top: 85.w,
                  left: 0,
                  child: SizedBox(width: 100.w, height: 80.w).withOnTap(
                    onTap: () {
                      // Get.toNamed(Routes.provePage);
                    },
                  ),
                ),
                Positioned(
                  top: 85.w,
                  left: 180.w,
                  child: SizedBox(width: 100.w, height: 80.w).withOnTap(
                    onTap: () {
                      // Get.toNamed(Routes.billPage,);
                    },
                  ),
                ),
              ],
            ),
            Image(image: "search_main_1_top_2".png, gaplessPlayback: true),
          ],
        ),
      ),
    );
  }
}
