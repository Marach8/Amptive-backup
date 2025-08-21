import 'package:amptive/src/features/discover/presentation/views/discover_landing_screen.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/features/home/presentation/views/home_landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/go_live_service/go_live_service.dart';
import 'go_live/go_live_export.dart';
import 'notifications/presentation/views/notif_landing_screen.dart';


enum GoLiveUserType{audience, cohost, host}
class GoLiveScreen extends StatelessWidget {
  const GoLiveScreen({
    super.key,
    required this.userType
  });

  final GoLiveUserType userType;

  @override
  Widget build(BuildContext context) {
    return switch(userType){
      GoLiveUserType.audience => LiveProgramAudienceView(goLiveHost: getHostList().first),
      GoLiveUserType.cohost => const LiveProgramCohostView(),
      GoLiveUserType.host => LiveProgramHostView(goLiveHost: getHostList().first),
    };
  }
}


class ATMainAppShell extends StatelessWidget {
  const ATMainAppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: BlocSelector<ATNavBarBloc, (int, bool), int>(
          selector: ((int, bool) st) => st.$1,
          builder: (_, int index) {
            return SafeArea(
              child: IndexedStack(
                index: index,
                children: const <Widget>[
                  HomeTabView(),
                  DiscoverTabView(),
                  SizedBox(),
                  NotificationTabView()
                ]
              ),
            );
          }
        ),
        
        resizeToAvoidBottomInset: false,

        bottomSheet: const MainAppBottomNav()
      ),
    );
  }
}
