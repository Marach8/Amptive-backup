import 'dart:developer';

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/notifications/data/models/get_notifications_response_model.dart';
import 'package:amptive/src/features/notifications/data/repository/notif_repo.dart';
import 'package:dio/dio.dart';

class NotificationRepositoryImpl implements NotificationsRepo {
  NotificationRepositoryImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

    final NetworkService networkService;
      @override
Future<ApiResponse<String>> registerDevice({
  required String userId,
  required String fcmToken,
  required String deviceName,
  required String platform,
}) async {
  try {
    final Response<dynamic> response = await networkService.post(
      ATEndpoints.registerDevice,
      data: <String, String>{
        'user_id': userId,
        'fcm_token': fcmToken,
        'device_name': deviceName,
        'platform': platform,
      },
    );
    return Successful<String>(data: response.data ['message']);
  } catch (e) {
    log('Register device error: $e');
    return Unsuccessful<String>(error: ATException.resolveException(e));
  }

}

@override
Future <ApiResponse<NotificationsResponseModel>> fetchUserNotifications({
  required bool unreadOnly,
  required int page,
  required int pageSize,
}) async {
  try {
    final Response<dynamic> response = await networkService.get(
      ATEndpoints.getNotifications,
      queryParameters: <String, dynamic>{
        'unread_only': unreadOnly,
        'page': page,
        'page_size': pageSize,
      },
    );
    return Successful<NotificationsResponseModel>(
      data: NotificationsResponseModel.fromJson(response.data ),
    );
  } catch (e) {
    log('Fetch notifications error: $e');
    return Unsuccessful<NotificationsResponseModel>(error: ATException.resolveException(e));
  }

}
}
