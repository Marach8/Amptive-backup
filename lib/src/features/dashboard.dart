import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:amptive/src/config/services/network_service/interceptor.dart'
    show AuthGuardCubit;
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/minimized_live_program_indicator.dart';
import 'package:amptive/src/features/notifications/cubits/notifications_cubit.dart';
import 'package:amptive/src/features/notifications/cubits/register_device_fcm_cubit.dart';
import 'package:amptive/src/features/auth/presentation/screens/login_screen.dart';
import 'package:amptive/src/features/home/cubits/home_feed_cubit.dart';
import 'package:amptive/src/features/home/cubits/live_users_cubit.dart';
import 'package:amptive/src/features/profile/cubits/remote_user_data_cubit.dart';
import 'package:amptive/src/services/websocket/user_ws_service.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/features/home/presentation/screens/home_landing_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import '../global_export.dart';
import '../services/go_live_service/go_live_service.dart';
import '../services/notification/push_notification_service.dart';
import 'notifications/presentation/screens/notif_landing_screen.dart';


class ATDashboard extends StatelessWidget {
  const ATDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<HomeFeedCubit>(create: (_) => HomeFeedCubit()),
        BlocProvider<LiveUsersCubit>(create: (_) => LiveUsersCubit()),
        BlocProvider<RemoteUserDataCubit>(create: (_) => RemoteUserDataCubit()),
        BlocProvider<RegisterDeviceFCMCubit>(create: (_) => RegisterDeviceFCMCubit()),
        BlocProvider<GetNotificationsCubit>(create: (_) => GetNotificationsCubit()),
      ],
      child: _SubWidget(key: dashboardKey),
    );
  }
}


class _SubWidget extends StatefulWidget {
  const _SubWidget({super.key});

  @override
  State<_SubWidget> createState() => DashboardState();
}


final GlobalKey<DashboardState> dashboardKey = GlobalKey<DashboardState>();

class DashboardState extends State<_SubWidget>{  
  final ScrollController _liveUsersScrollController 
    = ScrollController();
  final GlobalKey<NestedScrollViewState> _nestedKey 
    = GlobalKey<NestedScrollViewState>();
  final GlobalKey<NestedScrollViewState> _notifNestedKey 
    = GlobalKey<NestedScrollViewState>();

  StreamSubscription<RemoteMessage>? _notifSubscription;

  OverlayEntry? _liveOverlay;

  void showLiveOverlay({required LiveProgramData? liveProgramData}) {
    if (_liveOverlay != null) return;

    _liveOverlay = OverlayEntry(
      builder: (_) {
        return LiveProgramOverlay(
          key: liveProgramOverlayKey,
          onDismissed: () => removeLiveOverlay(),
          fullChild: FullLiveProgramScreen(
            liveProgramData: liveProgramData),
          miniChild: MinimizedLiveProgramIndicator(
            liveProgramData: liveProgramData),
        );
      },
    );

    Overlay.of(context).insert(_liveOverlay!);
  }

  void removeLiveOverlay() {
    _liveOverlay?.remove();
    _liveOverlay = null;
  }

  @override
  void initState() {
    super.initState();
    _liveUsersScrollController.addListener(() => _onLiveUsersScrollToEnd());
      _notifSubscription = GetIt.I<PushNotificationService>().notificationStream
      .listen((RemoteMessage message) async {
      if (mounted) {
        context.read<GetNotificationsCubit>().fetchNotifications(refresh: true);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ScrollController? sController =
          _nestedKey.currentState?.innerController;
      if (sController != null) {
        sController.addListener(() => _onHomeFeedScrollToEnd(sController));
      }
     

      context.read<HomeFeedCubit>().fetchHomeFeed();
      context.read<LiveUsersCubit>().fetchLiveUsers();
      
      await context.read<LocalUserDataCubit>().initializeCachedData();
      _registerDeviceForPush();

      context.read<LocalUserDataCubit>().initializeCachedData();
       context.read<GetNotificationsCubit>().fetchNotifications();
      // init push notification and connect user to websocket

      GetIt.I<PushNotificationService>().init();
      GetIt.I<UserWsService>().connectUser();
    });
   
  }
  @override
  void dispose() {
    _notifSubscription?.cancel(); 
    removeLiveOverlay();
    super.dispose();
  }

  void _onHomeFeedScrollToEnd(ScrollController sController) {
    const double threshHold = 80;
    if (sController.position.pixels >=
        sController.position.maxScrollExtent + threshHold) {
      context.read<HomeFeedCubit>().fetchHomeFeed();
    }
  }

  void _onLiveUsersScrollToEnd() {
    const double threshHold = 80;
    if (_liveUsersScrollController.position.pixels >=
        _liveUsersScrollController.position.maxScrollExtent + threshHold) {
      context.read<LiveUsersCubit>().fetchLiveUsers();
    }
  }
  void _onNotificationsScrollToEnd() {
  final ScrollController? controller = _notifNestedKey.currentState?.innerController;
  if (controller == null) return;
  
  const double threshHold = 80;
  
  if (controller.position.pixels >= controller.position.maxScrollExtent + threshHold) {
   context.read<GetNotificationsCubit>().fetchNotifications();
  }
}

  Future<void> _registerDeviceForPush() async {
    final CachedUserData? userData =
        context.read<LocalUserDataCubit>().currentUserData;

    if (userData == null || userData.userId == null) {
      return;
    }
    if (mounted) {
      context.read<RegisterDeviceFCMCubit>().registerDevice(
            userId: userData.userId!,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    log('This was called ooo');
    return MultiBlocListener(
      listeners: <SingleChildWidget>[
        BlocListener<AuthGuardCubit, bool>(
          listener: (_, bool isNotAuthenticated) {
            if (isNotAuthenticated == true) {
              final BuildContext activeContext =
                  navigatorKey.currentContext ?? context;
              activeContext.read<AuthGuardCubit>().reset();
              activeContext.goNamed(ATRoutes.temporaryLoginScreen,
                  extra: const LoginScreenEntryParams(
                    title: 'Login',
                    notification: 'Session Expired. Please login',
                  ));
            }
          },
        )
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, _) {
          if (didPop) return;
          if(_liveOverlay == null){
            context.pop();
            //context.read<LiveStreamCubit1>().disconnect();
          }
          else{
            //Slide the overlay down, out of view
            //Which then removes the overlay afterwards
            liveProgramOverlayKey.currentState?.dismiss();
          }
        },
        child: ATAnnotatedRegion(
          child: SafeArea(
            bottom: false,
            top: false,
            child: Scaffold(
                body: BlocSelector<ATNavBarBloc, (int, bool), int>(
                    selector: ((int, bool) st) => st.$1,
                    builder: (_, int index) {
                      return IndexedStack(index: index, children: <Widget>[
                        HomeTabView(
                          nestedKey: _nestedKey,
                          liveUsersScrollController: _liveUsersScrollController,
                        ),
                        const DiscoverTabView(),
                        const SizedBox(),
                        NotificationTabView(nestedKey: _notifNestedKey,
                         onScroll: _onNotificationsScrollToEnd),
                      ]);
                    }),
                resizeToAvoidBottomInset: false,
                backgroundColor: ATColors.transparent,
                bottomSheet: const MainAppBottomNav()),
          ),
        ),
      ),
    );
  }
}
