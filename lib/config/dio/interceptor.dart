import 'package:yyb/utils/sp_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:wb_base_widget/extension/string_extension.dart';

import '../../routes/app_pages.dart';
import 'dio_response.dart';

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // error统一处理
    AppException appException = AppException.init(err);

    // 详细的错误信息输出
    debugPrint('=' * 50);
    debugPrint('❌ 网络请求失败');
    debugPrint('=' * 50);
    debugPrint('🌐 请求URL: ${err.requestOptions.uri}');
    debugPrint('📋 请求方法: ${err.requestOptions.method}');
    debugPrint('❗ 错误类型: ${err.type}');
    debugPrint('💬 错误消息: ${err.message}');
    debugPrint('📊 状态码: ${err.response?.statusCode ?? "无"}');
    debugPrint('📦 响应数据: ${err.response?.data ?? "无"}');
    debugPrint('🔧 异常信息: ${appException.toString()}');

    // 如果有更详细的错误信息
    if (err.error != null) {
      debugPrint('⚠️  底层错误: ${err.error}');
    }

    // 输出请求头
    if (err.requestOptions.headers.isNotEmpty) {
      debugPrint('📨 请求头:');
      err.requestOptions.headers.forEach((key, value) {
        debugPrint('  $key: $value');
      });
    }

    debugPrint('=' * 50);

    err.copyWith(error: {err: appException});

    handler.next(err);
  }
}

/// 自定义异常
class AppException implements Exception {
  final String? message;
  final int? code;

  AppException(this.code, this.message);

  @override
  String toString() => "$code$message";

  factory AppException.init(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return AppException(-1, "请求取消");
      case DioExceptionType.connectionTimeout:
        return AppException(-1, "连接超时");
      case DioExceptionType.sendTimeout:
        return AppException(-1, "请求超时");
      case DioExceptionType.receiveTimeout:
        return AppException(-1, "响应超时");
      case DioExceptionType.badResponse:
        try {
          int errCode = error.response?.statusCode ?? -1;
          switch (errCode) {
            case 400:
              return AppException(errCode, "请求语法错误");
            case 401:
              return AppException(errCode, "没有权限");
            case 403:
              return AppException(errCode, "服务器拒绝执行");
            case 404:
              return AppException(errCode, "无法连接服务器");
            case 405:
              return AppException(errCode, "请求方法被禁止");
            case 500:
              return AppException(errCode, "服务器内部错误");
            case 502:
              return AppException(errCode, "无效的请求");
            case 503:
              return AppException(errCode, "服务器挂了");
            case 505:
              return AppException(errCode, "不支持HTTP协议请求");
            default:
              return AppException(
                errCode,
                error.response?.statusMessage ?? '未知错误',
              );
          }
        } catch (e) {
          return AppException(-1, "未知错误：${e.toString()}");
        }
      default:
        return AppException(-1, error.message);
    }
  }
}

///此处定义一个响应拦截器
class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 检查是否需要保留原始响应（用于 allRequest）
    final keepOriginalResponse =
        response.requestOptions.extra['keepOriginalResponse'] ?? false;

    if (keepOriginalResponse) {
      // 保留原始响应，不做任何修改
      debugPrint('=' * 50);
      debugPrint('✅ 网络请求成功 (保留原始响应)');
      debugPrint('🌐 请求URL: ${response.requestOptions.uri}');
      debugPrint('📊 状态码: ${response.statusCode}');
      debugPrint('=' * 50);
      handler.next(response);
      return;
    }

    //处理最外层数据结构
    BaseResponse bean = BaseResponse.fromJson(response.data);

    // 输出响应信息
    debugPrint('=' * 50);
    debugPrint('✅ 网络请求成功');
    debugPrint('🌐 请求URL: ${response.requestOptions.uri}');
    debugPrint('📊 状态码: ${response.statusCode}');
    debugPrint('🔢 业务码: ${bean.code}');
    debugPrint('💬 消息: ${bean.msg ?? "无"}');
    debugPrint('=' * 50);

    //可以在此处处理一些通用的错误信息
    if (bean.code == 401) {
      '登陆失效，请重新登陆'.showToast;
      ''.saveToken;
      Get.offAllNamed(Routes.login);
    }
    if (bean.code != 200) {
      (bean.msg ?? '请求失败').showToast;
      debugPrint('⚠️  业务错误: ${bean.msg}');
    }
    response.data = bean.data;

    handler.next(response);
  }
}

///此处定义一个弹窗加载拦截器
class LoadingInterceptor extends Interceptor {
  bool isLoading = true;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //打开加载弹窗
    try {
      if (isLoading) ''.showLoading;
    } catch (e) {
      debugPrint('Loading interceptor error: $e');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    //关闭弹窗
    try {
      if (isLoading && SmartDialog.config.checkExist()) {
        await SmartDialog.dismiss(status: SmartStatus.loading);
      }
    } catch (e) {
      debugPrint('Loading dismiss error: $e');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    //关闭弹窗
    try {
      if (isLoading && SmartDialog.config.checkExist()) {
        await SmartDialog.dismiss(status: SmartStatus.loading);
      }
    } catch (e) {
      debugPrint('Loading dismiss error: $e');
    }

    handler.next(err);
  }
}
