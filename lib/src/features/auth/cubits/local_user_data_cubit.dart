import 'dart:developer';

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
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

      emit(
        SuccessState<UserProfileData>(
          newData: json == null
              ? const UserProfileData()
              : UserProfileData.fromLocalStorageJson(json),
        ),
      );
    } catch (e, s) {
      log('This is the parsing error $e: $s');
      emit(FailureState<UserProfileData>(e.toString()));
    }
  }

  Future<void> updateUserDataLocally(UserProfileData user) async {
    try {
      await localStorage.setObject(
        ATStrings.cachedUserData,
        user.toLocalStorageJson(),
      );

      emit(SuccessState<UserProfileData>(newData: user));
    } catch (e) {
      emit(FailureState<UserProfileData>(
        e.toString(),
        oldData: currentUserData,
      ));
    }
  }
}

class UserProfileData extends Equatable {
  const UserProfileData({
    this.userId,
    this.email,
    this.username,
    this.dob,
    this.name,
    this.pictureUrl,
    this.phoneNumber,
    this.followersCount,
    this.followingCount,
    this.subscribersCount,
    this.hasTestedMic,
    this.bio,
    this.xUrl,
    this.instagramUrl,
    this.linkedinUrl,
    this.websiteUrl,
    this.liveProgramData,
    this.coverPhoto,
    this.country,
    this.hasHostedEvents,
    this.hasHostedShows,
  });

  factory UserProfileData.fromLocalStorageJson(
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

    return UserProfileData(
      userId: json[ATStrings.userId] as String?,
      email: json[ATStrings.email] as String?,
      username: json[ATStrings.username] as String?,
      dob: json[ATStrings.dob] as String?,
      name: json[ATStrings.name] as String?,
      pictureUrl: json[ATStrings.profilePicture] as String?,
      phoneNumber: json[ATStrings.phoneNumber] as String?,
      followersCount: json[ATStrings.followerCount],
      followingCount: json[ATStrings.followingCount],
      hasTestedMic: json[ATStrings.hasTestedMic],
      bio: json[ATStrings.bio] as String?,
      xUrl: json[ATStrings.X] as String?,
      instagramUrl: json[ATStrings.INSTAGRAM] as String?,
      linkedinUrl: json[ATStrings.LINKEDIN] as String?,
      websiteUrl: json[ATStrings.WEBSITE] as String?,
      coverPhoto: json[ATStrings.coverPhoto] as String?,
      country: json[ATStrings.country] as String?,
      hasHostedEvents: json[ATStrings.hasHostedEvents],
      hasHostedShows: json[ATStrings.hasHostedShows],
      subscribersCount: json[ATStrings.subscribersCount],
      liveProgramData: liveProgramData,
    );
  }


  factory UserProfileData.fromRemoteJson(Map<String, dynamic> json) {
    return UserProfileData(
      userId: json['id'] ,
      email: json['email'] ,
      username: json['username'] ,
      dob: json['dob'] ,
      name: json['name'] ,
      pictureUrl: json['profile_picture'] ,
      followersCount: json['followers_count'],
      followingCount: json['following_count'],
      subscribersCount: json['subscribers_count'],
      bio: json['bio'],
      xUrl: json['x_url'],
      instagramUrl: json['instagram_url'],
      linkedinUrl: json['linkedin_url'],
      websiteUrl: json['website_url'],
      phoneNumber: json['phone_number'],
      country: json['country'],
      coverPhoto: json['cover_photo'],
      hasHostedEvents: json['has_hosted_events'],
      hasHostedShows: json['has_hosted_shows'],
    );
  }

  final String?
    userId,
    email,
    username,
    dob, coverPhoto,
    name, country,
    pictureUrl,
    phoneNumber,
    bio,
    xUrl,
    instagramUrl,
    linkedinUrl,
    websiteUrl;

  final int? followingCount, followersCount, subscribersCount;
  final bool? hasHostedShows, hasHostedEvents, hasTestedMic;
  final Sentinel<LiveProgramData?>? liveProgramData;

  UserProfileData copyWith({
    String? userId,
    String? email,
    String? username,
    String? dob,
    String? name,
    String? pictureUrl,
    int? followersCount,
    int? followingCount,
    int? subscribersCount,
    String? phoneNumber,
    bool? hasTestedMic,
    String? bio,
    String? xUrl,
    String? instagramUrl,
    String? linkedinUrl,
    String? websiteUrl,
    String? coverPhoto,
    String? country,
    bool? hasHostedEvents,
    bool? hasHostedShows,
    Sentinel<LiveProgramData?>? liveProgramData,
  }) {
    return UserProfileData(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
      dob: dob ?? this.dob,
      name: name ?? this.name,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      subscribersCount: subscribersCount ?? this.subscribersCount,
      hasTestedMic: hasTestedMic ?? this.hasTestedMic,
      bio: bio ?? this.bio,
      xUrl: xUrl ?? this.xUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      liveProgramData: liveProgramData ?? this.liveProgramData,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      country: country ?? this.country,
      hasHostedEvents: hasHostedEvents ?? this.hasHostedEvents,
      hasHostedShows: hasHostedShows ?? this.hasHostedShows,
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
      ATStrings.subscribersCount: subscribersCount,
      ATStrings.hasTestedMic: hasTestedMic,
      ATStrings.bio: bio,
      ATStrings.X: xUrl,
      ATStrings.INSTAGRAM: instagramUrl,
      ATStrings.LINKEDIN: linkedinUrl,
      ATStrings.WEBSITE: websiteUrl,
      ATStrings.coverPhoto: coverPhoto,
      ATStrings.country: country,
      ATStrings.hasHostedEvents: hasHostedEvents,
      ATStrings.hasHostedShows: hasHostedShows,
    };

    if (liveProgramData != null &&
        liveProgramData!.hasValue) {
      json[ATStrings.liveProgramData] =
          liveProgramData!.value?.toJson();
    }

    return json;
  }

  Map<String, dynamic> toRemoteJson(){
    final Map<String, dynamic> body = <String, dynamic>{};
  
    if (pictureUrl != null) body["profile_picture"] = pictureUrl;
    if (name != null) body["name"] = name;
    if (username != null) body["username"] = username;
    if (bio != null) body["bio"] = bio;
    if (country != null) body["country"] = country;
    if (coverPhoto != null) body["cover_photo"] = coverPhoto;
    if (xUrl != null) body["x_url"] = xUrl;
    if (instagramUrl != null) body["instagram_url"] = instagramUrl;
    if (linkedinUrl != null) body["linkedin_url"] = linkedinUrl;
    if (websiteUrl != null) body["website_url"] = websiteUrl;

    return body;
  }

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
        subscribersCount,
        hasTestedMic,
        bio,
        xUrl,
        instagramUrl,
        linkedinUrl,
        websiteUrl,
        liveProgramData?.value,
        coverPhoto,
        country,
        hasHostedEvents,
        hasHostedShows,
      ];
}
