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
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 应用图标
          Image(image: "gs_search".png),
          const SizedBox(height: 24),

          // 应用信息
          Obx(() {
            if (state.isChecking.value) {
              return const CircularProgressIndicator();
            }

            if (state.isInstalled.value && state.appInfo.value != null) {
              final appInfo = state.appInfo.value!;
              return Column(
                children: [
                  Text(
                    appInfo.appName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '版本: ${appInfo.versionName}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              );
            }

            return const Text(
              'GS应用',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            );
          }),

          const SizedBox(height: 32),

          // 操作按钮
          Obx(() {
            if (state.isDownloading.value) {
              // 下载中显示进度
              return Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: state.downloadProgress.value,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '下载中: ${(state.downloadProgress.value * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              );
            }

            if (state.isInstalled.value) {
              // 已安装显示打开按钮
              return ElevatedButton.icon(
                onPressed: logic.openApp,
                icon: const Icon(Icons.open_in_new),
                label: const Text('打开应用'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              );
            } else {
              // 未安装显示下载按钮
              return ElevatedButton.icon(
                onPressed: logic.downloadAndInstall,
                icon: const Icon(Icons.download),
                label: const Text('下载安装'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
