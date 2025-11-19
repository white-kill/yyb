# sms_simulator_plugin

一个用于在 Android 设备上模拟接收短信的 Flutter 插件。

[![pub package](https://img.shields.io/badge/pub-v1.0.0-blue)](https://pub.dev/packages/sms_simulator_plugin)
[![Platform](https://img.shields.io/badge/platform-android-green)](https://flutter.dev)

## ✨ 功能特性

- ✅ 模拟接收短信并写入系统数据库
- ✅ 自动弹出系统通知（通知栏）
- ✅ 震动 + 铃声提醒
- ✅ 在系统短信应用中可见
- ✅ 支持设置为默认短信应用
- ✅ 完整的权限管理
- ✅ 简单易用的 API

## 📱 截图

模拟的短信会：
1. 写入系统短信数据库
2. 在通知栏弹出通知
3. 触发震动和铃声
4. 在系统短信应用中显示

## 🚀 快速开始

### 1. 添加依赖

```yaml
dependencies:
  sms_simulator_plugin: ^1.0.0
  permission_handler: ^12.0.0  # 用于权限管理
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 配置 AndroidManifest.xml

在 `android/app/src/main/AndroidManifest.xml` 中添加必需的组件：

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <application>
        <activity android:name=".MainActivity">
            <!-- ... 现有配置 ... -->
            
            <!-- 添加 sms: 协议支持（必需） -->
            <intent-filter>
                <action android:name="android.intent.action.SENDTO" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:scheme="sms" />
                <data android:scheme="smsto" />
            </intent-filter>
        </activity>
        
        <!-- 短信接收器（必需） -->
        <receiver
            android:name="com.example.sms_simulator_plugin.SmsReceiver"
            android:permission="android.permission.BROADCAST_SMS"
            android:exported="true">
            <intent-filter>
                <action android:name="android.provider.Telephony.SMS_DELIVER" />
            </intent-filter>
        </receiver>

        <!-- MMS 接收器（必需） -->
        <receiver
            android:name="com.example.sms_simulator_plugin.MmsReceiver"
            android:permission="android.permission.BROADCAST_WAP_PUSH"
            android:exported="true">
            <intent-filter>
                <action android:name="android.provider.Telephony.WAP_PUSH_DELIVER" />
                <data android:mimeType="application/vnd.wap.mms-message" />
            </intent-filter>
        </receiver>

        <!-- 快速回复服务（必需） -->
        <service
            android:name="com.example.sms_simulator_plugin.HeadlessSmsSendService"
            android:permission="android.permission.SEND_RESPOND_VIA_MESSAGE"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.RESPOND_VIA_MESSAGE" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:scheme="sms" />
                <data android:scheme="smsto" />
                <data android:scheme="mms" />
                <data android:scheme="mmsto" />
            </intent-filter>
        </service>
    </application>
</manifest>
```

### 4. 创建必需的类文件

在您的 Android 项目中创建以下文件：

**SmsReceiver.kt** (`android/app/src/main/kotlin/your/package/name/SmsReceiver.kt`):
```kotlin
package your.package.name // 改成你的包名

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import android.util.Log

class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (Telephony.Sms.Intents.SMS_DELIVER_ACTION == intent.action) {
            val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
            for (message in messages) {
                Log.d("SmsReceiver", "收到短信: ${message.messageBody}")
            }
        }
    }
}
```

**MmsReceiver.kt**:
```kotlin
package your.package.name

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class MmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // 处理 MMS
    }
}
```

**HeadlessSmsSendService.kt**:
```kotlin
package your.package.name

import android.app.Service
import android.content.Intent
import android.os.IBinder

class HeadlessSmsSendService : Service() {
    override fun onBind(intent: Intent?): IBinder? = null
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int) = START_NOT_STICKY
}
```

### 5. 使用示例

```dart
import 'package:flutter/material.dart';
import 'package:sms_simulator_plugin/sms_simulator_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsSimulatorExample extends StatefulWidget {
  @override
  _SmsSimulatorExampleState createState() => _SmsSimulatorExampleState();
}

class _SmsSimulatorExampleState extends State<SmsSimulatorExample> {
  
  @override
  void initState() {
    super.initState();
    _checkDefaultSmsApp();
  }

  // 检查是否为默认短信应用
  Future<void> _checkDefaultSmsApp() async {
    bool isDefault = await SmsSimulatorPlugin.isDefaultSmsApp();
    print('是默认应用: $isDefault');
  }

  // 请求权限
  Future<void> _requestPermissions() async {
    await [
      Permission.sms,
      Permission.phone,
      Permission.notification,
    ].request();
  }

  // 设置为默认应用
  Future<void> _setAsDefaultSmsApp() async {
    await SmsSimulatorPlugin.requestSetAsDefaultSmsApp();
  }

  // 模拟接收短信
  Future<void> _simulateSms() async {
    bool success = await SmsSimulatorPlugin.simulateReceiveSms(
      sender: '10086',
      message: '【测试】您的验证码是：123456，5分钟内有效。',
    );
    
    if (success) {
      print('✅ 短信模拟成功！');
      // 提示用户打开系统短信应用查看
    } else {
      print('❌ 短信模拟失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SMS Simulator')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _requestPermissions,
              child: Text('1. 请求权限'),
            ),
            ElevatedButton(
              onPressed: _setAsDefaultSmsApp,
              child: Text('2. 设为默认短信应用'),
            ),
            ElevatedButton(
              onPressed: _simulateSms,
              child: Text('3. 模拟接收短信'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 📖 API 文档

### `isDefaultSmsApp()`
检查当前应用是否为默认短信应用。

```dart
bool isDefault = await SmsSimulatorPlugin.isDefaultSmsApp();
```

**返回值**:
- `true`: 是默认应用
- `false`: 不是默认应用

---

### `requestSetAsDefaultSmsApp()`
请求将当前应用设为默认短信应用（会打开系统设置页面）。

```dart
await SmsSimulatorPlugin.requestSetAsDefaultSmsApp();
```

---

### `simulateReceiveSms({required String sender, required String message})`
模拟接收一条短信。

```dart
bool success = await SmsSimulatorPlugin.simulateReceiveSms(
  sender: '10086',
  message: '您的验证码是：123456',
);
```

**参数**:
- `sender`: 发件人号码
- `message`: 短信内容

**返回值**:
- `true`: 模拟成功
- `false`: 模拟失败（通常是因为不是默认应用）

**效果**:
1. 短信写入系统数据库
2. 通知栏弹出通知
3. 震动 + 铃声
4. 系统短信应用可见

---

## ⚙️ 权限说明

插件需要以下权限（已在插件的 AndroidManifest.xml 中声明）：

```xml
<!-- 短信相关 -->
<uses-permission android:name="android.permission.SEND_SMS" />
<uses-permission android:name="android.permission.RECEIVE_SMS" />
<uses-permission android:name="android.permission.READ_SMS" />
<uses-permission android:name="android.permission.WRITE_SMS" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.RECEIVE_MMS" />

<!-- 通知相关 -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.VIBRATE" />
```

建议在运行时使用 `permission_handler` 请求权限。

---

## ⚠️ 重要提示

1. **必须在真机上测试** - 模拟器可能不支持
2. **必须设为默认短信应用** - 否则无法写入短信数据库
3. **Android 4.4+** - 仅支持 Android 4.4 (KitKat) 及以上
4. **需要授予权限** - 首次运行需要用户授权
5. **Android 13+** - 需要额外授予通知权限

---

## 🐛 故障排查

### 问题：无法设为默认短信应用

**原因**: 缺少必需的组件

**解决**: 确保在 AndroidManifest.xml 中添加了所有必需的 receiver 和 service

---

### 问题：短信写入失败

**原因**: 权限不足或非默认应用

**解决**:
1. 确认已授予所有短信权限
2. 确认已设为默认短信应用
3. 查看 Logcat 日志

---

### 问题：没有通知弹出

**原因**: 未授予通知权限（Android 13+）

**解决**: 
1. 请求通知权限: `Permission.notification.request()`
2. 在系统设置中确保应用通知已开启

---

## 📝 完整示例

查看 [example](example/) 目录获取完整的示例应用。

运行示例:
```bash
cd example
flutter run
```

---

## 🎯 使用场景

- 测试短信接收功能
- 自动化测试验证码流程
- 开发短信相关应用时的调试
- UI 测试和演示

---

## 📄 许可证

MIT License

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

## 📧 联系方式

如有问题或建议，请提交 Issue。

---

**享受使用！** 🎉
