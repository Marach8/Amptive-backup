import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'package:amptive/src/shared/sentinel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalUserDataCubit extends Cubit<ATAppState<UserProfileData>> {
  LocalUserDataCubit({
    ATLocalStorageService? mockLocalStorage,
  })  : localStorage = mockLocalStorage ?? FlutterSecureStorageServiceImpl(),
        super(const InitialState<UserProfileData>());

  final ATLocalStorageService localStorage;

  UserProfileData? get currentUserData => switch (state) {
    SuccessState<UserProfileData>(:final UserProfileData? newData) => newData,
    FailureState<UserProfileData>(:final UserProfileData? oldData) => oldData,
    InitialState<UserProfileData>(:final UserProfileData? initialData) =>
      initialData,
    LoadingState<UserProfileData>(:final UserProfileData? currentData) =>
      currentData,
  };

  Future<void> initializeCachedData() async {
    emit(const LoadingState<UserProfileData>());
    try {
      final dynamic json =
          await localStorage.getObject(ATStrings.cachedUserData);

      final UserProfileData? userData = json == null ? null
        : UserProfileData.fromLocalStorageJson(json);

      emit(SuccessState<UserProfileData>(newData: userData));
    } catch (e) {
      emit(FailureState<UserProfileData>(e.toString()));
    }
  }

  Future<void> updateUserDataLocally(UserProfileData newData) async {
    try {
      emit(SuccessState<UserProfileData>(newData: newData));
      localStorage.setObject(
        ATStrings.cachedUserData,
        newData.toLocalStorageJson(),
      );
    } catch (e) {
      emit(FailureState<UserProfileData>(
        e.toString(),
        oldData: currentUserData,
      ));
    }
  }
}
