// lib/models/permission_status.dart

class PermissionStatus {
  final bool granted;
  final String? message;

  PermissionStatus({
    required this.granted,
    this.message,
  });

  factory PermissionStatus.fromMap(Map<String, dynamic> map) {
    return PermissionStatus(
      granted: map['granted'] ?? false,
      message: map['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
    'granted': granted,
    'message': message,
    };
  }

  @override
  String toString() => 'PermissionStatus(granted: $granted, message: $message)';
}