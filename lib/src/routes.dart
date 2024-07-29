import 'dart:io';

import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/helpers/helper_classes/navigator_observer.dart';
import 'package:amptive/src/views/screens/authentication_screens/add_phone.dart';
import 'package:amptive/src/views/screens/authentication_screens/auth_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/dob_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/email_auth_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/name_auth_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/otp_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/password_auth_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/post_registration.dart';
import 'package:amptive/src/views/screens/authentication_screens/username_auth_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/crop_image_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/preference_screen.dart';
import 'package:amptive/src/views/screens/onboarding_screens/onboarding_page_view_screen.dart';
import 'package:amptive/src/views/screens/onboarding_screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The route configuration.
final GoRouter amptiveAppRouter = GoRouter(
  initialLocation: AmptiveRoutes.index,
  // initialLocation: "/email-route/otp",
  routes: <RouteBase>[
    GoRoute(
        path: AmptiveRoutes.index,
        builder: (_, __) => const PreferenceScreen()),
    GoRoute(
      name: AmptiveRoutes.welcome,
      path: "/welcome-route",
      builder: (_, __) => const AmptiveWelcomeScreen(),
    ),
    GoRoute(
      name: AmptiveRoutes.authScreen,
      path: "/auth-route",
      builder: (_, GoRouterState state) => AmptiveAuthScreen(
        userSignUp: state.extra as bool,
      ),
    ),
    GoRoute(
      name: AmptiveRoutes.onboarding,
      path: "/onboarding-route",
      builder: (_, __) => const AmptiveOnboardingScreen(),
    ),
    GoRoute(
        name: AmptiveRoutes.emailAuth,
        path: "/email-route",
        builder: (_, __) => const AmptiveEmailAuthScreen()),
    GoRoute(
        name: AmptiveRoutes.otp,
        path: "/otp",
        builder: (BuildContext context, GoRouterState state) {
          String where = state.extra as String;
          return OTPScreen(from: where);
        }),
    GoRoute(
      name: AmptiveRoutes.addPhone,
      path: "/add-phone",
      builder: (BuildContext context, GoRouterState state) =>
          const AddPhoneScreen(),
    ),
    GoRoute(
        name: AmptiveRoutes.addProfilePic,
        path: "/add-profile-pic",
        builder: (BuildContext context, GoRouterState state) =>
            const PostRegistrationScreen(),
        routes: <RouteBase>[
          GoRoute(
              name: AmptiveRoutes.cropImage,
              path: "crop-image",
              builder: (BuildContext context, GoRouterState state) {
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
      builder: (BuildContext context, GoRouterState state) =>
          const PasswordAuthScreen(),
    ),
    GoRoute(
      name: AmptiveRoutes.dobAuth,
      path: "/dob",
      builder: (BuildContext context, GoRouterState state) =>
          const DateOfBirthScreen(),
    ),
    GoRoute(
      name: AmptiveRoutes.addUsername,
      path: "/username-add",
      builder: (BuildContext context, GoRouterState state) =>
          const UserNameAuthScreen(),
    ),
    GoRoute(
      name: AmptiveRoutes.addName,
      path: "/name-add",
      builder: (BuildContext context, GoRouterState state) =>
          const NameAuthScreen(),
    ),
    GoRoute(
      name: AmptiveRoutes.preference,
      path: "/preference-route",
      builder: (BuildContext context, GoRouterState state) =>
          const PreferenceScreen(),
    ),
  ],
  // observers: [LoggingNavigatorObserver()],
);
