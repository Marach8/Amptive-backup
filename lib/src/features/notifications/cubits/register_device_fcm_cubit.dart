import 'dart:io';

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/notifications/data/repository/notif_repo.dart';
import 'package:amptive/src/features/notifications/data/repository/notif_repo_impl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterDeviceFCMCubit extends Cubit<ATAppState<bool>> {
  RegisterDeviceFCMCubit({NotificationsRepo? mocknotificationrepo})
      : notificationrepo = mocknotificationrepo ?? NotificationRepositoryImpl(),
        super(const InitialState<bool>());

  final NotificationsRepo notificationrepo;

  Future<void> registerDevice({required String userId}) async {
    emit(const LoadingState<bool>());
    
    try {
    final String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        emit(const FailureState<bool>('FCM Token is null'));
        return;
      }

      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
       String deviceName = "Unknown Device";
      String platform = "unknown";

      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = '${androidInfo.manufacturer} ${androidInfo.model}';
        platform = 'android';
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.name;
        platform = 'ios';
      }

      final ApiResponse<String> response = await notificationrepo.registerDevice(
        userId: userId,
        fcmToken: fcmToken,
        deviceName: deviceName,
        platform: platform,
      );

      response.when(
        successful: (Successful<String> data) {
          emit(const SuccessState<bool>(newData: true));
        },
        unSuccessful: (Unsuccessful<String> error) {
          emit(FailureState<bool>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<bool>('Unable to register device: $e'));
    }
  }
}
