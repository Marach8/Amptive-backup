import 'package:amptive/src/views/screens/main_application_screens/sub_views/discover/discover_home.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/dashboar_nav_bar_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/home_view_widget.dart';
import 'package:flutter/material.dart';



class AmptiveDashboardScreen extends StatefulWidget {
  const AmptiveDashboardScreen({super.key});

  @override
  State<AmptiveDashboardScreen> createState() => _AmptiveDashboardScreenState();
}

class _AmptiveDashboardScreenState extends State<AmptiveDashboardScreen> {
  late PageController _pageController;
  late ValueNotifier<int> _pageIndexNotifier;

  @override
  void initState(){
    super.initState();
    _pageController = PageController();
    _pageIndexNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose(){
    _pageController.dispose();
    _pageIndexNotifier.dispose();
    super.dispose();
  }

  final _listOfPages = [
    const AmptiveHomeViewWidget(),
    const AmptiveDiscoverView(),
    Container(color: Colors.blue,),
    Container(color: Colors.green,),
  ];


  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) => _pageIndexNotifier.value = index,
          children: _listOfPages
        ),

        bottomNavigationBar: AmptiveDashboardBottomNavBarWidget(
          pageIndexNotifier: _pageIndexNotifier,
          pageController: _pageController
        )
      ),
    );
  }
}