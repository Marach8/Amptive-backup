import 'package:amptive/src/config/services/ws_notif_service/ws_channel_service_impl.dart';

abstract class WSNotificationService{
  Future<bool> connect({required String wsUrl});

  Future<bool> reconnect();

  Future<void> disconnect();

  void sendMessage(Map<String, dynamic> data);

  Stream<WSConnectionStatus> get connectionStream;

  Stream<dynamic> get messageStream;

  Stream<int> get unreadCountStream;

  void clearUnread();

  Future<void> dispose();
}
