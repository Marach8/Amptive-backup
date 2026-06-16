import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'package:amptive/src/shared/sentinel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalUserDataCubit extends Cubit<ATAppState<ProfileData>> {
  LocalUserDataCubit({
    ATLocalStorageService? mockLocalStorage,
  })  : localStorage = mockLocalStorage ?? FlutterSecureStorageServiceImpl(),
        super(const InitialState<ProfileData>());

  final ATLocalStorageService localStorage;

  ProfileData? get currentUserData => switch (state) {
    SuccessState<ProfileData>(:final ProfileData? newData) => newData,
    FailureState<ProfileData>(:final ProfileData? oldData) => oldData,
    InitialState<ProfileData>(:final ProfileData? initialData) =>
      initialData,
    LoadingState<ProfileData>(:final ProfileData? currentData) =>
      currentData,
  };

  Future<void> initializeCachedData() async {
    emit(const LoadingState<ProfileData>());
    try {
      final dynamic json =
          await localStorage.getObject(ATStrings.cachedUserData);

      final ProfileData? userData = json == null ? null
        : ProfileData.fromLocalStorageJson(json);

      emit(SuccessState<ProfileData>(newData: userData));
    } catch (e) {
      emit(FailureState<ProfileData>(e.toString()));
    }
  }

  Future<void> updateUserDataLocally(ProfileData newData) async {
    try {
      emit(SuccessState<ProfileData>(newData: newData));
      localStorage.setObject(
        ATStrings.cachedUserData,
        newData.toLocalStorageJson(),
      );
    } catch (e) {
      emit(FailureState<ProfileData>(
        e.toString(),
        oldData: currentUserData,
      ));
    }
  }
}
