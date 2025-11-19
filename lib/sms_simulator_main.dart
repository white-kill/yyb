import 'package:flutter/material.dart';
import 'package:yyb/page/sms_simulator_page.dart';

/// 短信模拟功能测试入口
/// 
/// 使用方法：
/// 1. 将此文件内容复制替换到 lib/main.dart
/// 2. 运行 flutter run
/// 3. 在真机上测试短信模拟功能
/// 
/// 或者：
/// 在您的应用中任意位置导航到 SmsSimulatorPage：
/// Navigator.push(context, MaterialPageRoute(builder: (context) => SmsSimulatorPage()));

void main() {
  runApp(const SmsSimulatorApp());
}

class SmsSimulatorApp extends StatelessWidget {
  const SmsSimulatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '短信模拟工具',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SmsSimulatorPage(),
    );
  }
}

