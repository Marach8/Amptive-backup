import 'dart:io';

import 'package:amptive/src/providers/form_providers.dart';
import 'package:amptive/src/providers/preference_provider.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/screens/authentication_screens/auth_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/dob_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/preference_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/add_phone.dart';
import 'package:amptive/src/views/screens/main_application_screens/crop_image_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/email_auth_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/name_auth_screen.dart';
import 'package:amptive/src/views/screens/onboarding_screens/onboarding.dart';
import 'package:amptive/src/views/screens/authentication_screens/otp_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/password_auth_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/post_registration.dart';
import 'package:amptive/src/views/screens/main_application_screens/pre_homepage.dart';
import 'package:amptive/src/views/screens/authentication_screens/username_auth_screen.dart';
import 'package:amptive/src/views/screens/onboarding_screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FormProvider()),
          ChangeNotifierProvider(create: (_) => PreferenceModel()),
        ],
        child: const AmptiveApp(),
      ),
    );

/// The route configuration.
final GoRouter _router = GoRouter(
  initialLocation: AmptiveRoutes.index,
  // initialLocation: "/email-route/otp",
  routes: <RouteBase>[
    GoRoute(
      path: AmptiveRoutes.index,
      builder: (BuildContext context, GoRouterState state) {
        return const PreHomePage();
      },

    ),
    GoRoute(
        name: AmptiveRoutes.welcome,
        path: "/welcome-route",
        builder: (BuildContext context, GoRouterState state) =>
            const WelcomeScreen(),
        routes: <RouteBase>[
          GoRoute(
            name: AmptiveRoutes.authScreen,
            path: "auth-route",
            builder: (BuildContext context, GoRouterState state) => AuthScreen(
              isLogin: state.extra as bool,
            ),
          ),
        ]),
    GoRoute(
      name: AmptiveRoutes.onboarding,
      path: "/onboarding-route",
      builder: (BuildContext context, GoRouterState state) =>
          const OnboardingScreen(),
    ),
    GoRoute(
        name: AmptiveRoutes.emailAuth,
        path: "/email-route",
        builder: (BuildContext context, GoRouterState state) =>
            const EmailAuthScreen(),
      ),

    GoRoute(
      name: AmptiveRoutes.otp,
      path: "/otp",
      builder: (BuildContext context, GoRouterState state) {
        String where = state.extra as String;
        return OTPScreen(from: where);

      }
    ),


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
      routes: <RouteBase> [
        GoRoute(
          name: AmptiveRoutes.cropImage,
          path: "crop-image",
          builder: (BuildContext context, GoRouterState state) {
            File imageFile = state.extra as File;
            return CropPage(title: "Cropper", imageFile: imageFile,);
          }
        ),
      ]
    ),

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
);

class AmptiveApp extends StatelessWidget {
  const AmptiveApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routerConfig: _router);
      },
    );
  }
}
