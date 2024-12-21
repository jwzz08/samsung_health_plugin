// test/samsung_health_plugin_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_plugin/samsung_health_plugin.dart';
import 'package:samsung_health_plugin/samsung_health_plugin_platform_interface.dart';
import 'package:samsung_health_plugin/samsung_health_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSamsungHealthPluginPlatform
    with MockPlatformInterfaceMixin
    implements SamsungHealthPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> initialize() => Future.value(true);

  @override
  Future<bool> startHeartRateMonitoring() => Future.value(true);

  @override
  Future<bool> startSpO2Monitoring() => Future.value(true);

  @override
  Future<Map<String, dynamic>> getLatestHealthData() =>
      Future.value({'heartRate': 75, 'spO2': 98});

  @override
  Future<Map<String, dynamic>> requestPermissions() =>
      Future.value({'granted': true});

  @override
  Stream<Map<String, dynamic>> get heartRateStream =>
      Stream.fromIterable([
        {'heartRate': 75, 'timestamp': DateTime.now().millisecondsSinceEpoch}
      ]);

  @override
  Stream<Map<String, dynamic>> get spO2Stream =>
      Stream.fromIterable([
        {'spO2': 98, 'timestamp': DateTime.now().millisecondsSinceEpoch}
      ]);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MockSamsungHealthPluginPlatform mockPlatform = MockSamsungHealthPluginPlatform();

  group('SamsungHealthPlugin', () {
    setUp(() {
      SamsungHealthPluginPlatform.instance = mockPlatform;
    });

    test('getPlatformVersion', () async {
      expect(await SamsungHealthPlugin.getPlatformVersion(), '42');
    });

    test('initialize', () async {
      expect(await SamsungHealthPlugin.initialize(), true);
    });

    test('startHeartRateMonitoring', () async {
      expect(await SamsungHealthPlugin.startHeartRateMonitoring(), true);
    });

    test('startSpO2Monitoring', () async {
      expect(await SamsungHealthPlugin.startSpO2Monitoring(), true);
    });

    test('getLatestHealthData', () async {
      final result = await SamsungHealthPlugin.getLatestHealthData();
      expect(result, {'heartRate': 75, 'spO2': 98});
    });

    test('requestPermissions', () async {
      final result = await SamsungHealthPlugin.requestPermissions();
      expect(result, {'granted': true});
    });

    test('heartRateStream', () {
      expect(
          SamsungHealthPlugin.heartRateStream,
          emits(predicate((Map<String, dynamic> data) =>
          data.containsKey('heartRate') && data.containsKey('timestamp')))
      );
    });

    test('spO2Stream', () {
      expect(
          SamsungHealthPlugin.spO2Stream,
          emits(predicate((Map<String, dynamic> data) =>
          data.containsKey('spO2') && data.containsKey('timestamp')))
      );
    });
  });
}