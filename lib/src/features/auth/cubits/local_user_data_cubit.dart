import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalUserDataCubit extends Cubit<ATAppState<CachedUserData>> {
  LocalUserDataCubit({required this.localStorage})
      : super(const InitialState<CachedUserData>());

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
  });

  factory CachedUserData.fromJson(Map<String, dynamic> json) =>
      CachedUserData(
        userId: json['id'],
        email: json['email'],
        username: json['username'],
        dob: json['dob'],
        name: json['name'],
      );

  final String? userId, email, username, dob, name;

  CachedUserData copyWith({
    String? userId,
    String? email,
    String? username,
    String? dob,
    String? name,
  }) => CachedUserData(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        username: username ?? this.username,
        dob: dob ?? this.dob,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': userId,
      'email': email,
      'username': username,
      'dob': dob,
      'name': name,
    };

  @override
  List<Object?> get props => <Object?>[userId, email, username, dob, name];
}
