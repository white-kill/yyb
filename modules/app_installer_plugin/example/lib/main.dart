import 'package:flutter/material.dart';
import 'package:app_installer_plugin/app_installer_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Installer Plugin Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _manager = AppDownloadManager();
  String _status = '准备就绪';
  double _progress = 0.0;
  String _downloadInfo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Installer Plugin 示例'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '状态: $_status',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 8),
            Text('进度: ${(_progress * 100).toStringAsFixed(1)}%'),
            const SizedBox(height: 8),
            Text(_downloadInfo),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startDownload,
              child: const Text('开始下载'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkPermissions,
              child: const Text('检查权限'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startDownload() async {
    // 检查权限
    if (!await PermissionUtil.requestStoragePermission()) {
      setState(() {
        _status = '需要存储权限';
      });
      return;
    }

    setState(() {
      _status = '开始下载...';
    });

    // 替换成你的APK下载链接
    const url = 'https://example.com/app.apk';
    const appName = '测试应用';

    try {
      await _manager.startDownload(
        url: url,
        appName: appName,
        onProgress: (received, total, progress) {
          setState(() {
            _progress = progress;
            _status = '下载中';
            _downloadInfo = '${AppDownloadManager.formatBytes(received)} / ${AppDownloadManager.formatBytes(total)}';
          });
        },
        onStatusChange: (status, task) async {
          setState(() {
            _status = task.statusText;
          });

          if (status == DownloadStatus.completed) {
            // 下载完成，准备安装
            if (await PermissionUtil.requestInstallPermission()) {
              await AppInstaller().installApk(
                task,
                onStatusChange: (success, message) {
                  setState(() {
                    _status = message ?? '';
                  });
                },
              );
            } else {
              setState(() {
                _status = '需要安装权限';
              });
            }
          }
        },
        onError: (error, task) {
          setState(() {
            _status = '错误: $error';
          });
        },
      );
    } catch (e) {
      setState(() {
        _status = '下载失败: $e';
      });
    }
  }

  Future<void> _checkPermissions() async {
    final storage = await PermissionUtil.checkStoragePermission();
    final install = await PermissionUtil.checkInstallPermission();

    setState(() {
      _status = '存储权限: $storage, 安装权限: $install';
    });
  }
}
