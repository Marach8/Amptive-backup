import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/notifications/data/models/mark_notif_as_read_response_model.dart';
import 'package:amptive/src/features/notifications/data/repository/notif_repo.dart';
import 'package:amptive/src/features/notifications/data/repository/notif_repo_impl.dart';
import 'package:bloc/bloc.dart';

class MarkNotifsAsReadCubit extends Cubit<ATAppState<String>> {
  MarkNotifsAsReadCubit ({
    NotificationsRepo? mockNotificationsRepo,
  }): notificationsRepo = mockNotificationsRepo ?? NotificationRepositoryImpl(),
  super(const InitialState<String>());

  final NotificationsRepo notificationsRepo;
Future<void> markAsRead(String notificationId) async {
  emit(const LoadingState<String>());

  try {
    final ApiResponse<MarkNotificationAsReadResponseModel> response = await notificationsRepo.markNotificationAsRead(notificationId: notificationId);
    
    response.when(
      successful: (Successful<MarkNotificationAsReadResponseModel> data) {
        emit(SuccessState<String>(newData: data.data?.message ?? ''));
      },
      unSuccessful: (Unsuccessful<MarkNotificationAsReadResponseModel> error) {
        emit(FailureState<String>(error.error.message));
      },
    );
  } catch (e) {
    emit(FailureState<String>('Unable to mark notification as read: $e'));
  }
}
}
