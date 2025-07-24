import 'package:amptive/src/config/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/routing/routes.dart';
import 'package:amptive/src/config/themes/app_theme_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:device_preview/device_preview.dart';

void main() {
  setup();
  runApp(
    MultiBlocProvider(
      providers: providers(),
      child: const AmptiveApp(),
    ),
  );

  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     builder: (_) => MultiBlocProvider(
  //       providers: providers(),
  //       child: const AmptiveApp(),
  //     ),
  //   ),
  // );
}



class AmptiveApp extends StatelessWidget {
  const AmptiveApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, Widget? child) {
        return MaterialApp.router(
          scaffoldMessengerKey: scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          darkTheme: AmptiveThemeData.darkTheme,
          theme: AmptiveThemeData.darkTheme,
          routerConfig: amptiveAppRouter,
        );
      },
    );
  }
}


final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
