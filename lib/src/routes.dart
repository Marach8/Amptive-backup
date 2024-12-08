import 'dart:io';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
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
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/go_live_views/show/choose_show_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/go_live_views/show/show_creation_success_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/show_detailed_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/subscribed_screen.dart';

// The route configuration.
final GoRouter amptiveAppRouter = GoRouter(
  initialLocation: AmptiveRoutes.index,
  // initialLocation: "/email-route/otp",
  routes: <RouteBase>[
    GoRoute(
        path: AmptiveRoutes.index,
        builder: (_, __) => const CreateShowScreen(showType: ShowType.show)),
    GoRoute(
      name: AmptiveRoutes.welcome,
      path: "/welcome-route",
      builder: (_, __) => const AmptiveWelcomeScreen(),
    ),
    GoRoute(
      name: AmptiveRoutes.onboarding,
      path: "/onboarding-route",
      builder: (_, __) => const AmptiveOnboardingScreen(),
    ),

    //AUTHENTICATION SCREENS
    GoRoute(
      name: AmptiveRoutes.authScreen,
      path: "/auth-route",
      builder: (_, GoRouterState state) => AmptiveAuthScreen(
        userSignUp: state.extra as bool,
      ),
    ),
    GoRoute(
        name: AmptiveRoutes.emailAuth,
        path: "/email-route",
        builder: (_, __) => const AmptiveEmailAuthScreen()),
    GoRoute(
        name: AmptiveRoutes.otp,
        path: "/otp",
        builder: (_, GoRouterState state) {
          String where = state.extra as String;
          return OTPScreen(from: where);
        }),
    GoRoute(
      name: AmptiveRoutes.addPhone,
      path: "/add-phone",
      builder: (_, __) => const AddPhoneScreen(),
    ),
    GoRoute(
        name: AmptiveRoutes.addProfilePic,
        path: "/add-profile-pic",
        builder: (_, __) => const PostRegistrationScreen(),
        routes: <RouteBase>[
          GoRoute(
              name: AmptiveRoutes.cropImage,
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
      name: AmptiveRoutes.passwordAuth,
      path: "/password",
      builder: (_, __) => const PasswordAuthScreen(),
    ),
    GoRoute(
      name: AmptiveRoutes.dobAuth,
      path: "/dob",
      builder: (_, __) => const DateOfBirthScreen(),
    ),
    GoRoute(
      name: AmptiveRoutes.addUsername,
      path: "/username-add",
      builder: (_, __) => const UserNameAuthScreen(),
    ),
    GoRoute(
      name: AmptiveRoutes.addName,
      path: "/name-add",
      builder: (_, __) => const NameAuthScreen(),
    ),
    GoRoute(
      name: AmptiveRoutes.preference,
      path: "/preference-route",
      builder: (_, __) => const AmptivePreferenceScreen(),
    ),

    GoRoute(
      name: AmptiveRoutes.preHomepage,
      path: "/pre-homepage",
      builder: (_, __) => const PreHomePage(),
    ),

    //MAIN APPLICATION SCREENS
    GoRoute(
        name: AmptiveRoutes.homeScreen,
        path: "/home-screen",
        builder: (_, __) => const AmptiveDashboardScreen(),
        routes: [
          GoRoute(
              name: AmptiveRoutes.showDetailedScreen,
              path: AmptiveRoutes.showDetailedScreen,
              pageBuilder: (context, state) => CustomTransitionPage(
                    child: const AmptiveShowDetailedScreen(),
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
              name: AmptiveRoutes.EVENT_DETAILED_SCREEN,
              path: AmptiveRoutes.EVENT_DETAILED_SCREEN,
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
            name: AmptiveRoutes.CHOOSE_OR_CREATE_SHOW_SCREEN,
            path: AmptiveRoutes.CHOOSE_OR_CREATE_SHOW_SCREEN,
            builder: (_, __) => const AmptiveChooseOrCreateShowScreen(),
          ),
          GoRoute(
            name: AmptiveRoutes.CHOOSE_OR_CREATE_EVENT_SCREEN,
            path: AmptiveRoutes.CHOOSE_OR_CREATE_EVENT_SCREEN,
            builder: (_, __) => const AmptiveChooseOrCreateEventScreen(),
          ),
          GoRoute(
              name: AmptiveRoutes.CREATE_SHOW_FORM,
              path: AmptiveRoutes.CREATE_SHOW_FORM,
              builder: (_, __) {
                return const CreateShowScreen(showType: ShowType.show);
              }),
          GoRoute(
              name: AmptiveRoutes.CREATE_EVENT_FORM,
              path: AmptiveRoutes.CREATE_EVENT_FORM,
              builder: (_, GoRouterState state) {
                return const CreateShowScreen(
                  showType: ShowType.event,
                );
              }),
          GoRoute(
              name: AmptiveRoutes.CREATE_EPISODE_FORM,
              path: AmptiveRoutes.CREATE_EPISODE_FORM,
              builder: (_, __) {
                return const CreateShowScreen(showType: ShowType.episode);
              }),
          GoRoute(
            name: AmptiveRoutes.CREATE_SHOW_SUCCESS,
            path: AmptiveRoutes.CREATE_SHOW_SUCCESS,
            builder: (_, GoRouterState state) {
              String imageFilePath = state.extra as String;
              return AmptiveCreateShowSuccessScreen(
                imageFilePath: imageFilePath,
              );
            },
          ),
          GoRoute(
            name: AmptiveRoutes.GO_LIVE_SCREEN,
            path: AmptiveRoutes.GO_LIVE_SCREEN,
            builder: (_, __) => const AmptiveGoLiveScreen(),
          ),
          GoRoute(
            name: AmptiveRoutes.SCHEDULED_EVENTS_OR_SHOWS_SCREEN,
            path: AmptiveRoutes.SCHEDULED_EVENTS_OR_SHOWS_SCREEN,
            builder: (_, __) => const AmptiveScheduledEventOrShowViewWidget(),
          ),
          GoRoute(
            name: AmptiveRoutes.EVENT_SCHEDULED_SCREEN,
            path: AmptiveRoutes.EVENT_SCHEDULED_SCREEN,
            builder: (_, GoRouterState state) {
              String imageFilePath = state.extra as String;
              return AmptiveShowScheduledScreen(
                showType: ShowType.event,
                imageFilePath: imageFilePath,
              );
            },
          ),
          GoRoute(
            name: AmptiveRoutes.EPISODE_SCHEDULED_SCREEN,
            path: AmptiveRoutes.EPISODE_SCHEDULED_SCREEN,
            builder: (_, GoRouterState state) {
              String imageFilePath = state.extra as String;
              return AmptiveShowScheduledScreen(
                showType: ShowType.episode,
                imageFilePath: imageFilePath,
              );
            },
          ),
          GoRoute(
            name: AmptiveRoutes.SUBSCRIBED_EVENTS_OR_SHOWS_SCREEN,
            path: AmptiveRoutes.SUBSCRIBED_EVENTS_OR_SHOWS_SCREEN,
            builder: (_, __) => const AmptiveSubscribedEventOrShowViewWidget(),
          ),
          GoRoute(
            name: AmptiveRoutes.FOLLOWING_EVENTS_OR_SHOWS_SCREEN,
            path: AmptiveRoutes.FOLLOWING_EVENTS_OR_SHOWS_SCREEN,
            builder: (_, __) => const AmptiveFollowingEvenstOrShowsViewWidget(),
          ),
          GoRoute(
            name: AmptiveRoutes.COMMUNITY_SCREEN,
            path: AmptiveRoutes.COMMUNITY_SCREEN,
            builder: (_, __) => const AmptiveCommunityScreen(),
          ),
          GoRoute(
              name: AmptiveRoutes.SOCIETY_SCREEN,
              path: AmptiveRoutes.SOCIETY_SCREEN,
              builder: (_, __) => const AmptiveSocietyScreen(),
              routes: [
                GoRoute(
                  name: AmptiveRoutes.TRENDING_SOCIETY_SCREEN,
                  path: AmptiveRoutes.TRENDING_SOCIETY_SCREEN,
                  builder: (_, __) => const AmptiveTrendingSocietyScreen(),
                ),
                GoRoute(
                  name: AmptiveRoutes.TRENDING_HASHTAGS_SCREEN,
                  path: AmptiveRoutes.TRENDING_HASHTAGS_SCREEN,
                  builder: (_, __) => const AmptiveTrendingHashTagsScreen(),
                ),
                GoRoute(
                  name: AmptiveRoutes.TRENDING_HASHTAG_FULL_SCREEN,
                  path: AmptiveRoutes.TRENDING_HASHTAG_FULL_SCREEN,
                  builder: (_, __) => const AmptiveTrendingHashTagFullScreen(),
                ),
              ]),
        ]),
  ],
  // observers: [LoggingNavigatorObserver()],
);
