import 'dart:io';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/helpers/extensions/string_extensions.dart';
import 'package:amptive/src/views/screens/authentication_screens/add_phone.dart';
import 'package:amptive/src/views/screens/authentication_screens/dob_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/email_auth_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/name_auth_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/otp_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/password_auth_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/post_registration.dart';
import 'package:amptive/src/views/screens/authentication_screens/sign_in_or_sign_up_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/username_auth_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/home_sub_view/go_live_views/event/even_scheduled_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/home_sub_view/go_live_views/show/create_show_form_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/dashboard_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/home_sub_view/go_live_views/main_go_live_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/community_task_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/creator_profile_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/crop_bg_image_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/edit_profile_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/profile_menu/accounts/account_info.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/profile_menu/accounts/accounts_home.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/profile_menu/accounts/select_country.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/profile_menu/calender/day_view.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/profile_menu/language.dart' show ATSelectLanguageScreen;
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/profile_menu/privacy/blocked_accts.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/profile_menu/privacy/muted_accts.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/profile_menu/privacy/privacy_home.dart' show AmptivePrivacyScreen;
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/profile_menu/profile_menu_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/profile_pic_display_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/subscribers_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/home_sub_view/scheduled_screen.dart';
import 'package:amptive/src/views/screens/post_authentication_screens/crop_image_screen.dart';
import 'package:amptive/src/views/screens/post_authentication_screens/pre_homepage.dart';
import 'package:amptive/src/views/screens/post_authentication_screens/preference_screen.dart';
import 'package:amptive/src/views/screens/onboarding_screens/onboarding_page_view_screen.dart';
import 'package:amptive/src/views/screens/onboarding_screens/welcome_screen.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/widgets_in_go_live/shows/show_type_visibility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'views/screens/main_application_screens/sub_views/discover/community_home_screen.dart';
import 'views/screens/main_application_screens/sub_views/discover/hashtag_full_screen.dart';
import 'views/screens/main_application_screens/sub_views/discover/society_screen.dart';
import 'views/screens/main_application_screens/sub_views/discover/trending_hashtags_screen.dart';
import 'views/screens/main_application_screens/sub_views/discover/trending_society_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/event_detailed_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/following_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/go_live_views/event/choose_event_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/go_live_views/show/choose_or_create_show_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/go_live_views/show/show_creation_success_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/followers_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/profile/presentation/views/user_profile_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/show_detailed_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/subscribed_screen.dart';

// The route configuration.
final GoRouter amptiveAppRouter = GoRouter(
  initialLocation: ATRoutes.index,
  //initialLocation: "/add-profile-pic",
  routes: <RouteBase>[
    GoRoute(
        path: ATRoutes.index,
        builder: (_, __) => const AmptiveDashboardScreen()),
    GoRoute(
      name: ATRoutes.welcome,
      path: "/welcome-route",
      builder: (_, __) => const AmptiveWelcomeScreen(),
    ),
    GoRoute(
      name: ATRoutes.onboarding,
      path: "/onboarding-route",
      builder: (_, __) => const AmptiveOnboardingScreen(),
    ),

    //AUTHENTICATION SCREENS
    GoRoute(
      name: ATRoutes.authScreen,
      path: "/auth-route",
      builder: (_, GoRouterState state) => AmptiveAuthScreen(
        userSignUp: state.extra as bool,
      ),
    ),
    GoRoute(
      name: ATRoutes.EMAIL_SCREEN,
      path: ATRoutes.EMAIL_SCREEN.addSlash,
      builder: (_, state) => ATEmailAuthScreen(title: state.extra as String?)
    ),
    GoRoute(
      name: ATRoutes.OTP_SCREEN,
      path: ATRoutes.OTP_SCREEN.addSlash,
      builder: (_, state) {
        final params = state.extra as List<String?>;
        final emailOrPhone = params.first;
        final title = params.last;
        return ATOTPScreen(emailOrPhone: emailOrPhone ?? '', title: title ?? '');
      }
    ),
    GoRoute(
      name: ATRoutes.ADD_FONE_NO_SCREEN,
      path: ATRoutes.ADD_FONE_NO_SCREEN.addSlash,
      builder: (_, state) => AddPhoneScreen(title: state.extra as String?),
    ),
    GoRoute(
        name: ATRoutes.addProfilePic,
        path: "/add-profile-pic",
        builder: (_, __) => const PostRegistrationScreen(),
        routes: <RouteBase>[
          GoRoute(
              name: ATRoutes.cropImage,
              path: "crop-image",
              builder: (_, GoRouterState state) {
                File imageFile = state.extra as File;
                return CropPage(
                  title: "Cropper",
                  imageFile: imageFile,
                );
              }),
        ]),
    GoRoute(
      name: ATRoutes.passwordAuth,
      path: "/password",
      builder: (_, __) => const PasswordAuthScreen(),
    ),
    GoRoute(
      name: ATRoutes.dobAuth,
      path: "/dob",
      builder: (_, __) => const DateOfBirthScreen(),
    ),
    GoRoute(
      name: ATRoutes.addUsername,
      path: "/username-add",
      builder: (_, __) => const UserNameAuthScreen(),
    ),
    GoRoute(
      name: ATRoutes.addName,
      path: "/name-add",
      builder: (_, __) => const NameAuthScreen(),
    ),
    GoRoute(
      name: ATRoutes.preference,
      path: "/preference-route",
      builder: (_, __) => const AmptivePreferenceScreen(),
    ),

    GoRoute(
      name: ATRoutes.preHomepage,
      path: "/pre-homepage",
      builder: (_, __) => const PreHomePage(),
    ),

    //MAIN APPLICATION SCREENS
    GoRoute(
        name: ATRoutes.homeScreen,
        path: "/home-screen",
        builder: (_, __) => const AmptiveDashboardScreen(),
        routes: [
          GoRoute(
              name: ATRoutes.showDetailedScreen,
              path: ATRoutes.showDetailedScreen,
              pageBuilder: (context, state) => CustomTransitionPage(
                    child: const ATShowDetailedScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var tween =
                          Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                              .animate(
                        CurvedAnimation(
                            parent: animation, curve: Curves.easeIn),
                      );

                      return SlideTransition(
                        position: tween,
                        child: child,
                      );
                    },
                    reverseTransitionDuration:
                        const Duration(milliseconds: 700),
                    transitionDuration: const Duration(milliseconds: 700),
                  )),
          GoRoute(
              name: ATRoutes.EVENT_DETAILED_SCREEN,
              path: ATRoutes.EVENT_DETAILED_SCREEN,
              pageBuilder: (context, state) => CustomTransitionPage(
                    child: const AmptiveEventDetailedScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var tween =
                          Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                              .animate(
                        CurvedAnimation(
                            parent: animation, curve: Curves.easeIn),
                      );

                      return SlideTransition(
                        position: tween,
                        child: child,
                      );
                    },
                    reverseTransitionDuration:
                        const Duration(milliseconds: 700),
                    transitionDuration: const Duration(milliseconds: 700),
                  )),
          GoRoute(
            name: ATRoutes.CHOOSE_OR_CREATE_SHOW_SCREEN,
            path: ATRoutes.CHOOSE_OR_CREATE_SHOW_SCREEN,
            builder: (_, __) => const AmptiveChooseOrCreateShowScreen(),
          ),
          GoRoute(
            name: ATRoutes.CHOOSE_OR_CREATE_EVENT_SCREEN,
            path: ATRoutes.CHOOSE_OR_CREATE_EVENT_SCREEN,
            builder: (_, __) => const AmptiveChooseOrCreateEventScreen(),
          ),
          GoRoute(
              name: ATRoutes.CREATE_SHOW_FORM,
              path: ATRoutes.CREATE_SHOW_FORM,
              builder: (_, __) {
                return const CreateShowScreen(showType: ShowType.show);
              }),
          GoRoute(
              name: ATRoutes.CREATE_EVENT_FORM,
              path: ATRoutes.CREATE_EVENT_FORM,
              builder: (_, GoRouterState state) {
                return const CreateShowScreen(
                  showType: ShowType.event,
                );
              }),
          GoRoute(
              name: ATRoutes.CREATE_EPISODE_FORM,
              path: ATRoutes.CREATE_EPISODE_FORM,
              builder: (_, __) {
                return const CreateShowScreen(showType: ShowType.episode);
              }),
          GoRoute(
            name: ATRoutes.CREATE_SHOW_SUCCESS,
            path: ATRoutes.CREATE_SHOW_SUCCESS,
            builder: (_, GoRouterState state) {
              String imageFilePath = state.extra as String;
              return ATCreateShowSuccessScreen(
                imageFilePath: imageFilePath,
              );
            },
          ),

          GoRoute(
            name: ATRoutes.CREATOR_PROFILE_SCREEN,
            path: ATRoutes.CREATOR_PROFILE_SCREEN,
            builder: (_, __) => const AmptiveCreatorProfileScreen(),
          ),

          GoRoute(
            name: ATRoutes.EDIT_PROFILE,
            path: ATRoutes.EDIT_PROFILE.addSlash,
            builder: (_, __) => const EditProfileScreen(),
            routes: [
              GoRoute(
                name: ATRoutes.PROFILE_BG_CROP,
                path: ATRoutes.PROFILE_BG_CROP,
                builder: (_, state) => CropProfileBgImageScreen(file: state.extra as File)
              ),
            ]
          ),

          GoRoute(
            name: ATRoutes.PROFILE_MENU_SCREEN,
            path: ATRoutes.PROFILE_MENU_SCREEN,
            builder: (_, __) => const AmptiveProfileMenuScreen(),
            routes: [
              GoRoute(
                name: ATRoutes.CALENDER_SCREEN,
                path: ATRoutes.CALENDER_SCREEN,
                builder: (_, __) => const ATCalenderScreen(),
              ),

              GoRoute(
                name: ATRoutes.LANGUAGE_SCREEN,
                path: ATRoutes.LANGUAGE_SCREEN,
                builder: (_, __) => const ATSelectLanguageScreen(),
              ),

              GoRoute(
                name: ATRoutes.PRIVACY_SCREEN,
                path: ATRoutes.PRIVACY_SCREEN,
                builder: (_, __) => const AmptivePrivacyScreen(),
                routes: [
                  GoRoute(
                    name: ATRoutes.BLOCKED_ACCTS_SCREEN,
                    path: ATRoutes.BLOCKED_ACCTS_SCREEN,
                    builder: (_, __) => const AmptiveBlockedAcctsScreen(),
                  ),

                  GoRoute(
                    name: ATRoutes.MUTED_ACCTS_SCREEN,
                    path: ATRoutes.MUTED_ACCTS_SCREEN,
                    builder: (_, __) => const AmptiveMutedAcctsScreen(),
                  ),
                ]
              ),
            ]
          ),

          GoRoute(
            name: ATRoutes.ACCT_SCREEN,
            path: ATRoutes.ACCT_SCREEN,
            builder: (_, __) => const ATAccountScreen(),
            routes: [
              GoRoute(
                name: ATRoutes.ACCT_INFO_SCREEN,
                path: ATRoutes.ACCT_INFO_SCREEN,
                builder: (_, state){
                  final params = state.extra as List<String?>?;
                  final email = params?.first;
                  final phone = params?.elementAtOrNull(1);
                  final country = params?.last;
                  return ATAccountInfoScreen(
                    country: country,
                    email: email,
                    phone: phone,
                  );
                },
              ),

              GoRoute(
                name: ATRoutes.SELECT_COUNTRY_SCREEN,
                path: ATRoutes.SELECT_COUNTRY_SCREEN,
                builder: (_, state){
                  final params = state.extra as List;
                  final countries = params.last as List<String>;
                  final selectedCountry = params.first as String;

                  return ATSelectCountryScreen(
                    countries: countries,
                    selectedCountry: selectedCountry,
                  );
                }
              ),
            ]
          ),

          GoRoute(
            name: ATRoutes.PROFILE_FOLLOWING_SCREEN,
            path: ATRoutes.PROFILE_FOLLOWING_SCREEN,
            builder: (_, __) => const ATProfileFollowersScreen(),
          ),

          GoRoute(
            name: ATRoutes.COMMUNITY_TASK_SCREEN,
            path: ATRoutes.COMMUNITY_TASK_SCREEN,
            builder: (_, __) => const AmptiveCommunityTaskScreen(),
          ),

          GoRoute(
            name: ATRoutes.PROFILE_PIC_SCREEN,
            path: ATRoutes.PROFILE_PIC_SCREEN,
            builder: (_, state){
              final imgPath = state.extra as String;
              return AmptiveViewProfilePicScreen(imgPath: imgPath);
            }
          ),

          GoRoute(
            name: ATRoutes.PROFILE_SUBSCRIBERS_SCREEN,
            path: ATRoutes.PROFILE_SUBSCRIBERS_SCREEN,
            builder: (_, __) => const AmptiveProfileSubScribersScreen(),
          ),

          GoRoute(
            name: ATRoutes.USER_PROFILE_SCREEN,
            path: ATRoutes.USER_PROFILE_SCREEN,
            builder: (_, __) => const ATUserProfileScreen(),
          ),

          GoRoute(
            name: ATRoutes.GO_LIVE_SCREEN,
            path: ATRoutes.GO_LIVE_SCREEN,
            builder: (_, __) => const AmptiveGoLiveScreen(),
          ),
          GoRoute(
            name: ATRoutes.SCHEDULED_EVENTS_OR_SHOWS_SCREEN,
            path: ATRoutes.SCHEDULED_EVENTS_OR_SHOWS_SCREEN,
            builder: (_, __) => const AmptiveScheduledEventOrShowViewWidget(),
          ),
          GoRoute(
            name: ATRoutes.EVENT_SCHEDULED_SCREEN,
            path: ATRoutes.EVENT_SCHEDULED_SCREEN,
            builder: (_, GoRouterState state) {
              String imageFilePath = state.extra as String;
              return AmptiveShowScheduledScreen(
                showType: ShowType.event,
                imageFilePath: imageFilePath,
              );
            },
          ),
          GoRoute(
            name: ATRoutes.EPISODE_SCHEDULED_SCREEN,
            path: ATRoutes.EPISODE_SCHEDULED_SCREEN,
            builder: (_, GoRouterState state) {
              String imageFilePath = state.extra as String;
              return AmptiveShowScheduledScreen(
                showType: ShowType.episode,
                imageFilePath: imageFilePath,
              );
            },
          ),
          GoRoute(
            name: ATRoutes.SUBSCRIBED_EVENTS_OR_SHOWS_SCREEN,
            path: ATRoutes.SUBSCRIBED_EVENTS_OR_SHOWS_SCREEN,
            builder: (_, __) => const AmptiveSubscribedEventOrShowViewWidget(),
          ),
          GoRoute(
            name: ATRoutes.FOLLOWING_EVENTS_OR_SHOWS_SCREEN,
            path: ATRoutes.FOLLOWING_EVENTS_OR_SHOWS_SCREEN,
            builder: (_, __) => const AmptiveFollowingEvenstOrShowsViewWidget(),
          ),
          GoRoute(
            name: ATRoutes.COMMUNITY_SCREEN,
            path: ATRoutes.COMMUNITY_SCREEN,
            builder: (_, __) => const AmptiveCommunityScreen(),
          ),
          GoRoute(
              name: ATRoutes.SOCIETY_SCREEN,
              path: ATRoutes.SOCIETY_SCREEN,
              builder: (_, __) => const AmptiveSocietyScreen(),
              routes: [
                GoRoute(
                  name: ATRoutes.TRENDING_SOCIETY_SCREEN,
                  path: ATRoutes.TRENDING_SOCIETY_SCREEN,
                  builder: (_, __) => const AmptiveTrendingSocietyScreen(),
                ),
                GoRoute(
                  name: ATRoutes.TRENDING_HASHTAGS_SCREEN,
                  path: ATRoutes.TRENDING_HASHTAGS_SCREEN,
                  builder: (_, __) => const AmptiveTrendingHashTagsScreen(),
                ),
                GoRoute(
                  name: ATRoutes.TRENDING_HASHTAG_FULL_SCREEN,
                  path: ATRoutes.TRENDING_HASHTAG_FULL_SCREEN,
                  builder: (_, __) => const AmptiveTrendingHashTagFullScreen(),
                ),
              ]),
        ]),
  ],
  // observers: [LoggingNavigatorObserver()],
);
