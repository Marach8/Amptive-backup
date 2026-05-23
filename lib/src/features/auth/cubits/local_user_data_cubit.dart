import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/shared/sentinel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalUserDataCubit extends Cubit<ATAppState<CachedUserData>> {
  LocalUserDataCubit({
    ATLocalStorageService? mockLocalStorage,
  })  : localStorage = mockLocalStorage ?? FlutterSecureStorageServiceImpl(),
        super(const InitialState<CachedUserData>());

  final ATLocalStorageService localStorage;

  CachedUserData? get currentUserData => switch (state) {
    SuccessState<CachedUserData>(:final CachedUserData? newData) => newData,
    FailureState<CachedUserData>(:final CachedUserData? oldData) => oldData,
    InitialState<CachedUserData>(:final CachedUserData? initialData) =>
      initialData,
    LoadingState<CachedUserData>(:final CachedUserData? currentData) =>
      currentData,
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
              : CachedUserData.fromLocalStorageJson(json),
        ),
      );
    } catch (e) {
      emit(FailureState<CachedUserData>(e.toString()));
    }
  }

  Future<void> updateUserDataLocally(CachedUserData user) async {
    try {
      await localStorage.setObject(
        ATStrings.cachedUserData,
        user.toLocalStorageJson(),
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

<<<<<<< HEAD
=======
class CachedUserData extends Equatable {
  const CachedUserData(
      {this.userId,
      this.email,
      this.username,
      this.dob,
      this.name,
      this.pictureUrl,
      this.phoneNumber,
      this.followersCount,
      this.followingCount,
      this.bio,
      this.xUrl,
      this.instagramUrl,
      this.linkedinUrl,
      this.websiteUrl,
      });
>>>>>>> e0f4545044486a1a3edbed3074aca09519237daf

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
    this.followingCount,
    this.hasTestedMic,
    this.liveProgramData,
  });

  factory CachedUserData.fromLocalStorageJson(
    Map<String, dynamic> json,
  ) {
    Sentinel<LiveProgramData>? liveProgramData;

    if (json.containsKey(ATStrings.liveProgramData)) {
      final dynamic value = json[ATStrings.liveProgramData];

      liveProgramData = Sentinel<LiveProgramData>.of(
        value == null ? null : LiveProgramData.fromJson(
          Map<String, dynamic>.from(value),
        ),
      );
    } else {
      liveProgramData = const Sentinel<LiveProgramData>.absent();
    }

    return CachedUserData(
      userId: json[ATStrings.userId],
      email: json[ATStrings.email],
      username: json[ATStrings.username],
      dob: json[ATStrings.dob],
      name: json[ATStrings.name],
      pictureUrl: json[ATStrings.profilePicture],
      phoneNumber: json[ATStrings.phoneNumber],
      followersCount: json[ATStrings.followerCount],
      followingCount: json[ATStrings.followingCount],
<<<<<<< HEAD
      hasTestedMic: json[ATStrings.hasTestedMic],
      liveProgramData: liveProgramData,
    );
  }
=======
      bio: json[ATStrings.bio],
      xUrl: json[ATStrings.X],
      instagramUrl: json[ATStrings.INSTAGRAM],
      linkedinUrl: json[ATStrings.LINKEDIN],
      websiteUrl: json[ATStrings.WEBSITE],

      );
>>>>>>> e0f4545044486a1a3edbed3074aca09519237daf

  final String? userId,
      email,
      username,
      dob,
      name,
      pictureUrl,
      phoneNumber,
      followingCount,
      followersCount,
<<<<<<< HEAD
      hasTestedMic;

  final Sentinel<LiveProgramData?>? liveProgramData;

  CachedUserData copyWith({
    String? userId,
    String? email,
    String? username,
    String? dob,
    String? name,
    String? pictureUrl,
    String? followersCount,
    String? followingCount,
    String? phoneNumber,
    String? hasTestedMic,
    Sentinel<LiveProgramData>? liveProgramData,
  }) {
    return CachedUserData(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
      dob: dob ?? this.dob,
      name: name ?? this.name,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      hasTestedMic: hasTestedMic ?? this.hasTestedMic,
      liveProgramData:
          liveProgramData ?? this.liveProgramData,
    );
  }

  Map<String, dynamic> toLocalStorageJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      ATStrings.userId: userId,
      ATStrings.email: email,
      ATStrings.username: username,
      ATStrings.dob: dob,
      ATStrings.name: name,
      ATStrings.profilePicture: pictureUrl,
      ATStrings.phoneNumber: phoneNumber,
      ATStrings.followerCount: followersCount,
      ATStrings.followingCount: followingCount,
      ATStrings.hasTestedMic: hasTestedMic,
    };

    if (liveProgramData != null &&
        liveProgramData!.hasValue) {
      json[ATStrings.liveProgramData] =
          liveProgramData!.value?.toJson();
    }

    return json;
  }
=======
      bio,
      xUrl,
      instagramUrl,
      linkedinUrl,
      websiteUrl;

  CachedUserData copyWith(
          {String? userId,
          String? email,
          String? username,
          String? dob,
          String? name,
          String? pictureUrl,
          String? followersCount,
          String? followingCount,
          String? bio,
          String? xUrl,
          String? instagramUrl,
          String? linkedinUrl,
          String? websiteUrl,

          String? phoneNumber}) =>
      CachedUserData(
          userId: userId ?? this.userId,
          email: email ?? this.email,
          username: username ?? this.username,
          dob: dob ?? this.dob,
          name: name ?? this.name,
          pictureUrl: pictureUrl ?? this.pictureUrl,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          followersCount: followersCount ?? this.followersCount,
          followingCount: followingCount ?? this.followingCount,
          bio: bio ?? this.bio,
          xUrl: xUrl ?? this.xUrl,
          instagramUrl: instagramUrl ?? this.instagramUrl,
          linkedinUrl: linkedinUrl ?? this.linkedinUrl,
          websiteUrl: websiteUrl ?? this.websiteUrl,

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
        ATStrings.followingCount: followingCount,
        ATStrings.bio: bio,
        ATStrings.X: xUrl,
        ATStrings.INSTAGRAM: instagramUrl,
        ATStrings.LINKEDIN: linkedinUrl,
        ATStrings.WEBSITE: websiteUrl,

      };
>>>>>>> e0f4545044486a1a3edbed3074aca09519237daf

  @override
  List<Object?> get props => <Object?>[
        userId,
        email,
        username,
        dob,
        name,
        pictureUrl,
        phoneNumber,
        followersCount,
        followingCount,
<<<<<<< HEAD
        hasTestedMic,
        liveProgramData?.value,
=======
        bio,
>>>>>>> e0f4545044486a1a3edbed3074aca09519237daf
      ];
}
