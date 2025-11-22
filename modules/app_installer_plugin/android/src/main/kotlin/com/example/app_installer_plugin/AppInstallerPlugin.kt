package com.example.app_installer_plugin

import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

class AppInstallerPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app_installer_plugin")
    channel.setMethodCallHandler(this)
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
      if (!file.exists()) {
        return false
      }

      val context = flutterPluginBinding.applicationContext
      val intent = Intent(Intent.ACTION_VIEW)
      intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
        // Android 7.0 及以上使用 FileProvider
        val uri = FileProvider.getUriForFile(
          context,
          "${context.packageName}.fileprovider",
          file
        )
        intent.setDataAndType(uri, "application/vnd.android.package-archive")
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
      } else {
        intent.setDataAndType(Uri.fromFile(file), "application/vnd.android.package-archive")
      }

      context.startActivity(intent)
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

