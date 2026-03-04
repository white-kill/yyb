package com.example.app_installer_plugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

class AppInstallerPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
  private var activity: Activity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app_installer_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "installApk" -> {
        val filePath = call.argument<String>("filePath")
        if (filePath != null) {
          val success = installApk(filePath)
          result.success(success)
        } else {
          result.error("INVALID_ARGUMENT", "文件路径为空", null)
        }
      }
      "isAppInstalled" -> {
        val packageName = call.argument<String>("packageName")
        if (packageName != null) {
          val isInstalled = isAppInstalled(packageName)
          result.success(isInstalled)
        } else {
          result.error("INVALID_ARGUMENT", "包名为空", null)
        }
      }
      "openApp" -> {
        val packageName = call.argument<String>("packageName")
        if (packageName != null) {
          val success = openApp(packageName)
          result.success(success)
        } else {
          result.error("INVALID_ARGUMENT", "包名为空", null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun installApk(filePath: String): Boolean {
    return try {
      val file = File(filePath)
      if (!file.exists()) return false

      val appContext = flutterPluginBinding.applicationContext
      val intent = Intent(Intent.ACTION_VIEW)

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
        val uri = FileProvider.getUriForFile(
          appContext,
          "${appContext.packageName}.fileprovider",
          file
        )
        intent.setDataAndType(uri, "application/vnd.android.package-archive")
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
      } else {
        intent.setDataAndType(Uri.fromFile(file), "application/vnd.android.package-archive")
      }

      // 优先用 Activity 上下文启动，确保系统安装界面作为独立页面跳转而非 dialog 覆盖
      val ctx: Context = activity ?: appContext
      if (ctx is Activity) {
        ctx.startActivity(intent)
      } else {
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        ctx.startActivity(intent)
      }
      true
    } catch (e: Exception) {
      e.printStackTrace()
      false
    }
  }

  private fun isAppInstalled(packageName: String): Boolean {
    return try {
      val context = flutterPluginBinding.applicationContext
      context.packageManager.getPackageInfo(packageName, 0)
      true
    } catch (e: Exception) {
      false
    }
  }

  private fun openApp(packageName: String): Boolean {
    return try {
      val context = flutterPluginBinding.applicationContext
      val intent = context.packageManager.getLaunchIntentForPackage(packageName)
      if (intent != null) {
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        context.startActivity(intent)
        true
      } else {
        false
      }
    } catch (e: Exception) {
      e.printStackTrace()
      false
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

