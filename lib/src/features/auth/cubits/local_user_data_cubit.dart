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
    this.bio,
    this.xUrl,
    this.instagramUrl,
    this.linkedinUrl,
    this.websiteUrl,
    this.liveProgramData,
  });

  factory CachedUserData.fromLocalStorageJson(
    Map<String, dynamic> json,
  ) {
    Sentinel<LiveProgramData?>? liveProgramData;

    if (json.containsKey(ATStrings.liveProgramData)) {
      final dynamic value = json[ATStrings.liveProgramData];

      liveProgramData = Sentinel<LiveProgramData?>.of(
        value == null
            ? null
            : LiveProgramData.fromJson(
                Map<String, dynamic>.from(value),
              ),
      );
    } else {
      liveProgramData =
          const Sentinel<LiveProgramData?>.absent();
    }

    return CachedUserData(
      userId: json[ATStrings.userId] as String?,
      email: json[ATStrings.email] as String?,
      username: json[ATStrings.username] as String?,
      dob: json[ATStrings.dob] as String?,
      name: json[ATStrings.name] as String?,
      pictureUrl: json[ATStrings.profilePicture] as String?,
      phoneNumber: json[ATStrings.phoneNumber] as String?,
      followersCount: json[ATStrings.followerCount]?.toString(),
      followingCount: json[ATStrings.followingCount]?.toString(),
      hasTestedMic: json[ATStrings.hasTestedMic]?.toString(),
      bio: json[ATStrings.bio] as String?,
      xUrl: json[ATStrings.X] as String?,
      instagramUrl: json[ATStrings.INSTAGRAM] as String?,
      linkedinUrl: json[ATStrings.LINKEDIN] as String?,
      websiteUrl: json[ATStrings.WEBSITE] as String?,
      liveProgramData: liveProgramData,
    );
  }

  final String?
    userId,
    email,
    username,
    dob,
    name,
    pictureUrl,
    phoneNumber,
    followingCount,
    followersCount,
    hasTestedMic,
    bio,
    xUrl,
    instagramUrl,
    linkedinUrl,
    websiteUrl;

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
    String? bio,
    String? xUrl,
    String? instagramUrl,
    String? linkedinUrl,
    String? websiteUrl,
    Sentinel<LiveProgramData?>? liveProgramData,
  }) {
    return CachedUserData(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
      dob: dob ?? this.dob,
      name: name ?? this.name,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      followersCount:
          followersCount ?? this.followersCount,
      followingCount:
          followingCount ?? this.followingCount,
      hasTestedMic:
          hasTestedMic ?? this.hasTestedMic,
      bio: bio ?? this.bio,
      xUrl: xUrl ?? this.xUrl,
      instagramUrl:
          instagramUrl ?? this.instagramUrl,
      linkedinUrl:
          linkedinUrl ?? this.linkedinUrl,
      websiteUrl:
          websiteUrl ?? this.websiteUrl,
      liveProgramData:
          liveProgramData ?? this.liveProgramData,
    );
  }

  Map<String, dynamic> toLocalStorageJson() {
    final Map<String, dynamic> json =
        <String, dynamic>{
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
      ATStrings.bio: bio,
      ATStrings.X: xUrl,
      ATStrings.INSTAGRAM: instagramUrl,
      ATStrings.LINKEDIN: linkedinUrl,
      ATStrings.WEBSITE: websiteUrl,
    };

    if (liveProgramData != null &&
        liveProgramData!.hasValue) {
      json[ATStrings.liveProgramData] =
          liveProgramData!.value?.toJson();
    }

    return json;
  }

  Map<String, dynamic> toJson() =>
      toLocalStorageJson();

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
        hasTestedMic,
        bio,
        xUrl,
        instagramUrl,
        linkedinUrl,
        websiteUrl,
        liveProgramData?.value,
      ];
}
