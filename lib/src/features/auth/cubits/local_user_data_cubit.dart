import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalUserDataCubit extends Cubit<ATAppState<CachedUserData>> {
  LocalUserDataCubit({
    ATLocalStorageService? mockLocalStorage,
  }) : localStorage = mockLocalStorage ?? FlutterSecureStorageServiceImpl(),
        super(const InitialState<CachedUserData>());

  final ATLocalStorageService localStorage;

  CachedUserData? get currentUserData => switch (state) {
    SuccessState<CachedUserData>(:final CachedUserData? newData) => newData,
    FailureState<CachedUserData>(:final CachedUserData? oldData) => oldData,
    InitialState<CachedUserData>(:final CachedUserData? initialData) => initialData,
    LoadingState<CachedUserData>(:final CachedUserData? currentData) => currentData,
  };

  Future<void> initializeCachedData() async {
    emit(const LoadingState<CachedUserData>());
    try {
      final dynamic json =
          await localStorage.getObject(ATStrings.cachedUserData);

      emit(
        SuccessState<CachedUserData>(
          newData: json == null
              ? const CachedUserData()
              : CachedUserData.fromJson(json),
        ),
      );
    } catch (e) {
      emit(FailureState<CachedUserData>(e.toString()));
    }
  }

  Future<void> updateUserDataLocally(CachedUserData user) async {
    emit(const LoadingState<CachedUserData>());
    try {
      await localStorage.setObject(
        ATStrings.cachedUserData,
        user.toJson(),
      );
      emit(SuccessState<CachedUserData>(newData: user));
    } catch (e) {
      emit(FailureState<CachedUserData>(
        e.toString(),
        oldData: currentUserData,
      ));
    }
  }
}

class CachedUserData extends Equatable {
  const CachedUserData({
    this.userId,
    this.email,
    this.username,
    this.dob,
    this.name,
    this.pictureUrl,
    this.phoneNumber,
    this.followersCount,
    this.followingCount
  });

  factory CachedUserData.fromJson(Map<String, dynamic> json) =>
      CachedUserData(
        userId: json[ATStrings.userId],
        email: json[ATStrings.email],
        username: json[ATStrings.username],
        dob: json[ATStrings.dob],
        name: json[ATStrings.name],
        pictureUrl: json[ATStrings.profilePicture],
        phoneNumber: json[ATStrings.phoneNumber],
        followersCount: json[ATStrings.followerCount],
        followingCount: json[ATStrings.followingCount]

      );

  final String? userId, email, username, dob, name, pictureUrl, 
  phoneNumber, followingCount, followersCount ;

  CachedUserData copyWith({
    String? userId,
    String? email,
    String? username,
    String? dob,
    String? name,
    String? pictureUrl,
    String? followersCount,
    String? followingCount,
    String? phoneNumber
  }) => CachedUserData(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        username: username ?? this.username,
        dob: dob ?? this.dob,
        name: name ?? this.name,
        pictureUrl: pictureUrl ?? this.pictureUrl,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        followersCount: followersCount ?? this.followersCount,
        followingCount: followingCount ?? this.followingCount
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
      ATStrings.userId: userId,
      ATStrings.email: email,
      ATStrings.username: username,
      ATStrings.dob: dob,
      ATStrings.name: name,
      ATStrings.profilePicture: pictureUrl,
      ATStrings.phoneNumber: phoneNumber,
      ATStrings.followerCount: followersCount,
      ATStrings.followingCount: followingCount
    };

  @override
  List<Object?> get props => <Object?>[
    userId, email, username, dob, name, pictureUrl,
    phoneNumber, followersCount, followingCount];
}
