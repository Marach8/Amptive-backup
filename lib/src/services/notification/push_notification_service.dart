import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../config/config_export.dart';
import '../../config/endpoints.dart';
import '../../config/services/network_service/dio_network_service_impl.dart';
import '../../config/services/network_service/network_service.dart';
import '../../models/register_device.dart';

class PushNotificationService {
  final NetworkService _networkService = DioNetworkServiceImpl();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final StreamController<RemoteMessage> _messageStreamController = StreamController<RemoteMessage>.broadcast();

  // 2. Expose the Stream
  Stream<RemoteMessage> get notificationStream => _messageStreamController.stream;

  Future<void> init() async {
    // Request permission (iOS mainly)
    NotificationSettings settings = await _messaging.requestPermission();

    print('Permission: ${settings.authorizationStatus}');

    // Get FCM token
    String? token;
    try {
      token = await _messaging.getToken();
      print("FCM Token: $token");
    } catch (e) {
      log("Error fetching FCM token: $e", level: LogLevel.warn);
    }

    if (token == null) {
      log("FCM Token is null. Skipping token registration (this is normal on simulator).", level: LogLevel.warn);
    } else {
      String? result = await saveToken(token);
      if (result == null) {
        log("Token save failed", level: LogLevel.error);
      }
    }

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('>> Got a message: ${message.notification?.title}');
      log('Got a message: ${message.notification?.body}');
      log('Got a message: ${message.data} <<');
      log('>> Foreground Message Received: ${message.notification?.title}');
      _messageStreamController.add(message); 
      log("Does the stream have listeners? ${_messageStreamController.hasListener}");
    
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('>> Notification Tapped: ${message.notification?.title}');
      _messageStreamController.add(message); 
    });
 

    // Token refresh
    _messaging.onTokenRefresh.listen((String newToken) {
      log("New token: $newToken");
    });
  }

   void dispose() {
    _messageStreamController.close();
  }

  Future<String?> saveToken(String token) async {
    try {
      String? deviceIdentifier = await _getDeviceIdentifier();

      final registerDeviceModel = RegisterDeviceModel(
          fcmToken: token,
          deviceName: deviceIdentifier,
          platform: _getPlatform());

      final res = await _networkService.post(
        ATEndpoints.fcmRegisterDevice,
        data: registerDeviceModel.toJson(),
      );

      log("Token FCM Saved >>>>");

      return res.data['message'];
    } catch (e) {
      log('Save token error: $e', level: LogLevel.error);
      return null;
    }
  }

  String _getPlatform() {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isMacOS) {
      return 'macos';
    } else if (Platform.isWindows) {
      return 'windows';
    } else if (Platform.isLinux) {
      return 'linux';
    } else if (Platform.isFuchsia) {
      return 'fuchsia';
    } else {
      return 'web';
    }
  }

  Future<String?> _getDeviceIdentifier() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.name;
    }
    return null;
  }

  void log(String message, {LogLevel level = LogLevel.debug}) {
    developer.log(message, name: "PushNotificationService", level: level.value);
  }
}
