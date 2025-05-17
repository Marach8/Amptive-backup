import 'package:amptive/src/bloc/main_app/nav_bar_bloc.dart';
import 'package:amptive/src/views/features/discover/presentation/views/discover_landing_screen.dart';
import 'package:amptive/src/views/features/live_programs/presentation/views/live_audience_view.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/dashboard_nav_bar_widget.dart';
import 'package:amptive/src/views/features/home/presentation/views/home_landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/go_live_service/go_live_service.dart';
import 'live_programs/presentation/views/live_host_view.dart';
import 'notifications/presentation/views/notif_landing_screen.dart';


class AmptiveDashboardScreen extends StatelessWidget {
  const AmptiveDashboardScreen({super.key});

  @override
  Widget build(context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: BlocBuilder<AmptiveNavBarBloc, int>(
          builder: (_, index) {
            return IndexedStack(
              index: index,
              children: [
                const ATHomeScreen(),
                const ATDiscoverScreen(),
                ATLiveProgramsAudienceScreen(goLiveHost: getHostList().first),
                //const AmptiveGoLiveCohostView(),
                //AmptiveGoLiveHostView(goLiveHost: getHostList().first),
                const ATNotificationScreen()
              ]
            );
          }
        ),

        bottomNavigationBar: BlocBuilder<AmptiveNavBarBloc, int>(
          builder: (_, index) {
            if(index == 2){
              return const SizedBox.shrink();
            }
            return const AmptiveDashboardBottomNavBarWidget();
          },
          /// Only rebuild when index changes between 2 and other values
          buildWhen: (prev, curr) => (prev == 2 && curr != 2) || (prev != 2 && curr == 2)
        )
      ),
    );
  }
}