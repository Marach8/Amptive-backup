import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:amptive/src/config/services/network_service/interceptor.dart'
    show AuthGuardCubit;
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/end_live_program_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/host_moderation_tools_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/host_view_controls.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/minimized_live_program_indicator.dart';
import 'package:amptive/src/features/notifications/cubits/notifications_cubit.dart';
import 'package:amptive/src/features/notifications/cubits/register_device_fcm_cubit.dart';
import 'package:amptive/src/features/auth/presentation/screens/login_screen.dart';
import 'package:amptive/src/features/home/cubits/home_feed_cubit.dart';
import 'package:amptive/src/features/home/cubits/live_users_cubit.dart';
import 'package:amptive/src/features/profile/cubits/remote_user_data_cubit.dart';
import 'package:amptive/src/services/websocket/user_ws_service.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/features/home/presentation/screens/home_landing_screen.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
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

  OverlayEntry? _liveProgramOverlay;

  void showLiveStreamOverlay({required LiveProgramData? liveProgramData}) {
    if (_liveProgramOverlay != null) return;

    _liveProgramOverlay = OverlayEntry(
      builder: (_) {
        return MultiBlocProvider(
          providers: <SingleChildWidget>[
            BlocProvider<GoLiveControlsVisibilityBloc>(
              create: (_) => GoLiveControlsVisibilityBloc()
            ),
            BlocProvider<HostModerationCubit>(
              create: (_) => HostModerationCubit(),
            ),
            BlocProvider<LocalUserDataCubit>.value(
              value: context.read<LocalUserDataCubit>(),
            ),
            BlocProvider<LiveStreamCubit1>(
              create: (_) => LiveStreamCubit1(
                myUserId: liveProgramData?.roomParticipantId 
                  ?? context.read<LocalUserDataCubit>()
                    .currentUserData?.userId ?? '',
                initialState: LiveStreamState1(
                  programCoverUrl: liveProgramData?.coverUrl,
                  liveStreamId: liveProgramData?.streamId,
                  roomUrl: liveProgramData?.roomUrl,
                  roomEntryToken: liveProgramData?.roomEntryToken,
                  community: liveProgramData?.community,
                  programTitle: liveProgramData?.programTitle,
                  programDesc: liveProgramData?.programDesc,
                  myRole: liveProgramData?.role,
                )
              ),
            ),
            BlocProvider<EndLiveProgramCubit>(
              create: (_) => EndLiveProgramCubit(),
            ),
          ],
          child: LiveProgramOverlay(
            key: liveProgramOverlayKey,
            onDismissed: (String? dismissReason){
              removeLiveOverlay();

              if(dismissReason != null){
                Future<void>.delayed(
                  const Duration(seconds: 2),
                  () {
                    if(mounted){
                      showAppNotification(
                        context: context,
                        icon: const ATImgLoader(
                          imgPath: ATImgStrings.kickUserOut,
                          height: 20, width: 20,
                        ),
                        text: dismissReason,
                        bgColor: ATColors.textRedColor,
                      );
                    }
                  }
                );
              }
            },
            fullChild: const FullLiveProgramScreen(),
            miniChild: const MinimizedLiveProgramIndicator(),
          ),
        );
      },
    );

    Overlay.of(context).insert(_liveProgramOverlay!);
  }

  void removeLiveOverlay() {
    _liveProgramOverlay?.remove();
    _liveProgramOverlay = null;
  }

  @override
  void initState() {
    super.initState();
    _liveUsersScrollController.addListener(() => _onLiveUsersScrollToEnd());
      _notifSubscription = GetIt.I<PushNotificationService>().notificationStream
      .listen((RemoteMessage message) async {
      if (mounted) {
        context.read<ATNavBarBloc>().resetNotificationSession();
        context.read<GetNotificationsCubit>().fetchNotifications(refresh: true);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<LocalUserDataCubit>().initializeCachedData();

      final ScrollController? sController =
          _nestedKey.currentState?.innerController;
      if (sController != null) {
        sController.addListener(() => _onHomeFeedScrollToEnd(sController));
      }
     

      context.read<HomeFeedCubit>().fetchHomeFeed();
      context.read<LiveUsersCubit>().fetchLiveUsers();
      
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
    final ProfileData? userData =
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
    return MultiBlocListener(
      listeners: <SingleChildWidget>[
        BlocListener<AuthGuardCubit, bool>(
          listener: (_, bool isNotAuthenticated) {
            if (isNotAuthenticated == true) {
              final BuildContext activeContext =
                  navigatorKey.currentContext ?? context;
              //activeContext.read<AuthGuardCubit>().reset();
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
          if(_liveProgramOverlay == null){
            context.pop();
          }
          else{
            final bool isMinimized = liveProgramOverlayKey
              .currentState?.isMinimized ?? false;
            if(isMinimized){
              liveProgramOverlayKey.currentState?.dismissLiveProgram();
            }
            else{
              liveProgramOverlayKey.currentState?.minimize();
            }
          }
        },
        child: ATAnnotatedRegion(
          child: Scaffold(
              body: BlocSelector<ATNavBarBloc, (int, bool, bool), int>(
                  selector: ((int, bool, bool) st) => st.$1,
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
    );
  }
}
