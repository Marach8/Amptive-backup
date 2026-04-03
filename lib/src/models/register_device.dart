class RegisterDeviceModel {
  RegisterDeviceModel({
    required this.fcmToken,
    this.deviceName,
    required this.platform,
  });

  factory RegisterDeviceModel.fromJson(Map<String, dynamic> json) {
    return RegisterDeviceModel(
      fcmToken: json['fcm_token'] as String,
      deviceName: json['device_name'] as String?,
      platform: json['platform'] as String,
    );
  }

  final String fcmToken;
  final String? deviceName;
  final String platform;

  Map<String, dynamic> toJson() {
    return {
      'fcm_token': fcmToken,
      'device_name': deviceName,
      'platform': platform,
    };
  }
}
