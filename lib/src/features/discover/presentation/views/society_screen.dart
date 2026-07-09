import 'dart:async';
import 'package:amptive/src/features/main_app_nav_bar.dart';

import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/discover/data/community_membership_controller.dart';
import 'package:amptive/src/features/home/cubits/home_feed_cubit.dart';
import 'package:amptive/src/shared/blurred_header.dart';
import 'package:amptive/src/shared/refresh_indicator.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/dialogs/added_or_removed_from_calender_dialog.dart';
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

class DiscoverSocietyScreen extends StatefulWidget {
  const DiscoverSocietyScreen({
    super.key,
    this.communityId,
    this.communityName,
  });
  final String? communityId;
  final String? communityName;

  @override
  State<DiscoverSocietyScreen> createState() => _DiscoverSocietyScreenState();
}

class _DiscoverSocietyScreenState extends State<DiscoverSocietyScreen> {
  final CommunityMembershipController _membership =
      CommunityMembershipController.instance;

  bool get _isFollowing =>
      widget.communityId != null &&
      _membership.isFollowing(widget.communityId!);
  bool get _isMembershipPending =>
      widget.communityId != null && _membership.isPending(widget.communityId!);

  String get _communityName => widget.communityName?.trim().isNotEmpty == true
      ? widget.communityName!
      : ATStrings.society;

  @override
  void initState() {
    super.initState();
    _membership.addListener(_onMembershipChanged);
    _membership.load();

    // Cached feed shows instantly on re-visits; only the very first
    // community open in a session downloads from scratch. Re-visits
    // refresh quietly in the background.
    if (communityFeedCubit.currentHomeFeedData?.homeFeedItems?.isEmpty ??
        true) {
      communityFeedCubit.fetchHomeFeed();
    } else {
      communityFeedCubit.refreshHomeFeed();
    }
  }

  void _onMembershipChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _toggleFollowing() async {
    final String? communityId = widget.communityId;
    if (communityId == null || _membership.isPending(communityId)) return;
    final bool willFollow = !_membership.isFollowing(communityId);

    // Optimistic: confirm immediately instead of waiting seconds for the
    // server. The membership controller flips state right away and rolls
    // itself back if the request ends up failing.
    unawaited(showCommunityFollowSnackbar(
      context: context,
      communityName: _communityName,
      isFollowing: willFollow,
    ));

    final bool succeeded = await _membership.toggle(communityId);
    if (!mounted || succeeded) return;
    showAppNotification2(
      context: context,
      text:
          "Couldn't ${willFollow ? 'follow' : 'unfollow'} $_communityName. Please try again.",
      type: NotificationType.failure,
    );
  }

  @override
  void dispose() {
    _membership.removeListener(_onMembershipChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: DefaultTabController(
        length: 3,
        child: MultiBlocProvider(
          providers: <SingleChildWidget>[
            BlocProvider<HomeFeedCubit>.value(value: communityFeedCubit),
          ],
          child: Scaffold(
            // Same as the dashboard: keeps the safe-area padding inside the
            // bottom menu so its height matches everywhere.
            resizeToAvoidBottomInset: false,
            bottomSheet: const AppBottomMenu(),
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
                            rebuild: true,
                            maxExt: kToolbarHeight +
                                MediaQuery.paddingOf(context).top,
                            minExt: kToolbarHeight +
                                MediaQuery.paddingOf(context).top,
                            // No backing color — like the main community
                            // header: transparent at rest, frosted blur
                            // once content scrolls underneath.
                            child: ATBlurredHeaderWidget(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: ATBackBtn(
                                          alignment: Alignment.centerLeft,
                                          leadingText: _communityName,
                                          leadingStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: ATSizes.size23,
                                                letterSpacing: -0.39,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child: IconButton(
                                        onPressed: _isMembershipPending
                                            ? null
                                            : _toggleFollowing,
                                        tooltip: _isFollowing
                                            ? 'Unfollow community'
                                            : 'Follow community',
                                        iconSize: 27,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          minWidth: 44,
                                          minHeight: 44,
                                        ),
                                        splashRadius: 22,
                                        icon: AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 180),
                                          switchInCurve: Curves.easeOutBack,
                                          switchOutCurve: Curves.easeIn,
                                          transitionBuilder: (Widget child,
                                                  Animation<double>
                                                      animation) =>
                                              ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          ),
                                          child: Icon(
                                            _isFollowing
                                                ? Icons.check_rounded
                                                : Icons.add,
                                            key: ValueKey<bool>(_isFollowing),
                                          ),
                                        ),
                                      ),
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
                            // Matches the page background — an off-black
                            // here reads as a grey slab behind the pills.
                            child: ColoredBox(
                              color: ATColors.black,
                              child: const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: SocietyTabsWidget(),
                              ),
                            )),
                      ),
                    ],
                    body: TabBarView(
                        controller: tabController,
                        physics: const BouncingScrollPhysics(),
                        children: <Widget>[
                          // Refresh lives inside each tab (like the home
                          // feed) — wrapping the outer scroll view never
                          // triggers it.
                          ATRefreshIndicator(
                            onRefresh: () =>
                                communityFeedCubit.refreshHomeFeed(),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: SocietyAllTabView(
                                communityId: widget.communityId,
                                communityName: _communityName,
                              ),
                            ),
                          ),
                          ATRefreshIndicator(
                            onRefresh: () =>
                                communityFeedCubit.refreshHomeFeed(),
                            child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: SocietyShowsTabView(
                                  communityId: widget.communityId,
                                  communityName: _communityName,
                                )),
                          ),
                          ATRefreshIndicator(
                            onRefresh: () =>
                                communityFeedCubit.refreshHomeFeed(),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: SocietyEventsTabView(
                                communityId: widget.communityId,
                                communityName: _communityName,
                              ),
                            ),
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
