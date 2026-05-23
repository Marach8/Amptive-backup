import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/notifications/data/models/get_notifications_response_model.dart';

abstract class NotificationsRepo {
  
  Future<ApiResponse<String>> registerDevice({
  required String userId,
  required String fcmToken,
  required String deviceName,
  required String platform,
});

Future <ApiResponse<NotificationsResponseModel>> fetchUserNotifications({
  required bool unreadOnly,
  required int page,
  required int pageSize,
});
}
