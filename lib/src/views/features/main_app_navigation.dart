import 'package:amptive/src/bloc/main_app/nav_bar_bloc.dart';
import 'package:amptive/src/views/features/discover/presentation/views/discover_landing_screen.dart';
import 'package:amptive/src/views/features/live_programs/presentation/views/live_audience_view.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_slide.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/dashboard_nav_bar_widget.dart';
import 'package:amptive/src/views/features/home/presentation/views/home_landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/go_live_service/go_live_service.dart';
import 'notifications/presentation/views/notif_landing_screen.dart';


class AmptiveDashboardScreen extends StatelessWidget {
  const AmptiveDashboardScreen({super.key});

  @override
  Widget build(context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: BlocSelector<ATNavBarBloc, (int, bool), int>(
          selector: (st) => st.$1,
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

        bottomSheet: BlocBuilder<ATNavBarBloc, (int, bool)>(
          builder: (_, state) {
            return ATAnimatedSlide(
              condition: state.$2,
              endOffset: const Offset(0, 1.5),
              startOffset: const Offset(0, 0),
              child: const MainAppBottomNav()
            );
          },
        )
      ),
    );
  }
}


class ATNavBarBloc extends Cubit<(int, bool)>{
  ATNavBarBloc(): super((0, true));

  bool ctrlNavVisibility(ScrollNotification notif){
    if (notif is ScrollUpdateNotification) {
      if (notif.dragDetails != null) {

        if (notif.dragDetails!.delta.dy > 0) {
          emit((state.$1, true));
        } 
        else if (notif.dragDetails!.delta.dy < 0) {
          emit((state.$1, false));
        }
      } 
    }

    return true;
  }
  void goToPage(int index){
    if(index == 2){
      emit((index, false));
    }
    else{
      emit((index, state.$2));
    }
  }
}