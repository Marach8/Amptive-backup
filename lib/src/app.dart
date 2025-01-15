import 'package:amptive/src/routes.dart';
import 'package:amptive/src/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/utils/themes/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          scaffoldMessengerKey: scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          darkTheme: AmptiveThemeData.darkTheme,
          routerConfig: amptiveAppRouter,
          // routeInformationParser: amptiveAppRouter.routeInformationParser,
          // routerDelegate: amptiveAppRouter.routerDelegate,
          // routeInformationProvider: amptiveAppRouter.routeInformationProvider,
        );
      },
    );
  }
}
