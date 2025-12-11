import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';

import 'logic.dart';
import 'state.dart';

class GsPage extends StatelessWidget {
  GsPage({Key? key}) : super(key: key);

  final GsLogic logic = Get.put(GsLogic());
  final GsState state = Get.find<GsLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景全屏图片
        Positioned.fill(
          child: Image(image: "gs_search".png, fit: BoxFit.cover),
        ),
        
        // UI元素覆盖层
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 应用信息
              Obx(() {
                if (state.isChecking.value) {
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                }

                final app = state.appModel.value;
                if (app != null) {
                  return Column(
                    children: [
                      Text(
                        app.fileName ?? 'GS应用',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3.0,
                              color: Color.fromARGB(128, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '版本: ${app.fileVersion ?? "未知"}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3.0,
                              color: Color.fromARGB(128, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return Container();
              }),

              const SizedBox(height: 32),

              // 操作按钮
              Obx(() {
                if (state.isDownloading.value) {
                  // 下载中显示进度
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: state.downloadProgress.value,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                          minHeight: 8,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '下载中: ${(state.downloadProgress.value * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state.isInstalled.value) {
                  // 已安装显示打开按钮
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    child: ElevatedButton.icon(
                      onPressed: logic.openApp,
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('打开应用'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 8,
                      ),
                    ),
                  );
                } else {
                  // 未安装显示下载按钮
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    child: ElevatedButton.icon(
                      onPressed: logic.downloadAndInstall,
                      icon: const Icon(Icons.download),
                      label: const Text('下载安装'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 8,
                      ),
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ],
    );
  }
}
