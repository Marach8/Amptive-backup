
import 'package:amptive/src/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/routes.dart';
import 'package:amptive/src/utils/themes/app_theme_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  setup();
  runApp(
    MultiBlocProvider(
      providers: providers(),
      child: const AmptiveApp(),
    ),
  );
}



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
          theme: AmptiveThemeData.darkTheme,
          routerConfig: amptiveAppRouter,
          // routeInformationParser: amptiveAppRouter.routeInformationParser,
          // routerDelegate: amptiveAppRouter.routerDelegate,
          // routeInformationProvider: amptiveAppRouter.routeInformationProvider,
        );
      },
    );
  }
}


final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
