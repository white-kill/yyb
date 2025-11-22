import 'package:flutter/material.dart';
import 'package:app_checker_plugin/app_checker_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Checker Plugin Example',
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
  final _checker = AppChecker();
  final List<Map<String, dynamic>> _appResults = [];
  bool _isLoading = false;

  // 常用应用列表
  final List<Map<String, String>> _commonApps = [
    {'name': '微信', 'package': 'com.tencent.mm'},
    {'name': 'QQ', 'package': 'com.tencent.mobileqq'},
    {'name': '支付宝', 'package': 'com.eg.android.AlipayGphone'},
    {'name': '抖音', 'package': 'com.ss.android.ugc.aweme'},
    {'name': '淘宝', 'package': 'com.taobao.taobao'},
    {'name': '京东', 'package': 'com.jingdong.app.mall'},
    {'name': '微博', 'package': 'com.sina.weibo'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Checker Plugin 示例'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _checkCommonApps,
                  child: const Text('检查常用应用'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _getInstalledApps,
                  child: const Text('获取已安装应用列表'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _checkSpecificApp,
                  child: const Text('检查微信详细信息'),
                ),
              ],
            ),
          ),
          const Divider(),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _appResults.length,
                itemBuilder: (context, index) {
                  final app = _appResults[index];
                  return ListTile(
                    leading: Icon(
                      app['isInstalled'] == true
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: app['isInstalled'] == true
                          ? Colors.green
                          : Colors.red,
                    ),
                    title: Text(app['name'] ?? app['appName'] ?? '未知'),
                    subtitle: Text(app['package'] ?? app['packageName'] ?? ''),
                    trailing: app['version'] != null
                        ? Text(
                            app['version'],
                            style: const TextStyle(fontSize: 12),
                          )
                        : null,
                    onTap: () {
                      if (app['isInstalled'] == true && app['package'] != null) {
                        _showAppOptions(app['package']);
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _checkCommonApps() async {
    setState(() {
      _isLoading = true;
      _appResults.clear();
    });

    for (var app in _commonApps) {
      final isInstalled = await _checker.isAppInstalled(app['package']!);
      setState(() {
        _appResults.add({
          'name': app['name'],
          'package': app['package'],
          'isInstalled': isInstalled,
        });
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getInstalledApps() async {
    setState(() {
      _isLoading = true;
      _appResults.clear();
    });

    final apps = await _checker.getInstalledApps();
    
    setState(() {
      _appResults.addAll(apps.map((app) => {
            'appName': app.appName,
            'packageName': app.packageName,
            'isInstalled': true,
            'version': '${app.versionName} (${app.versionCode})',
          }));
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('找到 ${apps.length} 个已安装应用')),
      );
    }
  }

  Future<void> _checkSpecificApp() async {
    setState(() {
      _isLoading = true;
      _appResults.clear();
    });

    final appInfo = await _checker.getAppInfo('com.tencent.mm');
    
    if (appInfo != null) {
      setState(() {
        _appResults.add({
          'name': '微信详细信息',
          'appName': appInfo.appName,
          'packageName': appInfo.packageName,
          'isInstalled': true,
          'version': '${appInfo.versionName} (${appInfo.versionCode})',
        });
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(appInfo.appName),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('包名: ${appInfo.packageName}'),
                Text('版本: ${appInfo.versionName}'),
                Text('版本号: ${appInfo.versionCode}'),
                if (appInfo.firstInstallTime != null)
                  Text('安装时间: ${appInfo.firstInstallTime}'),
                if (appInfo.lastUpdateTime != null)
                  Text('更新时间: ${appInfo.lastUpdateTime}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _checker.openApp('com.tencent.mm');
                },
                child: const Text('打开应用'),
              ),
            ],
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('微信未安装')),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showAppOptions(String packageName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('应用操作'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text('打开应用'),
              onTap: () {
                Navigator.pop(context);
                _checker.openApp(packageName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('应用详情'),
              onTap: () {
                Navigator.pop(context);
                _checker.openAppDetails(packageName);
              },
            ),
          ],
        ),
      ),
    );
  }
}

