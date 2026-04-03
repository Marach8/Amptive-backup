import 'package:amptive/src/config/services/network_service/interceptor.dart' show AuthGuardCubit;
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/presentation/screens/login_screen.dart';
import 'package:amptive/src/features/home/cubits/home_feed_cubit.dart';
import 'package:amptive/src/features/home/cubits/live_users_cubit.dart';
import 'package:amptive/src/features/profile/cubits/remote_user_data_cubit.dart';
import 'package:amptive/src/services/websocket/user_ws_service.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/features/home/presentation/screens/home_landing_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import '../global_export.dart';
import '../services/go_live_service/go_live_service.dart';
import '../services/notification/push_notification_service.dart';
import 'go_live/go_live_export.dart';
import 'notifications/presentation/screens/notif_landing_screen.dart';

enum GoLiveUserType { audience, cohost, host }

class GoLiveScreen extends StatefulWidget {
  const GoLiveScreen({super.key, required this.userType});

  final GoLiveUserType userType;

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  @override
  void initState() {
    super.initState();

    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.manual,
    //   overlays: <SystemUiOverlay>[SystemUiOverlay.top],
    // );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.userType) {
      GoLiveUserType.audience =>
        LiveProgramAudienceView(goLiveHost: getHostList().first),
      GoLiveUserType.cohost => const LiveProgramCohostView(),
      GoLiveUserType.host =>
        LiveProgramHostView(goLiveHost: getHostList().first),
    };
  }
}

class ATMainAppShell extends StatelessWidget {
  const ATMainAppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<HomeFeedCubit>(create: (_) => HomeFeedCubit()),
        BlocProvider<LiveUsersCubit>(create: (_) => LiveUsersCubit()),
        BlocProvider<RemoteUserDataCubit>(create: (_) => RemoteUserDataCubit())
      ],
      child: const _SubWidget(),
    );
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget();

  @override
  State<_SubWidget> createState() => __SubWidgetState();
}

class __SubWidgetState extends State<_SubWidget> {
  final ScrollController _liveUsersScrollController = ScrollController();
  final GlobalKey<NestedScrollViewState> _nestedKey =
      GlobalKey<NestedScrollViewState>();

  @override
  void initState() {
    super.initState();
    _liveUsersScrollController.addListener(() => _onLiveUsersScrollToEnd());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ScrollController? sController =
          _nestedKey.currentState?.innerController;
      if (sController != null) {
        sController.addListener(() => _onHomeFeedScrollToEnd(sController));
      }

      context.read<HomeFeedCubit>().fetchHomeFeed();
      context.read<LiveUsersCubit>().fetchLiveUsers();
      context.read<LocalUserDataCubit>().initializeCachedData();
      // init push notification and connect user to websocket
      GetIt.I<PushNotificationService>().init();
      GetIt.I<UserWsService>().connectUser();
    });
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthGuardCubit, bool?>(
      listener: (_, bool? isNotAuthenticated){
        if(isNotAuthenticated == true){
          context.read<AuthGuardCubit>().reset();
          context.goNamed(
            ATRoutes.temporaryLoginScreen,
            extra: const LoginScreenEntryParams(
              title: 'Login',
              notification: 'Session Expired. Please login',
            )
          );
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
                return IndexedStack(
                  index: index,
                  children: <Widget>[
                    HomeTabView(
                      nestedKey: _nestedKey,
                      liveUsersScrollController: _liveUsersScrollController,
                    ),
                    const DiscoverTabView(),
                    const SizedBox(),
                    const NotificationTabView()
                  ]
                );
              }
            ),
            resizeToAvoidBottomInset: false,
            backgroundColor: ATColors.transparent,
            bottomSheet: const MainAppBottomNav()
          ),
        ),
      ),
    );
  }
}
