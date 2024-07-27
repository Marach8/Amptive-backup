import 'dart:io';
import 'package:amptive/src/bloc/authentication_bloc/auth_bloc.dart';
import 'package:amptive/src/bloc/onboarding_bloc/onboarding_bloc.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/themes/app_theme_data.dart';
import 'package:amptive/src/views/screens/authentication_screens/sign_in_or_sign_up_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/dob_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/home_screen.dart';
import 'package:amptive/src/views/screens/main_application_screens/preference_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/add_phone.dart';
import 'package:amptive/src/views/screens/main_application_screens/crop_image_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/email_auth_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/name_auth_screen.dart';
import 'package:amptive/src/views/screens/onboarding_screens/onboarding_page_view_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/otp_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/create_password_screen.dart';
import 'package:amptive/src/views/screens/authentication_screens/post_registration.dart';
import 'package:amptive/src/views/screens/authentication_screens/username_auth_screen.dart';
import 'package:amptive/src/views/screens/onboarding_screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(
  MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => AmptiveOnboardingBloc()),
      BlocProvider(create: (_) => AmptiveAuthBloc())
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
      builder: (_, __) => const AmptiveHomeScreen()
    ),

    GoRoute(
      name: 'homescreen',
      path: "/home-screen",
      builder: (_, __) => const AmptiveHomeScreen()
    ),

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
      builder: (_, __) =>const AmptiveEmailAuthScreen()
    ),

    GoRoute(
      name: AmptiveRoutes.otp,
      path: "/otp",
      builder: (BuildContext context, GoRouterState state) {
        String where = state.extra as String;
        return const AmptiveVerifyOTPScreen();

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
          const AmptiveCreatePasswordScreen(),
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
      builder: (_, __) => const UserNameAuthScreen(),
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
          themeMode: ThemeMode.dark,
          darkTheme: AmptiveThemeData.darkTheme,
          routerConfig: _router,
        );
      },
    );
  }
}
