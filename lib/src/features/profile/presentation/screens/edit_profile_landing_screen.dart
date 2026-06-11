import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/utils_export.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/cubits/upload_image_cubit.dart';
import 'package:amptive/src/features/profile/bloc/creator_or_biz_bloc.dart';
import 'package:amptive/src/features/profile/cubits/remote_user_data_cubit.dart';
import 'package:amptive/src/features/profile/presentation/widgets/profile_widgets_export.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(_) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<RemoteUserDataCubit>(
          create: (_) => RemoteUserDataCubit()),
        BlocProvider<UploadImageCubit>(
          create: (_) => UploadImageCubit())
      ],
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar: const ATAppBar(
            leadingWidth: 30,
            padding: EdgeInsets.only(left: 7),
            leading: ATRoundedBackBtn(),
            titleText: ATStrings.editProfile,
          ),
          body: Builder(
            builder: (BuildContext context) {
              final UserProfileData? userData =
                context.watch<LocalUserDataCubit>().currentUserData;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const EditProfileCoverImage(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 30),
                          const _MenuHeading(text: ATStrings.ABT_U),
                          _MenuItem(
                              title: ATStrings.name,
                              value: userData?.name ?? '---',
                              onTap: () async {
                                final String? newName = await context
                                    .pushNamed(ATRoutes.editNameScreen,
                                        extra: userData?.name ?? '');
                    
                                if (newName != null && context.mounted) {
                                  context.read<LocalUserDataCubit>()
                                    .updateUserDataLocally(
                                      (userData ?? const UserProfileData()).copyWith(
                                        name: newName
                                      )
                                    );
                                }
                              }),
                          _MenuItem(
                              title: ATStrings.userName,
                              value: userData?.username ?? '---',
                              onTap: () async {
                                final String? newUsername = await context
                                    .pushNamed(
                                      ATRoutes.editUsername,
                                      extra: userData?.username ?? '');
                    
                                if (newUsername != null && context.mounted) {
                                  context.read<LocalUserDataCubit>()
                                    .updateUserDataLocally(
                                      (userData ?? const UserProfileData()).copyWith(
                                        username: newUsername,
                                      )
                                    );
                                }
                              }),
                          _MenuItem(
                              title: ATStrings.bio,
                              value: userData?.bio ?? '---',
                              onTap: () async {
                                final String? newBio = await context.pushNamed(
                                  ATRoutes.editBio,
                                  extra: userData?.bio ?? '');
                    
                                if (newBio != null && context.mounted) {
                                  context.read<LocalUserDataCubit>()
                                    .updateUserDataLocally(
                                      (userData ?? const UserProfileData()).copyWith(
                                        bio: newBio,
                                      )
                                    );
                                }
                              }),
                          const SizedBox(height: 15),
                          const ATDivider(),
                          const SizedBox(height: 15),
                          const _MenuHeading(text: ATStrings.links),
                          _MenuItem(
                              title: ATStrings.INSTAGRAM,
                              isLink: true,
                              value: userData?.instagramUrl ??
                                  'www.instagram.com/alieubaba1',
                              onTap: () async {
                                final String? newInstagramUrl = await context
                                    .pushNamed(ATRoutes.editSocials,
                                        extra: <String?>[
                                      null,
                                      ATStrings.INSTAGRAM,
                                    ]);
                    
                                if (newInstagramUrl != null &&
                                    context.mounted) {
                                  // context
                                  //     .read<RemoteUserDataCubit>()
                                  //     .updateRemoteUserProfile(
                                  //         instagramUrl: newInstagramUrl);
                                }
                              }),
                          _MenuItem(
                              title: 'X',
                              isLink: true,
                              value: userData?.xUrl ?? '---',
                              onTap: () async {
                                final String? newXUrl = await context
                                    .pushNamed(ATRoutes.editSocials,
                                        extra: <String?>[
                                      null, //'www.x.com/alieubaba',
                    
                                      ATStrings.X,
                                    ]);
                    
                                if (newXUrl != null && context.mounted) {
                                  // context
                                  //     .read<RemoteUserDataCubit>()
                                  //     .updateRemoteUserProfile(xUrl: newXUrl);
                                }
                              }),
                          _MenuItem(
                              title: ATStrings.LINKEDIN,
                              isLink: true,
                              value: userData?.linkedinUrl ??
                                  'www.linkedIn.com/alieubaba',
                              onTap: () async {
                                final String? newLinkedInUrl = await context
                                    .pushNamed(ATRoutes.editSocials,
                                        extra: <String>[
                                      'www.linkedIn.com/alieubaba',
                                      ATStrings.LINKEDIN,
                                    ]);
                    
                                if (newLinkedInUrl != null &&
                                    context.mounted) {
                                  // context
                                  //     .read<RemoteUserDataCubit>()
                                  //     .updateRemoteUserProfile(
                                  //         linkedinUrl: newLinkedInUrl);
                                }
                              }),
                          _MenuItem(
                              title: ATStrings.WEBSITE,
                              isLink: true,
                              value:
                                  userData?.websiteUrl ?? 'www.palbucks.co',
                              onTap: () async {
                                final String? newWebsiteUrl = await context
                                    .pushNamed(ATRoutes.editSocials,
                                        extra: <String?>[
                                      null, //'www.palbucks.co',
                    
                                      ATStrings.WEBSITE
                                    ]);
                    
                                if (newWebsiteUrl != null &&
                                    context.mounted) {
                                  // context
                                  //     .read<RemoteUserDataCubit>()
                                  //     .updateRemoteUserProfile(
                                  //         websiteUrl: newWebsiteUrl);
                                }
                              }),
                          const SizedBox(height: 15),
                          const ATDivider(),
                          const SizedBox(height: 15),
                          const _MenuHeading(text: ATStrings.ACCT),
                          _MenuItem(
                              title: ATStrings.switchAccount,
                              value: context.read<AccountTypeBloc>().state
                                  ? ATStrings.creator
                                  : ATStrings.business,
                              onTap: () async {
                                context.pushNamed(ATRoutes.SELECT_ACCT_TYPE);
                    
                                return;
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      )
    );
  }
}

class _MenuHeading extends StatelessWidget {
  const _MenuHeading({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
      child: Text(
        text,
        style: context.textTheme.labelSmall
            ?.copyWith(color: ATColors.hexC2C2C2, fontSize: ATSizes.size13),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.title,
    required this.value,
    required this.onTap,
    this.isLink = false,
  });

  final String title, value;
  final bool isLink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Row(
        children: <Widget>[
          Text(title, style: context.textTheme.bodySmall),
          SizedBox(width: context.screenWidth * 0.2),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.textTheme.bodySmall?.copyWith(
                color: isLink ? ATColors.white.withValues(alpha: 0.4) : null,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }
}
