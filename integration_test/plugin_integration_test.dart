// integration_test/plugin_integration_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:samsung_health_plugin/samsung_health_plugin.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Samsung Health Plugin Tests', () {
    testWidgets('getPlatformVersion test', (WidgetTester tester) async {
      final String? version = await SamsungHealthPlugin.getPlatformVersion();
      expect(version?.isNotEmpty, true);
    });

    testWidgets('initialize test', (WidgetTester tester) async {
      final bool result = await SamsungHealthPlugin.initialize();
      expect(result, true);
    });

    testWidgets('health monitoring test', (WidgetTester tester) async {
      // Start heart rate monitoring
      final bool heartRateResult = await SamsungHealthPlugin.startHeartRateMonitoring();
      expect(heartRateResult, true);

      // Start SpO2 monitoring
      final bool spO2Result = await SamsungHealthPlugin.startSpO2Monitoring();
      expect(spO2Result, true);

      // Test stream data
      await expectLater(
          SamsungHealthPlugin.heartRateStream,
          emits(predicate((Map<String, dynamic> data) =>
          data.containsKey('heartRate') && data.containsKey('timestamp')))
      );

      await expectLater(
          SamsungHealthPlugin.spO2Stream,
          emits(predicate((Map<String, dynamic> data) =>
          data.containsKey('spO2') && data.containsKey('timestamp')))
      );
    });
  });
}