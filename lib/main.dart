import 'package:amptive/src/config/config_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  await _initializeRedirect();
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


Future<void> _initializeRedirect()async{
  const FlutterSecureStorage storage = FlutterSecureStorage();
  await storage.write(
    key: ATStrings.SHOULD_REDIRECT,
    value: true.toString()
  );
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
