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
      // 심박수 모니터링 시작
      final bool heartRateResult = await SamsungHealthPlugin.startHeartRateMonitoring();
      expect(heartRateResult, true);

      // 산소포화도 모니터링 시작
      final bool spO2Result = await SamsungHealthPlugin.startSpO2Monitoring();
      expect(spO2Result, true);

      // 스트림 데이터 테스트
      SamsungHealthPlugin.heartRateStream.listen(expectAsync1(
              (data) {
            expect(data, contains('heartRate'));
            expect(data, contains('timestamp'));
          },
          count: 1
      ));

      SamsungHealthPlugin.spO2Stream.listen(expectAsync1(
              (data) {
            expect(data, contains('spO2'));
            expect(data, contains('timestamp'));
          },
          count: 1
      ));
    });
  });
}