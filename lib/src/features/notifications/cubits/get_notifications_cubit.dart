import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/notifications/data/models/get_notifications_response_model.dart';
import 'package:amptive/src/features/notifications/data/repository/notif_repo.dart';
import 'package:amptive/src/features/notifications/data/repository/notif_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetNotificationsCubit extends Cubit<ATAppState<NotificationsResponseModel>> {
  GetNotificationsCubit ({
    NotificationsRepo? mockNotificationsRepo,
  }): notificationsRepo = mockNotificationsRepo ?? NotificationRepositoryImpl(),  
  super(const InitialState<NotificationsResponseModel>());
  final NotificationsRepo notificationsRepo;

  NotificationsResponseModel? get currentNotifications => switch (state) {
    SuccessState<NotificationsResponseModel>(:final NotificationsResponseModel? newData) => newData,
    FailureState<NotificationsResponseModel>(:final NotificationsResponseModel? oldData) => oldData,
    InitialState<NotificationsResponseModel>(:final NotificationsResponseModel? initialData) => initialData,
    LoadingState<NotificationsResponseModel>(:final NotificationsResponseModel? currentData) => currentData,
  };


  Future <void> fetchNotifications() async {
    final bool hasMore = currentNotifications?.hasMore ?? true;
    if (state is LoadingState<NotificationsResponseModel> || !hasMore) {
      return;
     }
     
     
    emit( LoadingState<NotificationsResponseModel>(currentData: currentNotifications));
    try {
    
    final ApiResponse<NotificationsResponseModel> response = await notificationsRepo.fetchUserNotifications(
      unreadOnly: true,
      page: (currentNotifications?.page ?? 0) + 1,
      pageSize: 100,
    );
     response.when(
      successful: (Successful<NotificationsResponseModel> data) {
         emit(SuccessState<NotificationsResponseModel>(newData: data.data));
      }, 
      unSuccessful: ( Unsuccessful<NotificationsResponseModel> error) {
        emit(FailureState<NotificationsResponseModel>(error.error.message));
      }
     );
  
  } catch (e) {
    emit(FailureState<NotificationsResponseModel>('Unable to fetch notifications: $e'));
  }
}
}
