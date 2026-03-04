import 'package:get/get.dart';
import '../../config/dio/network.dart';
import '../../config/net_config/apis.dart';
import '../../models/app_model.dart';

import 'state.dart';

class SearchLogic extends GetxController {
  final SearchState state = SearchState();

  /// 页面
  var pageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getAppList();
  }

  /// 获取应用列表
  Future<void> getAppList() async {
    print('🔄 开始请求应用列表...');
    try {
      final response = await Http.getAll(
        Apis.appList,
        queryParameters: {
          'pageNum': 1,
          'pageSize': 100,
        },
      );

      print('📡 API响应状态码: ${response.statusCode}');
      print('📦 API响应数据: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        print('✅ 响应码: ${data['code']}');
        
        if (data['code'] == 200 && data['rows'] != null) {
          final List<dynamic> rows = data['rows'];
          print('📋 获取到 ${rows.length} 个应用');
          
          state.appList.value = rows.map((e) => AppModel.fromJson(e)).toList();
          // 打印所有应用的bundleId
          for (var app in state.appList) {
            print('📱 应用: ${app.fileName}, bundleId: ${app.bundleId}');
          }

          state.appList.value.removeWhere((item) => item.fileName == 'app-release.apk');
          print('✅ 应用列表加载成功，共 ${state.appList.length} 个应用');
        } else {
          print('❌ 响应码不是200或rows为空');
        }
      } else {
        print('❌ HTTP状态码不是200或响应数据为空');
      }
    } catch (e, stackTrace) {
      print('❌ 获取应用列表失败: $e');
      print('堆栈: $stackTrace');
    }
  }

  /// 根据文件名关键字查找应用（以服务器返回数据为准）
  AppModel? findAppByKeyword(String keyword) {
    try {
      return state.appList.firstWhere(
        (app) => app.fileName?.contains(keyword) ?? false,
        orElse: () => throw Exception('Not found'),
      );
    } catch (_) {
      return null;
    }
  }

  String getAppNameByFileName(String fileName) {
    return fileName.replaceAll('银行.apk', '').replaceAll('中国', '').replaceAll('口袋', '');
  }
}
