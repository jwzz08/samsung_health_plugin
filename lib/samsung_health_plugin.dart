// lib/samsung_health_plugin.dart

import 'samsung_health_plugin_platform_interface.dart';
export 'models/permission_status.dart';

class SamsungHealthPlugin {
  static Future<String?> getPlatformVersion() {
    return SamsungHealthPluginPlatform.instance.getPlatformVersion();
  }

  static Future<Map<String, dynamic>> requestPermissions() {
    return SamsungHealthPluginPlatform.instance.requestPermissions();
  }

  static Future<bool> initialize() async {
    final permissionResult = await requestPermissions();
    if (permissionResult['granted'] == true) {
      return SamsungHealthPluginPlatform.instance.initialize();
    }
    return false;
  }

  static Future<bool> startHeartRateMonitoring() {
    return SamsungHealthPluginPlatform.instance.startHeartRateMonitoring();
  }

  static Future<bool> startSpO2Monitoring() {
    return SamsungHealthPluginPlatform.instance.startSpO2Monitoring();
  }

  static Future<Map<String, dynamic>> getLatestHealthData() {
    return SamsungHealthPluginPlatform.instance.getLatestHealthData();
  }

  static Stream<Map<String, dynamic>> get heartRateStream =>
      SamsungHealthPluginPlatform.instance.heartRateStream;

  static Stream<Map<String, dynamic>> get spO2Stream =>
      SamsungHealthPluginPlatform.instance.spO2Stream;
}