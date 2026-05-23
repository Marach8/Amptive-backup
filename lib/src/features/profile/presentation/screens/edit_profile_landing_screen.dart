import 'package:amptive/src/config/api_response_and_app_state.dart';

import 'package:amptive/src/config/routing/route_strings.dart';

import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';

import 'package:amptive/src/config/utils/utils_export.dart';

import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';

import 'package:amptive/src/features/auth/data/models/response/user_profile_response_model.dart';

import 'package:amptive/src/features/profile/cubits/remote_user_data_cubit.dart';

import 'package:amptive/src/features/profile/presentation/widgets/profile_widgets_export.dart';

import 'package:amptive/src/shared/custom_container_widget.dart';

import 'package:amptive/src/shared/annotated_region__widget.dart';

import 'package:amptive/src/shared/app_bar_widget.dart';

import 'package:amptive/src/shared/back_button.dart';

import 'package:amptive/src/shared/divider_widget.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteUserDataCubit>(
      create: (_) => RemoteUserDataCubit(),
      child: Builder(builder: (BuildContext context) {
        return BlocConsumer<RemoteUserDataCubit, ATAppState<UserData>>(
            listener: (BuildContext context, ATAppState<UserData> state) {
          if (state is FailureState<UserData>) {
            showAppNotification2(
                context: context,
                text: state.message,
                type: NotificationType.failure);
          }

          if (state is SuccessState<UserData>) {
            final CachedUserData? currentUser =
                context.read<LocalUserDataCubit>().currentUserData;

            if (currentUser != null && state.newData != null) {
              context.read<LocalUserDataCubit>().updateUserDataLocally(
                    currentUser.copyWith(
                      name: state.newData?.name,
                      username: state.newData?.username,
                      bio: state.newData?.bio,
                      xUrl: state.newData?.xUrl,
                      instagramUrl: state.newData?.instagramUrl,
                      linkedinUrl: state.newData?.linkedinUrl,
                      websiteUrl: state.newData?.websiteUrl,
                    ),
                  );
            }
          }
        }, builder: (BuildContext context, ATAppState<UserData> state) {
          return BlocBuilder<LocalUserDataCubit, ATAppState<CachedUserData>>(
              builder:
                  (BuildContext context, ATAppState<CachedUserData> userData) {
            final CachedUserData? userData =
                context.read<LocalUserDataCubit>().currentUserData;

            return ATAnnotatedRegion(
              child: Scaffold(
                appBar: const ATAppBar(
                  leadingWidth: 30,
                  padding: EdgeInsets.only(left: 7),
                  leading: ATRoundedBackBtn(),
                  titleText: ATStrings.EDIT_PROFILE,
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const EditProfileBgImage(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 30),
                            const _MenuHeading(text: ATStrings.ABT_U),
                            _MenuItem(
                                title: ATStrings.NAME,
                                value: userData?.name ?? 'Alieu Baba',
                                onTap: () async {
                                  final String? newName = await context
                                      .pushNamed(ATRoutes.EDIT_NAME,
                                          extra: userData?.name ?? '');

                                  if (newName != null && context.mounted) {
                                    context
                                        .read<RemoteUserDataCubit>()
                                        .updateProfile(name: newName);
                                  }
                                }),
                            _MenuItem(
                                title: ATStrings.userName,
                                value: userData?.username ?? 'AlieuBaba',
                                onTap: () async {
                                  final String? newUsername = await context
                                      .pushNamed(ATRoutes.EDIT_USERNAME,
                                          extra: userData?.username ??
                                              'AlieuBaba');

                                  if (newUsername != null && context.mounted) {
                                    context
                                        .read<RemoteUserDataCubit>()
                                        .updateProfile(username: newUsername);
                                  }
                                }),
                            _MenuItem(
                                title: ATStrings.BIO,
                                value: userData?.bio ??
                                    'Author of UNTAMED & LOVE IS IN THE AIR',
                                onTap: () async {
                                  final String? newBio = await context.pushNamed(
                                      ATRoutes.EDIT_BIO,
                                      extra: userData?.bio ??
                                          'Author of UNTAMED & LOVE IS IN THE AIR');

                                  if (newBio != null && context.mounted) {
                                    context
                                        .read<RemoteUserDataCubit>()
                                        .updateProfile(bio: newBio);
                                  }
                                }),
                            const SizedBox(height: 15),
                            const ATDivider(),
                            const SizedBox(height: 15),
                            const _MenuHeading(text: ATStrings.LINKS),
                            _MenuItem(
                                title: ATStrings.INSTAGRAM,
                                isLink: true,
                                value: userData?.instagramUrl ??
                                    'www.instagram.com/alieubaba1',
                                onTap: () async {
                                  final String? newInstagramUrl = await context
                                      .pushNamed(ATRoutes.EDIT_SOCIALS,
                                          extra: <String?>[
                                        null,

                                        //'www.instagram.com/alieubaba1',

                                        ATStrings.INSTAGRAM,
                                      ]);

                                  if (newInstagramUrl != null &&
                                      context.mounted) {
                                    context
                                        .read<RemoteUserDataCubit>()
                                        .updateProfile(
                                            instagramUrl: newInstagramUrl);
                                  }
                                }),
                            _MenuItem(
                                title: 'X',
                                isLink: true,
                                value: userData?.xUrl ?? 'www.x.com/alieubaba',
                                onTap: () async {
                                  final String? newXUrl = await context
                                      .pushNamed(ATRoutes.EDIT_SOCIALS,
                                          extra: <String?>[
                                        null, //'www.x.com/alieubaba',

                                        ATStrings.X,
                                      ]);

                                  if (newXUrl != null && context.mounted) {
                                    context
                                        .read<RemoteUserDataCubit>()
                                        .updateProfile(xUrl: newXUrl);
                                  }
                                }),
                            _MenuItem(
                                title: ATStrings.LINKEDIN,
                                isLink: true,
                                value: userData?.linkedinUrl ??
                                    'www.linkedIn.com/alieubaba',
                                onTap: () async {
                                  final String? newLinkedInUrl = await context
                                      .pushNamed(ATRoutes.EDIT_SOCIALS,
                                          extra: <String>[
                                        'www.linkedIn.com/alieubaba',
                                        ATStrings.LINKEDIN,
                                      ]);

                                  if (newLinkedInUrl != null &&
                                      context.mounted) {
                                    context
                                        .read<RemoteUserDataCubit>()
                                        .updateProfile(
                                            linkedinUrl: newLinkedInUrl);
                                  }
                                }),
                            _MenuItem(
                                title: ATStrings.WEBSITE,
                                isLink: true,
                                value:
                                    userData?.websiteUrl ?? 'www.palbucks.co',
                                onTap: () async {
                                  final String? newWebsiteUrl = await context
                                      .pushNamed(ATRoutes.EDIT_SOCIALS,
                                          extra: <String?>[
                                        null, //'www.palbucks.co',

                                        ATStrings.WEBSITE
                                      ]);

                                  if (newWebsiteUrl != null &&
                                      context.mounted) {
                                    context
                                        .read<RemoteUserDataCubit>()
                                        .updateProfile(
                                            websiteUrl: newWebsiteUrl);
                                  }
                                }),
                            const SizedBox(height: 15),
                            const ATDivider(),
                            const SizedBox(height: 15),
                            const _MenuHeading(text: ATStrings.ACCT),
                            _MenuItem(
                                title: ATStrings.SWITCH_ACCT,
                                value: 'Audience',
                                onTap: () async {
                                  context.pushNamed(ATRoutes.SELECT_ACCT_TYPE);

                                  return;
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
      }),
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

  final String title;

  final String value;

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
