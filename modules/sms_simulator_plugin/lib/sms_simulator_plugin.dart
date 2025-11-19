import 'dart:async';
import 'package:flutter/services.dart';

/// SMS 模拟器插件
/// 
/// 用于在 Android 设备上模拟接收短信，短信会写入系统数据库并弹出通知
class SmsSimulatorPlugin {
  static const MethodChannel _channel = MethodChannel('sms_simulator_plugin');

  /// 检查当前应用是否为默认短信应用
  /// 
  /// 返回 [true] 表示是默认应用，[false] 表示不是
  /// 
  /// 只有默认短信应用才有权限写入短信数据库
  static Future<bool> isDefaultSmsApp() async {
    try {
      final bool? result = await _channel.invokeMethod('isDefaultSmsApp');
      return result ?? false;
    } on PlatformException catch (e) {
      throw SmsSimulatorException(
        'Failed to check default SMS app: ${e.message}',
        code: e.code,
      );
    }
  }

  /// 请求将当前应用设为默认短信应用
  /// 
  /// 会跳转到系统设置页面，让用户选择
  /// 
  /// 注意：这个方法会打开系统设置，需要用户手动确认
  static Future<void> requestSetAsDefaultSmsApp() async {
    try {
      await _channel.invokeMethod('requestDefaultSmsApp');
    } on PlatformException catch (e) {
      throw SmsSimulatorException(
        'Failed to request default SMS app: ${e.message}',
        code: e.code,
      );
    }
  }

  /// 模拟接收一条短信
  /// 
  /// [sender] 发件人号码，如 "10086"
  /// [message] 短信内容
  /// 
  /// 返回 [true] 表示成功，[false] 表示失败
  /// 
  /// 前提条件：
  /// 1. 必须先设为默认短信应用
  /// 2. 必须授予短信相关权限
  /// 
  /// 效果：
  /// - 短信会写入系统数据库
  /// - 系统短信应用可以看到
  /// - 会弹出系统通知
  /// - 震动 + 铃声提醒
  /// 
  /// 示例：
  /// ```dart
  /// bool success = await SmsSimulatorPlugin.simulateReceiveSms(
  ///   sender: '10086',
  ///   message: '【测试】您的验证码是：123456',
  /// );
  /// ```
  static Future<bool> simulateReceiveSms({
    required String sender,
    required String message,
  }) async {
    if (sender.isEmpty || message.isEmpty) {
      throw ArgumentError('Sender and message cannot be empty');
    }

    try {
      final bool? result = await _channel.invokeMethod(
        'simulateReceiveSms',
        {
          'sender': sender,
          'message': message,
        },
      );
      return result ?? false;
    } on PlatformException catch (e) {
      throw SmsSimulatorException(
        'Failed to simulate SMS: ${e.message}',
        code: e.code,
      );
    }
  }

  /// 获取插件版本号
  static Future<String> getPlatformVersion() async {
    try {
      final String? version = await _channel.invokeMethod('getPlatformVersion');
      return version ?? 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }
}

/// SMS 模拟器异常类
class SmsSimulatorException implements Exception {
  final String message;
  final String? code;

  SmsSimulatorException(this.message, {this.code});

  @override
  String toString() => 'SmsSimulatorException: $message${code != null ? ' (code: $code)' : ''}';
}
