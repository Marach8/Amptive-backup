import 'package:amptive/providers/form_providers.dart';
import 'package:amptive/routers/amptive_routes.dart';
import 'package:amptive/screens/AuthScreen.dart';
import 'package:amptive/screens/PreferenceScreen.dart';
import 'package:amptive/screens/emailAuthScreen.dart';
import 'package:amptive/screens/onboarding.dart';
import 'package:amptive/screens/splash.dart';
import 'package:amptive/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FormProvider()),
        ],
        child: const AmptiveApp(),
      ),
    );

/// The route configuration.
final GoRouter _router = GoRouter(
  initialLocation: AmptiveRoutes.index,
  // initialLocation: "/email-route",
  routes: <RouteBase>[
    GoRoute(
      path: AmptiveRoutes.index,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
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
