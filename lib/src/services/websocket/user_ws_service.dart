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

  Future<void> connectUser() async {
    log("called>>>>>>>>>>>>>");
    token = await _localStorageService.get(ATStrings.accessToken);
    if (token == null) {
      log("User Token not found. Connection Skipped", level: LogLevel.error);
      return;
    }
    await connect();
  }

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
  void onConnected() => log('🟢 Connected', level: LogLevel.info);

  @override
  void onDisconnected() => log('🔴 Disconnected', level: LogLevel.warn);

  @override
  void onMaxRetriesExceeded() {
    log('Giving up reconnecting.', level: LogLevel.error);
    // Notify a controller / Riverpod provider here
  }
}
