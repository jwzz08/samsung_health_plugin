// example/lib/main.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:samsung_health_plugin/samsung_health_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  int _heartRate = 0;
  double _spO2 = 0.0;
  bool _isInitialized = false;
  StreamSubscription? _heartRateSubscription;
  StreamSubscription? _spO2Subscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      // 플랫폼 버전 확인
      platformVersion = await SamsungHealthPlugin.getPlatformVersion() ??
          'Unknown platform version';

      // Samsung Health 초기화
      await SamsungHealthPlugin.initialize();

      // 심박수 모니터링 시작
      await SamsungHealthPlugin.startHeartRateMonitoring();
      _heartRateSubscription = SamsungHealthPlugin.heartRateStream.listen((data) {
        setState(() {
          _heartRate = data['heartRate'] as int;
        });
      });

      // 산소포화도 모니터링 시작
      await SamsungHealthPlugin.startSpO2Monitoring();
      _spO2Subscription = SamsungHealthPlugin.spO2Stream.listen((data) {
        setState(() {
          _spO2 = data['spO2'] as double;
        });
      });

      setState(() {
        _isInitialized = true;
      });
    } on PlatformException catch (e) {
      platformVersion = 'Failed to get platform version: ${e.message}';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  void dispose() {
    _heartRateSubscription?.cancel();
    _spO2Subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Samsung Health Plugin Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion\n'),
              if (_isInitialized) ...[
                Text('Heart Rate: $_heartRate BPM'),
                const SizedBox(height: 20),
                Text('SpO2: $_spO2%'),
              ] else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}