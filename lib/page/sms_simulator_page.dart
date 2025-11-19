import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_simulator_plugin/sms_simulator_plugin.dart';

/// 短信模拟器页面 - 使用插件版本
class SmsSimulatorPage extends StatefulWidget {
  const SmsSimulatorPage({Key? key}) : super(key: key);

  @override
  State<SmsSimulatorPage> createState() => _SmsSimulatorPageState();
}

class _SmsSimulatorPageState extends State<SmsSimulatorPage> {

  final TextEditingController _senderController =
      TextEditingController(text: '10086');
  final TextEditingController _messageController = TextEditingController(
      text: '【测试】您的验证码是：123456，5分钟内有效。');

  bool _isDefaultSmsApp = false;
  bool _isLoading = false;
  String _statusMessage = '正在检查...';

  @override
  void initState() {
    super.initState();
    _checkDefaultSmsApp();
  }

  /// 检查是否为默认短信应用
  Future<void> _checkDefaultSmsApp() async {
    try {
      final bool result = await SmsSimulatorPlugin.isDefaultSmsApp();
      setState(() {
        _isDefaultSmsApp = result;
        _statusMessage = result ? '✅ 已是默认短信应用' : '⚠️ 需要设置为默认应用';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '检查失败: $e';
      });
    }
  }

  /// 请求短信权限
  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.sms,
      Permission.phone,
      Permission.notification, // 添加通知权限（Android 13+）
    ].request();

    if (statuses[Permission.sms]!.isGranted) {
      _showSnackBar('✅ 权限已授予', isError: false);
    } else {
      _showSnackBar('❌ 需要短信权限', isError: true);
    }
  }

  /// 设置为默认短信应用
  Future<void> _setAsDefaultSmsApp() async {
    try {
      await SmsSimulatorPlugin.requestSetAsDefaultSmsApp();
      // 延迟检查，等待用户操作
      await Future.delayed(const Duration(seconds: 1));
      await _checkDefaultSmsApp();
    } catch (e) {
      _showSnackBar('错误: $e', isError: true);
    }
  }

  /// 模拟接收短信
  Future<void> _simulateReceiveSms() async {
    String sender = _senderController.text.trim();
    String message = _messageController.text.trim();

    if (sender.isEmpty || message.isEmpty) {
      _showSnackBar('❌ 请输入发件人和短信内容', isError: true);
      return;
    }

    if (!_isDefaultSmsApp) {
      _showSnackBar('❌ 请先设置为默认短信应用', isError: true);
      _setAsDefaultSmsApp();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final bool result = await SmsSimulatorPlugin.simulateReceiveSms(
        sender: sender,
        message: message,
      );

      setState(() {
        _isLoading = false;
      });

      if (result) {
        _showSuccessDialog(sender, message);
        _messageController.clear();
      } else {
        _showSnackBar('❌ 写入失败', isError: true);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('错误: $e', isError: true);
    }
  }

  /// 显示成功对话框
  void _showSuccessDialog(String sender, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('发送成功'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('发件人: $sender',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('内容: $message'),
            const SizedBox(height: 16),
            const Text('📱 请打开系统短信应用查看',
                style: TextStyle(color: Colors.blue)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示 SnackBar
  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('短信模拟工具'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 状态卡片
            Card(
              color: _isDefaultSmsApp ? Colors.green[50] : Colors.orange[50],
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      _statusMessage,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (!_isDefaultSmsApp)
                      ElevatedButton.icon(
                        onPressed: _setAsDefaultSmsApp,
                        icon: const Icon(Icons.settings),
                        label: const Text('设置为默认短信应用'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 发件人输入
            TextField(
              controller: _senderController,
              decoration: const InputDecoration(
                labelText: '发件人号码',
                hintText: '例如：10086',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 16),

            // 短信内容输入
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: '短信内容',
                hintText: '输入要模拟接收的短信内容',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.message),
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),

            const SizedBox(height: 24),

            // 模拟接收按钮
            ElevatedButton.icon(
              onPressed: _isDefaultSmsApp && !_isLoading
                  ? _simulateReceiveSms
                  : null,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.sms),
              label: Text(
                _isLoading ? '发送中...' : '📲 模拟接收短信',
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
            ),

            const SizedBox(height: 16),

            // 权限按钮
            OutlinedButton.icon(
              onPressed: _requestPermissions,
              icon: const Icon(Icons.security),
              label: const Text('请求短信权限'),
            ),

            const SizedBox(height: 24),

            // 提示信息
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '使用说明：\n'
                '1. 点击"设置为默认短信应用"\n'
                '2. 在系统弹窗中确认\n'
                '3. 输入发件人和短信内容\n'
                '4. 点击"模拟接收短信"\n'
                '5. 打开系统短信应用查看',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _senderController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

