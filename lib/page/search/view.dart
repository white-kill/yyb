import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yyb/routes/app_pages.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';
import 'package:wb_base_widget/text_widget/bank_text.dart';

import '../../config/bank_config.dart';
import 'logic.dart';
import 'state.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final SearchLogic logic = Get.put(SearchLogic());
  final SearchState state = Get.find<SearchLogic>().state;

  /// 设计图尺寸 580x1280，图片用 fitWidth 铺满屏宽，按比例计算相对图片的位置
  static const _imgW = 1080.0;
  static const _imgH = 2376.0;

  static const _bankItems = [
    {'name': '工商银行', 'keyword': '工商', 'route': Routes.gsPage},
    {'name': '平安银行', 'keyword': '平安', 'route': Routes.paPage},
    {'name': '招商银行', 'keyword': '招商', 'route': Routes.zsPage},
    {'name': '建设银行', 'keyword': '建设', 'route': Routes.jsPage},
    {'name': '农业银行', 'keyword': '农业', 'route': Routes.nyPage},
    {'name': '邮政银行', 'keyword': '邮政', 'route': Routes.yzPage},
  ];

  /// 图片按 fitWidth 显示时的实际高度，与设计图等比例
  double get _imgDisplayHeight => 1.sw * _imgH / _imgW;

  /// 设计图 px 转实际尺寸（与图片同比例）
  double _px(double designPx) => designPx * 1.sw / _imgW;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: 1.sh,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: 1.sw,
        height: _imgDisplayHeight,
        child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Image(
                    image: "search".png,
                    width: 1.sw,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter),
              ),
              Positioned(
                left: _px(0),
                top: _px(23),
                child: SizedBox(
                  width: _px(50),
                  height: _px(50),
                ).withOnTap(onTap: () {
                  Get.back();
                }),
              ),
              Positioned(
                top: _px(120),
                left: _px(174),
                child: Container(
                  height: _px(80),
                  width: _px(_imgW - 174 - 70),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    cursorColor: Color(0xff333333),
                    controller: state.searchController,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'MiSans',
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        color: Color(0xFF333333)),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '在这里输入搜索内容',
                      hintStyle: TextStyle(
                        color: Color(0xFF8D8D8D),
                        fontFamily: 'PingFangSC',
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 11.w),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: _px(20),
                top: _px(120),
                child: Container(
                  width: _px(120),
                  height: _px(120),
                ).withOnTap(onTap: () {
                  String keyword = state.searchController.text.trim();
                  final app = logic.findAppByKeyword(keyword);
                  if (app != null) {
                    if (app.fileName?.contains('建设') ?? false) {
                      Get.toNamed(Routes.jsPage, arguments: app);
                    } else if (app.fileName?.contains('工商') ?? false) {
                      Get.toNamed(Routes.gsPage, arguments: app);
                    } else if (app.fileName?.contains('招商') ?? false) {
                      Get.toNamed(Routes.zsPage, arguments: app);
                    } else if (app.fileName?.contains('农业') ?? false) {
                      Get.toNamed(Routes.nyPage, arguments: app);
                    } else if (app.fileName?.contains('邮政') ?? false) {
                      Get.toNamed(Routes.yzPage, arguments: app);
                    } else if (app.fileName?.contains('平安') ?? false) {
                      Get.toNamed(Routes.paPage, arguments: app);
                    }
                  } else {
                    Get.snackbar('提示', '暂无该应用');
                  }
                }),
              ),
              Positioned(
                top: _px(230),
                left: _px(50),
                child: SizedBox(
                  width: _px(_imgW - 30),
                  height: _px(80),
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    separatorBuilder: (_, __) => SizedBox.shrink(),
                    itemCount: _bankItems.length,
                    itemBuilder: (context, index) {
                      final item = _bankItems[index];
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFFf3f4f5),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 3.w, horizontal: 12.w),
                        child: BaseText(
                          text: item['keyword']!,
                          fontSize: 11.sp,
                          style: TextStyle(
                              color: Color(0xFF888888),
                            fontSize: 11.sp,
                            height: 1.0
                          ),
                        ),
                      ).marginOnly(right: 10.w).withOnTap(onTap: () {
                        final app =
                            logic.findAppByKeyword(item['keyword']!);
                        if (app != null) {
                          Get.toNamed(item['route']!, arguments: app);
                        } else {
                          Get.snackbar('提示', '暂无该应用');
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
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
