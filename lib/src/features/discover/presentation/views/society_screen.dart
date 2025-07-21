import 'package:amptive/src/shared/blurred_header.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:amptive/src/features/discover/presentation/widgets/society_events_tab_view.dart';
import 'package:amptive/src/features/discover/presentation/widgets/society_shows_tab_view.dart';
import 'package:amptive/src/features/discover/presentation/widgets/society_tabs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/utils/colors.dart';
import '../widgets/society_all_tab_view.dart';

class DiscoverSocietyScreen extends StatelessWidget {
  const DiscoverSocietyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      statusBarColor: ATColors.trsprnt,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: BlocProvider<BlurredHeaderBloc>(
            create: (_) => BlurredHeaderBloc(),
            child: Builder(
              builder: (BuildContext blocContext) {
                final TabController tabController = DefaultTabController.of(blocContext);
                return NotificationListener<ScrollNotification>(
                  onNotification: blocContext.read<BlurredHeaderBloc>().onScrollNotification,
                  child: NestedScrollView(
                    physics: const BouncingScrollPhysics(),
                    headerSliverBuilder: (_, __) =>  <Widget>[
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: ATSliverHDelegate(
                          maxExt: kToolbarHeight + MediaQuery.paddingOf(context).top,
                          minExt: kToolbarHeight + MediaQuery.paddingOf(context).top,
                          child: ATBlurredHeaderWidget(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: ATRoundedBackBtn(bgColor: ATColors.trsprnt,),
                                ),
                                Text(
                                  ATStrings.SOCIETY,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: InkWell(
                                    onTap: (){},
                                    child: const Icon(Icons.add)
                                  ),
                                ),
                              ],
                            ),
                          )
                        ),
                      ),
        
                      SliverPersistentHeader(
                        floating: true,
                        delegate: ATSliverHDelegate(
                          minExt: 60, maxExt: 60,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: SocietyTabsWidget(),
                          )
                        ),
                      ),
                    ],
        
                    body: TabBarView(
                      controller: tabController,
                      physics: const BouncingScrollPhysics(),
                      children: const <Widget>[
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: SocietyAllTabView(),
                        ),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: SocietyShowsTabView()
                        ),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: SocietyEventsTabView(),
                        ),
                      ]
                    ),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}