import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yyb/routes/app_pages.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';

import '../../config/bank_config.dart';
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
              left: 0.w,
              top: 23.w,
              child: Container(
                height: 50.w,
                width: 50.w,
              ).withOnTap(onTap: () {
                Get.back();
              })),
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
                    final app = logic.findAppByKeyword(BankConfig.gsKeyword);
                    if (app != null) {
                      Get.toNamed(Routes.gsPage, arguments: app);
                    } else {
                      Get.snackbar('提示', '暂无该应用');
                    }
                  }),
                  Container(
                      width: 80.w,
                  ),

                  Expanded(
                    flex: 1,
                    child: Container().withOnTap(onTap: () {
                      // 平安
                      final app = logic.findAppByKeyword(BankConfig.paKeyword);
                      if (app != null) {
                        Get.toNamed(Routes.paPage, arguments: app);
                      } else {
                        Get.snackbar('提示', '暂无该应用');
                      }
                    }),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container().withOnTap(onTap: () {
                      // 建设
                      final app = logic.findAppByKeyword(BankConfig.jsKeyword);
                      if (app != null) {
                        Get.toNamed(Routes.jsPage, arguments: app);
                      } else {
                        Get.snackbar('提示', '暂无该应用');
                      }
                    }),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container().withOnTap(onTap: () {
                      // 招商
                      final app = logic.findAppByKeyword(BankConfig.zsKeyword);
                      if (app != null) {
                        Get.toNamed(Routes.zsPage, arguments: app);
                      } else {
                        Get.snackbar('提示', '暂无该应用');
                      }
                    }),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container().withOnTap(onTap: () {
                      // 农业
                      final app = logic.findAppByKeyword(BankConfig.nyKeyword);
                      if (app != null) {
                        Get.toNamed(Routes.nyPage, arguments: app);
                      } else {
                        Get.snackbar('提示', '暂无该应用');
                      }
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
