// lib/samsung_health_plugin_platform_interface.dart

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'samsung_health_plugin_method_channel.dart';

abstract class SamsungHealthPluginPlatform extends PlatformInterface {
  SamsungHealthPluginPlatform() : super(token: _token);

  static final Object _token = Object();
  static SamsungHealthPluginPlatform _instance = MethodChannelSamsungHealthPlugin();

  static SamsungHealthPluginPlatform get instance => _instance;

  static set instance(SamsungHealthPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map<String, dynamic>> requestPermissions() {
    throw UnimplementedError('requestPermissions() has not been implemented.');
  }

  Future<bool> initialize() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<bool> startHeartRateMonitoring() {
    throw UnimplementedError('startHeartRateMonitoring() has not been implemented.');
  }

  Future<bool> startSpO2Monitoring() {
    throw UnimplementedError('startSpO2Monitoring() has not been implemented.');
  }

  Future<Map<String, dynamic>> getLatestHealthData() {
    throw UnimplementedError('getLatestHealthData() has not been implemented.');
  }

  Stream<Map<String, dynamic>> get heartRateStream;
  Stream<Map<String, dynamic>> get spO2Stream;
}