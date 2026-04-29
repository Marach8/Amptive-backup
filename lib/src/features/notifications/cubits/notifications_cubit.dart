import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/notifications/data/models/get_notifications_response_model.dart';
import 'package:amptive/src/features/notifications/data/repository/notif_repo.dart';
import 'package:amptive/src/features/notifications/data/repository/notif_repo_impl.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
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


  Future<void> fetchNotifications({bool refresh = false}) async {
  final bool hasMore = currentNotifications?.hasMore ?? true;
  
  if (!refresh && (state is LoadingState<NotificationsResponseModel> || !hasMore)) {
    return;
  }
  
  final int pageToFetch = refresh ? 1 : (currentNotifications?.page ?? 0) + 1;
  
  emit(LoadingState<NotificationsResponseModel>(currentData: refresh ? null : currentNotifications));
  
  try {
    final ApiResponse<NotificationsResponseModel> response = await notificationsRepo.fetchUserNotifications(
      unreadOnly: true,
      page: pageToFetch,
      pageSize: 100,
    );
    
    response.when(
      successful: (Successful<NotificationsResponseModel> data) {
        final NotificationsResponseModel newData = data.data!;
        final NotificationsResponseModel? existingData = currentNotifications;
        
        if (refresh || existingData == null) {
          emit(SuccessState<NotificationsResponseModel>(newData: newData));
        } else {
          final NotificationsResponseModel mergedNotifications = NotificationsResponseModel(
            notifications: <Notifications>[...?existingData.notifications, ...?newData.notifications],
            unreadCount: newData.unreadCount,
            total: newData.total,
            page: newData.page,
            pageSize: newData.pageSize,
            totalPages: newData.totalPages,
            hasMore: newData.hasMore,
          );
          emit(SuccessState<NotificationsResponseModel>(newData: mergedNotifications));
        }
      }, 
      unSuccessful: (Unsuccessful<NotificationsResponseModel> error) {
        emit(FailureState<NotificationsResponseModel>(error.error.message, oldData: currentNotifications));
      }
    );
  } catch (e) {
    emit(FailureState<NotificationsResponseModel>('Unable to fetch notifications: $e', oldData: currentNotifications));
  }
}
}
