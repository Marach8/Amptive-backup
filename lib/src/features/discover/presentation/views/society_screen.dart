import 'package:amptive/src/features/events/cubits/hosted_events_cubit.dart';
import 'package:amptive/src/features/home/cubits/followed_shows_cubit.dart';
import 'package:amptive/src/features/shows/cubits/hosted_shows_cubit.dart';
import 'package:amptive/src/shared/blurred_header.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:amptive/src/features/discover/presentation/widgets/society_events_tab_view.dart';
import 'package:amptive/src/features/discover/presentation/widgets/society_shows_tab_view.dart';
import 'package:amptive/src/features/discover/presentation/widgets/society_tabs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import '../../../../config/utils/colors.dart';
import '../widgets/society_all_tab_view.dart';

class DiscoverSocietyScreen extends StatelessWidget {
  const DiscoverSocietyScreen({super.key, this.communityId});
  final String? communityId;

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: DefaultTabController(
        length: 3,
        child: MultiBlocProvider(
          providers: <SingleChildWidget>[
            BlocProvider<HostedShowsCubit>(
              create: (_) => HostedShowsCubit()..fetchHostedShows(),
            ),
            BlocProvider<HostedEventsCubit>(
              create: (_) => HostedEventsCubit()..fetchHostedEvents(),
            ),
          ],
          child: Scaffold(
            body: BlocProvider<BlurredHeaderCubit>(
              create: (_) => BlurredHeaderCubit(),
              child: Builder(builder: (BuildContext blocContext) {
                final TabController tabController =
                    DefaultTabController.of(blocContext);
                return NotificationListener<ScrollNotification>(
                  onNotification: blocContext
                      .read<BlurredHeaderCubit>()
                      .onScrollNotification,
                  child: NestedScrollView(
                    physics: const BouncingScrollPhysics(),
                    headerSliverBuilder: (_, __) => <Widget>[
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: ATSliverHDelegate(
                            maxExt: kToolbarHeight +
                                MediaQuery.paddingOf(context).top,
                            minExt: kToolbarHeight +
                                MediaQuery.paddingOf(context).top,
                            child: ATBlurredHeaderWidget(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: ATRoundedBackBtn(
                                      bgColor: ATColors.transparent,
                                    ),
                                  ),
                                  Text(
                                    ATStrings.society,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: InkWell(
                                        onTap: () {},
                                        child: const Icon(Icons.add)),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      SliverPersistentHeader(
                        floating: true,
                        delegate: ATSliverHDelegate(
                            minExt: 60,
                            maxExt: 60,
                            child: const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: SocietyTabsWidget(),
                            )),
                      ),
                    ],
                    body: TabBarView(
                        controller: tabController,
                        physics: const BouncingScrollPhysics(),
                        children: <Widget>[
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: SocietyAllTabView(communityId: communityId),
                          ),
                          SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: SocietyShowsTabView(
                                  communityId: communityId)),
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child:
                                SocietyEventsTabView(communityId: communityId),
                          ),
                        ]),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
