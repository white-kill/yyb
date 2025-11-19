import 'package:flutter/material.dart';
import 'package:sms_simulator_plugin/sms_simulator_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

/// SMS 模拟器 - 使用插件版本
/// 
/// 这是使用本地插件的示例
/// 插件位置: modules/sms_simulator_plugin
class SmsSimulatorPluginDemo extends StatefulWidget {
  const SmsSimulatorPluginDemo({Key? key}) : super(key: key);

  @override
  State<SmsSimulatorPluginDemo> createState() => _SmsSimulatorPluginDemoState();
}

class _SmsSimulatorPluginDemoState extends State<SmsSimulatorPluginDemo> {
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

  /// 请求权限
  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.sms,
      Permission.phone,
      Permission.notification,
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
      await Future.delayed(const Duration(seconds: 1));
      await _checkDefaultSmsApp();
    } catch (e) {
      _showSnackBar('错误: $e', isError: true);
    }
  }

  /// 模拟接收短信 - 使用插件 API
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
      // 使用插件 API
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
            const SizedBox(height: 8),
            const Text('✅ 通知栏会弹出短信通知',
                style: TextStyle(color: Colors.green, fontSize: 12)),
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
        title: const Text('SMS 模拟器（插件版）'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 插件信息卡片
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          '使用本地插件',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'modules/sms_simulator_plugin',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '使用说明：',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('1. 点击"设置为默认短信应用"', style: TextStyle(fontSize: 12)),
                  Text('2. 在系统弹窗中确认', style: TextStyle(fontSize: 12)),
                  Text('3. 输入发件人和短信内容', style: TextStyle(fontSize: 12)),
                  Text('4. 点击"模拟接收短信"', style: TextStyle(fontSize: 12)),
                  Text('5. 查看系统通知栏和短信应用', style: TextStyle(fontSize: 12)),
                ],
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

