import 'package:amptive/src/bloc/main_app/nav_bar_bloc.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/discover/discover_home.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/go_live_view/go_live_audience_view.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/dashboard_nav_bar_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/main_home_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/go_live_service/go_live_service.dart';
import 'sub_views/go_live_view/go_live_cohost_view.dart';
import 'sub_views/go_live_view/go_live_host_view.dart';


class AmptiveDashboardScreen extends StatelessWidget {
  const AmptiveDashboardScreen({super.key});

  @override
  Widget build(context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        body: BlocBuilder<AmptiveNavBarBloc, int>(
          builder: (_, index) {
            return IndexedStack(
              index: index,
              children: [
                const AmptiveHomeViewWidget(),
                const AmptiveDiscoverViewWidget(),
                AmptiveGoLiveAudienceView(goLiveHost: getHostList().first),
                //const AmptiveGoLiveCohostView(),
                AmptiveGoLiveHostView(goLiveHost: getHostList().first),
                //Container(color: Colors.green,),
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