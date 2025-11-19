package com.example.sms_simulator_plugin

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Telephony
import androidx.annotation.NonNull
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** SmsSimulatorPlugin */
class SmsSimulatorPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    private val CHANNEL_ID = "sms_channel"
    private val NOTIFICATION_ID = 1001

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sms_simulator_plugin")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext

        // 创建通知渠道
        createNotificationChannel()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }

            "isDefaultSmsApp" -> {
                val isDefault = isDefaultSmsApp()
                result.success(isDefault)
            }

            "requestDefaultSmsApp" -> {
                requestDefaultSmsApp()
                result.success(null)
            }

            "simulateReceiveSms" -> {
                val sender = call.argument<String>("sender")
                val message = call.argument<String>("message")

                if (sender != null && message != null) {
                    val success = simulateReceiveSms(sender, message)
                    result.success(success)
                } else {
                    result.error("INVALID_ARGUMENT", "发件人或内容为空", null)
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    /**
     * 检查是否为默认短信应用
     */
    private fun isDefaultSmsApp(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            val defaultSmsPackage = Telephony.Sms.getDefaultSmsPackage(context)
            context.packageName == defaultSmsPackage
        } else {
            true
        }
    }

    /**
     * 请求设为默认短信应用
     */
    private fun requestDefaultSmsApp() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            val intent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT).apply {
                putExtra(Telephony.Sms.Intents.EXTRA_PACKAGE_NAME, context.packageName)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(intent)
        }
    }

    /**
     * 模拟接收短信（写入系统数据库）
     */
    private fun simulateReceiveSms(sender: String, message: String): Boolean {
        if (!isDefaultSmsApp()) {
            return false
        }

        return try {
            val values = ContentValues().apply {
                put("address", sender)
                put("body", message)
                put("date", System.currentTimeMillis())
                put("type", 1)  // 1 = 收件箱
                put("read", 0)  // 0 = 未读
                put("seen", 0)  // 0 = 未看到
                put("status", -1) // -1 = 接收完成
            }

            val uri = context.contentResolver.insert(
                Uri.parse("content://sms/inbox"),
                values
            )

            if (uri != null) {
                // 发送系统通知
                sendSmsNotification(sender, message)
                true
            } else {
                false
            }
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    /**
     * 创建通知渠道（Android 8.0+）
     */
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "短信通知"
            val descriptionText = "接收短信通知"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
                enableLights(true)
                enableVibration(true)
                vibrationPattern = longArrayOf(0, 250, 250, 250)
            }

            val notificationManager: NotificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    /**
     * 发送短信通知
     */
    private fun sendSmsNotification(sender: String, message: String) {
        try {
            val intent = Intent(Intent.ACTION_MAIN).apply {
                addCategory(Intent.CATEGORY_APP_MESSAGING)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            }

            val pendingIntentFlags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }

            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent, pendingIntentFlags
            )

            val builder = NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(getNotificationIcon())  // 使用 App 图标
                .setContentTitle(sender)
                .setContentText(message)
                .setStyle(NotificationCompat.BigTextStyle().bigText(message))
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setCategory(NotificationCompat.CATEGORY_MESSAGE)
                .setAutoCancel(true)
                .setContentIntent(pendingIntent)
                .setVibrate(longArrayOf(0, 250, 250, 250))
                .setDefaults(NotificationCompat.DEFAULT_SOUND)

            with(NotificationManagerCompat.from(context)) {
                notify(NOTIFICATION_ID, builder.build())
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    /**
     * 获取通知图标
     * 优先使用 App 图标，如果获取失败则使用系统默认图标
     */
    private fun getNotificationIcon(): Int {
        return try {
            // 尝试获取 App 的启动图标
            val packageManager = context.packageManager
            val applicationInfo = packageManager.getApplicationInfo(context.packageName, 0)
            applicationInfo.icon
        } catch (e: Exception) {
            // 如果获取失败，使用系统默认图标
            android.R.drawable.sym_action_chat
        }
    }
}
