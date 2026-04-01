import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/services/network_service/interceptor.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/services/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:nested/nested.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await setup();
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

Future<void> _initializeRedirect() async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  await storage.write(key: ATStrings.SHOULD_REDIRECT, value: true.toString());
}

class AmptiveApp extends StatefulWidget {
  const AmptiveApp({super.key});

  @override
  State<AmptiveApp> createState() => _AmptiveAppState();
}

class _AmptiveAppState extends State<AmptiveApp> {
  @override
  void initState() {
    super.initState();

    GetIt.I<NotificationService>().init();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, Widget? child) {
        return MultiBlocProvider(
          providers: <SingleChildWidget>[
            BlocProvider<LocalUserDataCubit>(
                create: (_) => LocalUserDataCubit()),
            BlocProvider<AuthGuardCubit>.value(value: authGuardCubit),
          ],
          child: MaterialApp.router(
            scaffoldMessengerKey: scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            darkTheme: AmptiveThemeData.darkTheme,
            theme: AmptiveThemeData.darkTheme,
            routerConfig: amptiveAppRouter,
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData mediaQuery = MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.noScaling);
              return MediaQuery(
                data: mediaQuery,
                child: ScrollConfiguration(
                  behavior: const _GlobalScrollBehavior(),
                  child: child!,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class _GlobalScrollBehavior extends ScrollBehavior {
  const _GlobalScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(_) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}