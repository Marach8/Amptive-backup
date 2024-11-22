import 'package:amptive/src/views/screens/main_application_screens/sub_views/discover/discover_home.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/dashboard_nav_bar_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/main_home_view_widget.dart';
import 'package:flutter/material.dart';


class AmptiveDashboardScreen extends StatefulWidget {
  const AmptiveDashboardScreen({super.key});

  @override
  State<AmptiveDashboardScreen> createState() => _AmptiveDashboardScreenState();
}

class _AmptiveDashboardScreenState extends State<AmptiveDashboardScreen> {
  late ValueNotifier<int> _pageIndexNotifier;

  @override
  void initState(){
    super.initState();
    _pageIndexNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose(){
    _pageIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        body: AmptiveRebuilderWidget(
          notifier: _pageIndexNotifier,
          builder: (_, value, __) {
            return IndexedStack(
              index: value,
              children: [
                const AmptiveHomeViewWidget(),
                const AmptiveDiscoverViewWidget(),
                Container(color: Colors.blue,),
                Container(color: Colors.green,),
              ]
            );
          }
        ),

        bottomNavigationBar: AmptiveDashboardBottomNavBarWidget(
          pageIndexNotifier: _pageIndexNotifier,
        )
      ),
    );
  }
}