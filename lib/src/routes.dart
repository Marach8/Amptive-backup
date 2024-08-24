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
import 'package:amptive/src/views/screens/main_application_screens/dashboard_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/home_sub_view/scheduled_screen.dart';
import 'package:amptive/src/views/screens/post_authentication_screens/crop_image_screen.dart';
import 'package:amptive/src/views/screens/post_authentication_screens/preference_screen.dart';
import 'package:amptive/src/views/screens/onboarding_screens/onboarding_page_view_screen.dart';
import 'package:amptive/src/views/screens/onboarding_screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/event_detailed_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/following_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/show_detailed_screen.dart';
import 'views/screens/main_application_screens/sub_views/home_view/home_sub_view/subscribed_screen.dart';

// The route configuration.
final GoRouter amptiveAppRouter = GoRouter(
  initialLocation: AmptiveRoutes.index,
  // initialLocation: "/email-route/otp",
  routes: <RouteBase>[
    GoRoute(
      path: AmptiveRoutes.index,
      builder: (_, __) => const AmptiveDashboardScreen()
    ),
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
      builder: (_, __) => const AmptiveEmailAuthScreen()
    ),
    GoRoute(
      name: AmptiveRoutes.otp,
      path: "/otp",
      builder: (_, GoRouterState state) {
        String where = state.extra as String;
        return OTPScreen(from: where);
      }
    ),
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
            return CropPage(title: "Cropper", imageFile: imageFile,);
          }
        ),
      ]
    ),
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
            transitionsBuilder: (context, animation, secondaryAnimation, child){
              var tween = Tween(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeIn
                ),
              );

              return SlideTransition(
                position: tween,
                child: child,
              );
            },
            reverseTransitionDuration: const Duration(milliseconds: 700),
            transitionDuration: const Duration(milliseconds: 700),
          )
        ),

        GoRoute(
          name: AmptiveRoutes.eventDetailedScreen,
          path: AmptiveRoutes.eventDetailedScreen,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const AmptiveEventDetailedScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child){
              var tween = Tween(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeIn
                ),
              );

              return SlideTransition(
                position: tween,
                child: child,
              );
            },
            reverseTransitionDuration: const Duration(milliseconds: 700),
            transitionDuration: const Duration(milliseconds: 700),
          )
        ),

        GoRoute(
          name: AmptiveRoutes.scheduledEventsOrShowsScreen,
          path: AmptiveRoutes.scheduledEventsOrShowsScreen,
          builder: (_, __) => const AmptiveScheduledEventOrShowViewWidget(),
        ),

        GoRoute(
          name: AmptiveRoutes.subscribedEventsOrShowsScreen,
          path: AmptiveRoutes.subscribedEventsOrShowsScreen,
          builder: (_, __) => const AmptiveSubscribedEventOrShowViewWidget(),
        ),

        GoRoute(
          name: AmptiveRoutes.followingEventsOrShowsScreen,
          path: AmptiveRoutes.followingEventsOrShowsScreen,
          builder: (_, __) => const AmptiveFollowingEvenstOrShowsViewWidget(),
        ),
      ]
    ),
  ],
  // observers: [LoggingNavigatorObserver()],
);
