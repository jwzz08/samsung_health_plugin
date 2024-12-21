// lib/samsung_health_plugin_method_channel.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'samsung_health_plugin_platform_interface.dart';

class MethodChannelSamsungHealthPlugin extends SamsungHealthPluginPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('samsung_health_plugin');
  final EventChannel heartRateEventChannel = const EventChannel('samsung_health_plugin/heart_rate');
  final EventChannel spO2EventChannel = const EventChannel('samsung_health_plugin/spo2');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Map<String, dynamic>> requestPermissions() async {
    try {
      final result = await methodChannel.invokeMethod<Map<Object?, Object?>>('requestPermissions');
      return Map<String, dynamic>.from(result ?? {});
    } catch (e) {
      debugPrint('권한 요청 실패: $e');
      return {'error': e.toString()};
    }
  }

  @override
  Future<bool> initialize() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('initialize');
      return result ?? false;
    } catch (e) {
      debugPrint('초기화 실패: $e');
      return false;
    }
  }

  @override
  Future<bool> startHeartRateMonitoring() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('startHeartRateMonitoring');
      return result ?? false;
    } catch (e) {
      debugPrint('심박수 모니터링 시작 실패: $e');
      return false;
    }
  }

  @override
  Future<bool> startSpO2Monitoring() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('startSpO2Monitoring');
      return result ?? false;
    } catch (e) {
      debugPrint('산소포화도 모니터링 시작 실패: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getLatestHealthData() async {
    try {
      final result = await methodChannel.invokeMethod<Map<Object?, Object?>>('getLatestHealthData');
      return Map<String, dynamic>.from(result ?? {});
    } catch (e) {
      debugPrint('건강 데이터 조회 실패: $e');
      return {};
    }
  }

  @override
  Stream<Map<String, dynamic>> get heartRateStream =>
      heartRateEventChannel.receiveBroadcastStream()
          .map((dynamic event) => Map<String, dynamic>.from(event));

  @override
  Stream<Map<String, dynamic>> get spO2Stream =>
      spO2EventChannel.receiveBroadcastStream()
          .map((dynamic event) => Map<String, dynamic>.from(event));
}