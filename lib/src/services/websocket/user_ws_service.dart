import '../../config/endpoints.dart';
import 'base_ws_service.dart';

class UserWsService extends BaseWsService {
  UserWsService({required this.token})
      : super(
            url: '${ATEndpoints.wsBaseUrl}${ATEndpoints.wsUsers}?token=$token');
  final String token;

  @override
  void onMessage(Map<String, dynamic> msg) {
    // Modern Dart Pattern Matching
    print("Got Websocket message: $msg");
  }

  @override
  void onConnected() => print('🟢 WS Connected');

  @override
  void onDisconnected() => print('🔴 WS Disconnected');

  @override
  void dispose() {
    super.dispose();
  }
}
