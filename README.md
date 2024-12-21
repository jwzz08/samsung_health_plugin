# samsung_health_plugin

A Flutter plugin for Samsung Health SDK that provides access to health and fitness data.

## Features

- Real-time heart rate monitoring
- Real-time SpO2 (blood oxygen) monitoring
- Access to historical health data
- Automatic data synchronization
- IoT server integration support

## Getting Started

### Prerequisites

1. Samsung Health app must be installed on the device
2. Minimum Android SDK version: 23 (Android 6.0)
3. Device must have Samsung Health compatible sensors

### Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  samsung_health_plugin: ^0.0.1
```

### Android Setup

Add the following permissions to your Android Manifest (android/app/src/main/AndroidManifest.xml):

```xml
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />
<uses-permission android:name="android.permission.BODY_SENSORS" />
<uses-permission android:name="com.samsung.health.permission.read" />

<queries>
    <package android:name="com.samsung.android.health" />
</queries>
```

## Usage

### Initialize the plugin

```dart
await SamsungHealthPlugin.initialize();
```

### Start heart rate monitoring

```dart
await SamsungHealthPlugin.startHeartRateMonitoring();

// Listen to heart rate updates
SamsungHealthPlugin.heartRateStream.listen((data) {
  print('Heart Rate: ${data['heartRate']} BPM');
  print('Timestamp: ${data['timestamp']}');
});
```

### Start SpO2 monitoring

```dart
await SamsungHealthPlugin.startSpO2Monitoring();

// Listen to SpO2 updates
SamsungHealthPlugin.spO2Stream.listen((data) {
  print('SpO2: ${data['spO2']}%');
  print('Timestamp: ${data['timestamp']}');
});
```

### Get latest health data

```dart
final healthData = await SamsungHealthPlugin.getLatestHealthData();
print('Latest Heart Rate: ${healthData['heartRate']} BPM');
print('Latest SpO2: ${healthData['spO2']}%');
```

## Example

Check the example directory for a complete sample app.

## Contributing

Feel free to contribute to this project.

1. Fork it
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.