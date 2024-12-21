// android/src/main/kotlin/com/example/samsung_health_plugin/SamsungHealthPlugin.kt

package com.example.samsung_health_plugin

import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.annotation.NonNull
import android.Manifest
import com.samsung.android.sdk.healthdata.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.*

class SamsungHealthPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var context: Context
  private lateinit var activity: Activity
  private lateinit var channel: MethodChannel
  private lateinit var heartRateEventChannel: EventChannel
  private lateinit var spO2EventChannel: EventChannel
  private lateinit var healthDataStore: HealthDataStore
  private val scope = CoroutineScope(Job() + Dispatchers.Main)

  private var heartRateEventSink: EventChannel.EventSink? = null
  private var spO2EventSink: EventChannel.EventSink? = null

  private val PERMISSIONS = arrayOf(
          Manifest.permission.ACTIVITY_RECOGNITION,
          Manifest.permission.BODY_SENSORS,
          Manifest.permission.BODY_SENSORS_BACKGROUND
  )
  private val PERMISSION_REQUEST_CODE = 100

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "samsung_health_plugin")
    channel.setMethodCallHandler(this)

    // 이벤트 채널 설정
    heartRateEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "samsung_health_plugin/heart_rate")
    heartRateEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        heartRateEventSink = events
      }

      override fun onCancel(arguments: Any?) {
        heartRateEventSink = null
      }
    })

    spO2EventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "samsung_health_plugin/spo2")
    spO2EventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        spO2EventSink = events
      }

      override fun onCancel(arguments: Any?) {
        spO2EventSink = null
      }
    })

    // Samsung Health SDK 초기화
    healthDataStore = HealthDataStore(context, connectionListener)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  private val connectionListener = object : HealthDataStore.ConnectionListener {
    override fun onConnected() {
      scope.launch {
        channel.invokeMethod("onConnected", null)
      }
    }

    override fun onDisconnected() {
      scope.launch {
        channel.invokeMethod("onDisconnected", null)
      }
    }

    override fun onConnectionFailed(error: Exception) {
      scope.launch {
        channel.invokeMethod("onConnectionFailed", error.message)
      }
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "requestPermissions" -> {
        requestPermissions(result)
      }
      "initialize" -> {
        initialize(result)
      }
      "startHeartRateMonitoring" -> {
        startHeartRateMonitoring(result)
      }
      "startSpO2Monitoring" -> {
        startSpO2Monitoring(result)
      }
      "getLatestHealthData" -> {
        getLatestHealthData(result)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun requestPermissions(result: Result) {
    val permissionsToRequest = mutableListOf<String>()

    // 필요한 권한 확인
    for (permission in PERMISSIONS) {
      if (ContextCompat.checkSelfPermission(context, permission)
              != PackageManager.PERMISSION_GRANTED) {
        permissionsToRequest.add(permission)
      }
    }

    // Samsung Health 권한 확인
    val healthPermissionListener = object : HealthResultHolder.ResultListener<HealthPermissionManager.PermissionResult> {
      override fun onSuccess(permissionResult: HealthPermissionManager.PermissionResult) {
        scope.launch {
          if (permissionResult.isGranted) {
            result.success(mapOf("granted" to true))
          } else {
            result.success(mapOf("granted" to false, "message" to "Samsung Health 권한이 거부됨"))
          }
        }
      }

      override fun onError(error: Exception) {
        scope.launch {
          result.success(mapOf("granted" to false, "message" to error.message))
        }
      }
    }

    if (permissionsToRequest.isNotEmpty()) {
      ActivityCompat.requestPermissions(
              activity,
              permissionsToRequest.toTypedArray(),
              PERMISSION_REQUEST_CODE
      )
    }

    // Samsung Health 권한 요청
    val permissions = setOf(
            PermissionKey(HealthConstants.HeartRate.HEALTH_DATA_TYPE, PermissionType.READ),
            PermissionKey(HealthConstants.BloodOxygen.HEALTH_DATA_TYPE, PermissionType.READ)
    )

    try {
      val permissionManager = HealthPermissionManager(healthDataStore)
      permissionManager.requestPermissions(permissions, healthPermissionListener)
    } catch (e: Exception) {
      result.success(mapOf("granted" to false, "message" to e.message))
    }
  }

  private fun initialize(result: Result) {
    try {
      healthDataStore.connectService()
      result.success(true)
    } catch (e: Exception) {
      result.error("INIT_ERROR", e.message, null)
    }
  }

  // ... (이전에 제공한 나머지 메서드들: startHeartRateMonitoring, startSpO2Monitoring, getLatestHealthData 등)

  override fun onDetachedFromActivity() {}
  override fun onDetachedFromActivityForConfigChanges() {}
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    scope.cancel()
    healthDataStore.disconnectService()
  }
}