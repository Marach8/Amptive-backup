import 'dart:async';
import 'dart:io';

import 'package:amptive/src/config/utils/logging/app_logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/src/response.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
    final NotificationSettings settings = await _messaging.requestPermission();

    AppLogger.instance.info('Permission: ${settings.authorizationStatus}',
        tag: 'PushNotification');

    // Get FCM token
    final String? token = await _messaging.getToken();
    AppLogger.instance.info('FCM Token: $token', tag: 'PushNotification');

    final String? result = await saveToken(token!);

    if (result == null) {
      AppLogger.instance.error('Token save failed', tag: 'PushNotification');
      return;
    }

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.instance.info('Got a message: ${message.notification?.title}',
          tag: 'PushNotification');
      _messageStreamController.add(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLogger.instance.info('Notification Tapped: ${message.notification?.title}',
          tag: 'PushNotification');
      _messageStreamController.add(message);
    });


    // Token refresh
    _messaging.onTokenRefresh.listen((String newToken) {
      AppLogger.instance.info('New token: $newToken',
          tag: 'PushNotification');
    });
  }

   void dispose() {
    _messageStreamController.close();
  }

  Future<String?> saveToken(String token) async {
    try {
      final String? deviceIdentifier = await _getDeviceIdentifier();

      final RegisterDeviceModel registerDeviceModel = RegisterDeviceModel(
          fcmToken: token,
          deviceName: deviceIdentifier,
          platform: _getPlatform());

      final Response<dynamic> res = await _networkService.post(
        ATEndpoints.fcmRegisterDevice,
        data: registerDeviceModel.toJson(),
      );

      AppLogger.instance.info('Token FCM Saved', tag: 'PushNotification');

      return res.data['message'];
    } catch (e, st) {
      AppLogger.instance.error('Save token error',
          error: e, stackTrace: st, tag: 'PushNotification');
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
}
