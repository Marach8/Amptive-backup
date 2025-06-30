import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_back_arrow_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/society_widgets/society_events_tab_view.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/society_widgets/society_shows_tab_view.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/society_widgets/society_sliver_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/society_widgets/society_all_tab_view_widget.dart';

class DiscoverSocietyScreen extends StatefulWidget {
  const DiscoverSocietyScreen({super.key});

  @override
  State<DiscoverSocietyScreen> createState() => _DiscoverSocietyScreenState();
}

class _DiscoverSocietyScreenState extends State<DiscoverSocietyScreen> 
with SingleTickerProviderStateMixin{
  late TabController _tabController;
  late ValueNotifier<int> _isTabSelected;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _isTabSelected = ValueNotifier(0);
    
    _tabController.addListener(
      () => _isTabSelected.value = _tabController.index
    );
  }

  @override 
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (_, __) => [
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: true,
                centerTitle: true,
                actions: [
                  GestureDetector(
                    onTap: (){},
                    child: const Icon(Icons.add)
                  ),
                  const Gap(15)
                ],
                leading: const AmptiveBackArrowWidget(),
                title: Text(
                  ATStrings.SOCIETY,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: AmptiveSocietySliverHeader(
                  tabController: _tabController,
                  notifier: _isTabSelected
                )
              ),
              
            ],
            body: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: const [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: AmptiveDiscoverSocietyAllTabViewWidget(),
                ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: AmptiveDiscoverSocietyShowsTabViewWidget()
                ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: AmptiveDiscoverSocietyEventsTabViewWidget(),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}