import 'package:amptive/src/config/endpoints.dart';
import '../../config/config_export.dart';
import '../../config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import '../../config/services/local_storage_service/storage_service.dart';
import 'base_ws_service.dart';

class UserWsService extends BaseWsService {
  UserWsService()
      : super(
          logTag: 'UserWsService',
        );

  String? token;
  bool _isConnected = false;

  final ATLocalStorageService _localStorageService =
      FlutterSecureStorageServiceImpl();

  @override
  String buildConnectUrl() {
    return '${ATEndpoints.wsUsers}?token=$token';
  }

  @override
  void onMessage(Map<String, dynamic> msg) {
    log('Got message: $msg');
    // Route to domain-specific handlers here
  }

  @override
  void onConnected() {
    _isConnected = true;
    log('User Ws Connected', level: LogLevel.info);
  }

  @override
  void onDisconnected() {
    _isConnected = false;
    log('User Ws Disconnected', level: LogLevel.warn);
  }

  @override
  void onMaxRetriesExceeded() {
    log('Giving up reconnecting.', level: LogLevel.error);
    _isConnected = false;
  }

  @override
  Future<void> connect({Duration? connectTimeout}) async {
    token = await _localStorageService.get(ATStrings.accessToken);
    if (token == null || token!.isEmpty) {
      log("User Token not found or empty. Connection Skipped", level: LogLevel.error);
      return;
    }
    await super.connect(connectTimeout: connectTimeout);
  }

  Future<void> connectUser({Duration? connectTimeout}) async {
    if (!isConnected && !isReconnecting) {
      await connect(connectTimeout: connectTimeout);
    }
  }
}
