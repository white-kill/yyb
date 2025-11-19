# 📦 SMS Simulator Plugin - 快速使用指南

## 🎯 插件已创建完成！

位置：`F:\projects\sms_simulator_plugin`

---

## 🚀 如何在您的项目中使用

### 方法一：本地引用（开发测试）

在您的项目的 `pubspec.yaml` 中：

```yaml
dependencies:
  sms_simulator_plugin:
    path: ../sms_simulator_plugin  # 相对路径指向插件目录
  permission_handler: ^12.0.0
```

### 方法二：发布到 pub.dev（推荐）

1. **完善插件信息**
   - 修改 `pubspec.yaml` 中的 homepage、repository 链接
   - 添加 LICENSE 文件
   - 完善 README.md

2. **发布到 pub.dev**
   ```bash
   cd sms_simulator_plugin
   flutter pub publish --dry-run  # 先测试
   flutter pub publish  # 正式发布
   ```

3. **在项目中使用**
   ```yaml
   dependencies:
     sms_simulator_plugin: ^1.0.0
   ```

---

## 📝 必需配置

### 1. AndroidManifest.xml 配置

在使用插件的项目中，需要在 `android/app/src/main/AndroidManifest.xml` 添加：

```xml
<activity android:name=".MainActivity">
    <!-- 现有 intent-filter -->
    
    <!-- 添加 sms: 协议支持 -->
    <intent-filter>
        <action android:name="android.intent.action.SENDTO" />
        <category android:name="android.intent.category.DEFAULT" />
        <data android:scheme="sms" />
        <data android:scheme="smsto" />
    </intent-filter>
</activity>

<!-- 添加短信接收器 -->
<receiver
    android:name="com.example.sms_simulator_plugin.SmsReceiver"
    android:permission="android.permission.BROADCAST_SMS"
    android:exported="true">
    <intent-filter>
        <action android:name="android.provider.Telephony.SMS_DELIVER" />
    </intent-filter>
</receiver>

<receiver
    android:name="com.example.sms_simulator_plugin.MmsReceiver"
    android:permission="android.permission.BROADCAST_WAP_PUSH"
    android:exported="true">
    <intent-filter>
        <action android:name="android.provider.Telephony.WAP_PUSH_DELIVER" />
        <data android:mimeType="application/vnd.wap.mms-message" />
    </intent-filter>
</receiver>

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
```

### 2. 创建必需的 Kotlin 类

在 `android/app/src/main/kotlin/你的包名/` 创建这3个文件：

**SmsReceiver.kt**:
```kotlin
package com.example.你的应用包名

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony

class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (Telephony.Sms.Intents.SMS_DELIVER_ACTION == intent.action) {
            val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
            for (message in messages) {
                // 处理收到的短信
            }
        }
    }
}
```

**MmsReceiver.kt**:
```kotlin
package com.example.你的应用包名

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class MmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {}
}
```

**HeadlessSmsSendService.kt**:
```kotlin
package com.example.你的应用包名

import android.app.Service
import android.content.Intent
import android.os.IBinder

class HeadlessSmsSendService : Service() {
    override fun onBind(intent: Intent?): IBinder? = null
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int) = START_NOT_STICKY
}
```

---

## 💡 简单使用示例

```dart
import 'package:sms_simulator_plugin/sms_simulator_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

// 1. 请求权限
await [Permission.sms, Permission.phone, Permission.notification].request();

// 2. 检查是否为默认应用
bool isDefault = await SmsSimulatorPlugin.isDefaultSmsApp();

// 3. 设为默认应用（如果不是）
if (!isDefault) {
  await SmsSimulatorPlugin.requestSetAsDefaultSmsApp();
}

// 4. 模拟接收短信
bool success = await SmsSimulatorPlugin.simulateReceiveSms(
  sender: '10086',
  message: '【测试】您的验证码是：123456',
);

if (success) {
  print('✅ 短信模拟成功！打开系统短信应用查看');
}
```

---

## 🧪 运行示例应用

插件自带了完整的示例应用：

```bash
cd sms_simulator_plugin/example
flutter run
```

---

## 📂 插件目录结构

```
sms_simulator_plugin/
├── lib/
│   └── sms_simulator_plugin.dart   # Dart API
├── android/
│   └── src/main/kotlin/           # Android 原生实现
│       └── SmsSimulatorPlugin.kt
├── example/                        # 示例应用
│   ├── lib/main.dart
│   └── android/                   # 包含完整配置
├── README.md                      # 使用文档
└── pubspec.yaml                   # 插件配置
```

---

## 🎁 在您当前项目中使用

回到您的 `ping` 项目：

```bash
cd F:\projects\ping
```

在 `pubspec.yaml` 添加：

```yaml
dependencies:
  sms_simulator_plugin:
    path: ../sms_simulator_plugin
  permission_handler: ^12.0.0
```

然后运行：

```bash
flutter pub get
```

在代码中使用：

```dart
import 'package:sms_simulator_plugin/sms_simulator_plugin.dart';

// 直接调用即可！
bool success = await SmsSimulatorPlugin.simulateReceiveSms(
  sender: '10086',
  message: '测试短信',
);
```

---

## ✅ 优势

相比直接在项目中实现，插件方式的优势：

1. **复用性** - 可以在多个项目中使用
2. **维护性** - 统一维护，一处修改处处生效
3. **分享性** - 可以发布到 pub.dev 供他人使用
4. **模块化** - 代码更清晰，职责分明
5. **测试性** - 独立测试，不影响主项目

---

## 📱 下一步

1. **测试插件**：运行 example 应用测试功能
2. **集成到项目**：在您的 ping 项目中使用
3. **发布插件**（可选）：发布到 pub.dev
4. **完善文档**：根据实际使用情况完善 README

---

**插件已准备就绪，开始使用吧！** 🎉

