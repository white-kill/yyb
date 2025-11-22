package com.example.app_checker_plugin

import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class AppCheckerPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app_checker_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "isAppInstalled" -> {
                val packageName = call.argument<String>("packageName")
                if (packageName != null) {
                    result.success(isAppInstalled(packageName))
                } else {
                    result.error("INVALID_ARGUMENT", "包名为空", null)
                }
            }
            "checkMultipleApps" -> {
                val packageNames = call.argument<List<String>>("packageNames")
                if (packageNames != null) {
                    val results = checkMultipleApps(packageNames)
                    result.success(results)
                } else {
                    result.error("INVALID_ARGUMENT", "包名列表为空", null)
                }
            }
            "getAppInfo" -> {
                val packageName = call.argument<String>("packageName")
                if (packageName != null) {
                    result.success(getAppInfo(packageName))
                } else {
                    result.error("INVALID_ARGUMENT", "包名为空", null)
                }
            }
            "getInstalledApps" -> {
                val includeSystemApps = call.argument<Boolean>("includeSystemApps") ?: false
                result.success(getInstalledApps(includeSystemApps))
            }
            "openApp" -> {
                val packageName = call.argument<String>("packageName")
                if (packageName != null) {
                    result.success(openApp(packageName))
                } else {
                    result.error("INVALID_ARGUMENT", "包名为空", null)
                }
            }
            "openAppDetails" -> {
                val packageName = call.argument<String>("packageName")
                if (packageName != null) {
                    result.success(openAppDetails(packageName))
                } else {
                    result.error("INVALID_ARGUMENT", "包名为空", null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun isAppInstalled(packageName: String): Boolean {
        return try {
            context.packageManager.getPackageInfo(packageName, 0)
            true
        } catch (e: Exception) {
            false
        }
    }

    private fun checkMultipleApps(packageNames: List<String>): Map<String, Boolean> {
        val results = mutableMapOf<String, Boolean>()
        for (packageName in packageNames) {
            results[packageName] = isAppInstalled(packageName)
        }
        return results
    }

    private fun getAppInfo(packageName: String): Map<String, Any>? {
        return try {
            val packageManager = context.packageManager
            val packageInfo = packageManager.getPackageInfo(packageName, 0)
            val applicationInfo = packageManager.getApplicationInfo(packageName, 0)
            
            val appName = packageManager.getApplicationLabel(applicationInfo).toString()
            
            val versionName = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                packageInfo.longVersionCode.toString()
            } else {
                @Suppress("DEPRECATION")
                packageInfo.versionCode.toString()
            }
            
            val versionCode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                packageInfo.longVersionCode.toInt()
            } else {
                @Suppress("DEPRECATION")
                packageInfo.versionCode
            }

            mapOf(
                "packageName" to packageName,
                "appName" to appName,
                "versionName" to (packageInfo.versionName ?: "未知"),
                "versionCode" to versionCode,
                "firstInstallTime" to packageInfo.firstInstallTime,
                "lastUpdateTime" to packageInfo.lastUpdateTime
            )
        } catch (e: Exception) {
            null
        }
    }

    private fun getInstalledApps(includeSystemApps: Boolean): List<Map<String, Any>> {
        val packageManager = context.packageManager
        val packages = packageManager.getInstalledPackages(0)
        val appList = mutableListOf<Map<String, Any>>()

        for (packageInfo in packages) {
            try {
                val applicationInfo = packageInfo.applicationInfo
                
                // 如果不包含系统应用，跳过系统应用
                if (!includeSystemApps && (applicationInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0) {
                    continue
                }

                val appName = packageManager.getApplicationLabel(applicationInfo).toString()
                
                val versionCode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    packageInfo.longVersionCode.toInt()
                } else {
                    @Suppress("DEPRECATION")
                    packageInfo.versionCode
                }

                appList.add(
                    mapOf(
                        "packageName" to packageInfo.packageName,
                        "appName" to appName,
                        "versionName" to (packageInfo.versionName ?: "未知"),
                        "versionCode" to versionCode,
                        "firstInstallTime" to packageInfo.firstInstallTime,
                        "lastUpdateTime" to packageInfo.lastUpdateTime
                    )
                )
            } catch (e: Exception) {
                continue
            }
        }

        return appList
    }

    private fun openApp(packageName: String): Boolean {
        return try {
            val intent = context.packageManager.getLaunchIntentForPackage(packageName)
            if (intent != null) {
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                context.startActivity(intent)
                true
            } else {
                false
            }
        } catch (e: Exception) {
            false
        }
    }

    private fun openAppDetails(packageName: String): Boolean {
        return try {
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
            intent.data = Uri.parse("package:$packageName")
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            context.startActivity(intent)
            true
        } catch (e: Exception) {
            false
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

