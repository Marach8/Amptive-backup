import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Request permission (iOS mainly)
    NotificationSettings settings = await _messaging.requestPermission();

    print('Permission: ${settings.authorizationStatus}');

    // Get FCM token
    String? token = await _messaging.getToken();
    print("FCM Token: $token");

    // TODO: send token to backend
    // await api.saveToken(token);

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('>> Got a message: ${message.notification?.title}');
      print('Got a message: ${message.notification?.body}');
      print('Got a message: ${message.data} <<');
    });

    // Token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      print("New token: $newToken");
    });
  }
}