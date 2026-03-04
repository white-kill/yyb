import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';

import 'logic.dart';

class JsPage extends StatelessWidget {
  JsPage({Key? key}) : super(key: key);

  final JsLogic logic = Get.put(JsLogic());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景全屏图片
        Positioned.fill(
          child: Image(image: "js_search".png, fit: BoxFit.cover),
        ),
        Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: 100.w,
            ).withOnTap(onTap: () {
              Get.back();
            })),
        // UI元素覆盖层
        Positioned(
          top: 230.w,
          right: 23.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 操作按钮
              Obx(() {
                if (logic.installState.isDownloading.value) {
                  // 下载中：胶囊双色文字进度按钮
                  return Container(
                    width: 45.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      color: Color(0xFFe8f5ff),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Stack(
                        children: [
                          // 底层：蓝色文字
                          Center(
                            child: Text(
                              '${(logic.installState.downloadProgress.value * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Color(0xFF4A9EFF),
                              ),
                            ),
                          ),
                          // 上层：蓝色填充 + 白色文字，随进度从左展开
                          TweenAnimationBuilder<double>(
                            tween: Tween(
                                begin: 0, end: logic.installState.downloadProgress.value),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                            builder: (_, value, __) => ClipRect(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                widthFactor: value,
                                child: SizedBox(
                                  width: 45.w,
                                  height: 22.w,
                                  child: Container(
                                    color: const Color(0xFF4A9EFF),
                                    child: Center(
                                      child: Text(
                                        '${(logic.installState.downloadProgress.value * 100).toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (logic.installState.isInstalled.value) {
                  // 已安装：胶囊"打开"按钮
                  return GestureDetector(
                    onTap: logic.openApp,
                    child: Container(
                      width: 42.w,
                      height: 22.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFF4A9EFF),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        '打开',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                } else {
                  // 未安装：胶囊"更新/下载"按钮
                  return GestureDetector(
                    onTap: logic.downloadAndInstall,
                    child: Container(
                      alignment: Alignment.center,
                      width: 45.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        color: Color(0xFFe8f5ff),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        '下载',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PingFang SC',
                          color: Color(0xFF4A9EFF),
                        ),
                      ),
                    ),
                  );
                }
              }),
            ],
          ),
        ),

        ...List.generate(7, (i) => Positioned(
            top: 230.w + 77.w * (i + 1),
            right: 23.w,
            child: Container(
              alignment: Alignment.center,
              width: 45.w,
              height: 22.w,
              decoration: BoxDecoration(
                color: Color(0xFFe8f5ff),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Text(
                '下载',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PingFang SC',
                  color: Color(0xFF4A9EFF),
                ),
              ),
            ))),
      ],
    );
  }
}
