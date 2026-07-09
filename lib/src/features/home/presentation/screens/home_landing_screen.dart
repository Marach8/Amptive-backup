import 'dart:async';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/features/home/cubits/home_feed_cubit.dart';
import 'package:amptive/src/features/home/cubits/live_users_cubit.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/home/presentation/widgets/render_home_feed_item.dart';
import 'package:amptive/src/features/home/presentation/widgets/row_of_live_users.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/circular_image.dart';
import '../../../../shared/divider_widget.dart';
import '../../../../shared/image_loader_widget.dart';
import '../widgets/appbar_drop_down.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({
    super.key,
    required this.nestedKey,
    required this.liveUsersScrollController,
  });

  final ScrollController liveUsersScrollController;
  final GlobalKey<NestedScrollViewState> nestedKey;

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView>
    with TickerProviderStateMixin {
  bool _isSnappingHeader = false;
  Timer? _snapTimer;

  @override
  void dispose() {
    _snapTimer?.cancel();
    super.dispose();
  }

  void _scheduleSnap() {
    _snapTimer?.cancel();
    _snapTimer = Timer(const Duration(milliseconds: 50), () {
      if (mounted) _settleHeader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notif) {
        context.read<ATNavBarBloc>().ctrlNavVisibility(notif);

        if (notif.metrics.axis == Axis.vertical) {
          // Pagination: fetch more when within 200 pixels of the bottom of the inner feed
          if (notif.depth == 1 &&
              notif.metrics.maxScrollExtent > 0 &&
              notif.metrics.pixels >= notif.metrics.maxScrollExtent - 200) {
            context.read<HomeFeedCubit>().fetchHomeFeed();
          }

          if (notif is ScrollStartNotification ||
              notif is ScrollUpdateNotification) {
            _snapTimer?.cancel();
          } else if (notif is ScrollEndNotification) {
            _scheduleSnap();
          }
        }
        return false;
      },
      child: NestedScrollView(
        floatHeaderSlivers: true,
        key: widget.nestedKey,
        headerSliverBuilder: (_, __) => <Widget>[
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: _HomeTopHeaderDelegate(
              statusBarHeight: MediaQuery.of(context).padding.top,
              vsync: this,
            ),
          ),
        ],
        body: BlocConsumer<HomeFeedCubit, ATAppState<HomeFeedResponseModel>>(
            listener: (_, ATAppState<HomeFeedResponseModel> state) {
          if (state is FailureState<HomeFeedResponseModel>) {
            showAppNotification2(
              context: context,
              text: state.message,
              type: NotificationType.failure,
            );
          }
        }, builder: (_, ATAppState<HomeFeedResponseModel> state) {
          return switch (state) {
            InitialState<HomeFeedResponseModel>() => const SizedBox.shrink(),
            LoadingState<HomeFeedResponseModel>() ||
            FailureState<HomeFeedResponseModel>() ||
            SuccessState<HomeFeedResponseModel>() =>
              Builder(builder: (_) {
                final HomeFeedResponseModel? homeFeedData =
                    context.read<HomeFeedCubit>().currentHomeFeedData;
                final List<HomeFeedItem> homeFeedItems =
                    homeFeedData?.homeFeedItems?.toList() ?? <HomeFeedItem>[];

                // INJECT HARDCODED DEBUG CARD AT THE TOP
                homeFeedItems.insert(
                  0,
                  HomeFeedItem(
                    id: 'fake_debug_card',
                    title: 'Don’t Forget Who You Are ft. Jacob Scipio.',
                    contentType: 'episode',
                    status: 'live',
                    hostName: 'glennondoyle',
                    hostProfileImageUrl:
                        'assets/images/png_images/center_avatar.png',
                    coverUrl: 'assets/images/jpeg_images/weCanDoAllThings.jpg',
                    thumbnailUrl:
                        'assets/images/jpeg_images/weCanDoAllThings.jpg',
                    viewerCount: 1243,
                    coHostCount: 2,
                    showType: 'paid',
                    showTitle: 'We Can Do Hard Things',
                    tags: const <HashTag>[
                      HashTag(name: 'SelfDiscovery'),
                      HashTag(name: 'Relationships'),
                      HashTag(name: 'Inspiration'),
                      HashTag(name: 'Podcast'),
                    ],
                    avatarUrls: <String>[
                      'assets/images/png_images/dummy_avatar_a.png',
                      'assets/images/png_images/dummy_avatar_b.png',
                      'assets/images/png_images/dummy_avatar_c.png',
                    ],
                    description: 'Jessica Yellin, founder of the Webby-Award Winning Independent News Brand, News Not Noise, returns to walk us through what is going on right now in the political landscape.',
                  ),
                );

                if (homeFeedItems.isEmpty) {
                  if (state is LoadingState<HomeFeedResponseModel>) {
                    return const _InitialLoadingShimmer();
                  }
                  if (state is FailureState<HomeFeedResponseModel>) {
                    return _EmptyHomeFeedState(
                      child: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () =>
                            context.read<HomeFeedCubit>().fetchHomeFeed(),
                      ),
                    );
                  }
                  return const _EmptyHomeFeedState(
                    child: Text('No feed items available'),
                  );
                }

                final bool hasMore = homeFeedData?.hasMore ?? false;
                final int count = homeFeedItems.length;

                return CustomRefreshIndicator(
                  offsetToArmed: 60,
                  onRefresh: () async {
                    context.read<LiveUsersCubit>().refreshLiveUsers();
                    await context.read<HomeFeedCubit>().refreshHomeFeed();
                  },
                  builder: (BuildContext context, Widget child,
                      IndicatorController controller) {
                    final bool isSpinning =
                        controller.isLoading || controller.isFinalizing;
                    return Stack(
                      children: <Widget>[
                        if (!controller.isIdle)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 60.0 * controller.value,
                            child: Center(
                              child: isSpinning
                                  ? CupertinoActivityIndicator(
                                      radius: 14,
                                      color: ATColors.white,
                                    )
                                  : CupertinoActivityIndicator
                                      .partiallyRevealed(
                                      progress:
                                          controller.value.clamp(0.0, 1.0),
                                      radius: 14,
                                      color: ATColors.white,
                                    ),
                            ),
                          ),
                        Transform.translate(
                          offset: Offset(0, 60.0 * controller.value),
                          child: child,
                        ),
                      ],
                    );
                  },
                  child: ListView.separated(
                      separatorBuilder: (_, int index) => index == 0
                          ? const SizedBox.shrink()
                          : const SizedBox(height: 30),
                      itemCount: count +
                          2, // 1 for top section, 1 for bottom loader/indicator
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 120),
                      itemBuilder: (_, int index) {
                        if (index == 0) {
                          return const _HomeFeedTopSection();
                        }
                        final int feedIndex = index - 1;
                        if (feedIndex < count) {
                          final HomeFeedItem homeFeedItem =
                              homeFeedItems[feedIndex];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: MultiBlocProvider(
                              providers: <SingleChildWidget>[
                                BlocProvider<ToggleFollowingCubit>(
                                    create: (_) => ToggleFollowingCubit(
                                          initialStatus: FollowingStatus(
                                              isFollowing: homeFeedItem
                                                  .requesterFollowsHost,
                                              followerCount:
                                                  homeFeedItem.goingCount),
                                        ))
                              ],
                              child: RenderHomeFeedItem(
                                homeFeedItem: homeFeedItem,
                                isFirstCard: feedIndex == 0,
                              ),
                            ),
                          );
                        }
                        if (state is LoadingState<HomeFeedResponseModel>) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: CupertinoActivityIndicator(
                                radius: 14,
                                color: ATColors.white,
                              ),
                            ),
                          );
                        } else if (!hasMore) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: Text(
                                "You've caught up on all events",
                                style: TextStyle(
                                  color: ATColors.white.withValues(alpha: 0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox(height: 50);
                      }),
                );
              })
          };
        }),
      ),
    );
  }

  void _settleHeader() {
    if (_isSnappingHeader) return;

    final ScrollController? outerController =
        widget.nestedKey.currentState?.outerController;
    if (outerController == null || !outerController.hasClients) return;

    final ScrollController? innerController =
        widget.nestedKey.currentState?.innerController;

    // Abort if the user is scrolled down deep into the feed list.
    // We only want to snap if they are at the absolute top of the feed (offset == 0).
    if (innerController != null && innerController.hasClients) {
      if (innerController.offset > 0.0) {
        return;
      }
    }

    if (outerController.position.isScrollingNotifier.value) return;

    final double offset = outerController.offset;
    if (offset <= 0 || offset >= kToolbarHeight) return;

    final double target = kToolbarHeight;
    _isSnappingHeader = true;
    outerController
        .animateTo(
      target,
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
    )
        .whenComplete(() {
      _isSnappingHeader = false;
    });
  }
}

class _HomeTopHeaderDelegate extends SliverPersistentHeaderDelegate {
  _HomeTopHeaderDelegate({
    required this.statusBarHeight,
    required this.vsync,
  });

  final double statusBarHeight;

  // Required by the floating-header snap animation.
  @override
  final TickerProvider vsync;

  static const double _toolbarHeight = kToolbarHeight;

  @override
  double get minExtent => statusBarHeight;

  @override
  double get maxExtent => statusBarHeight + _toolbarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double toolbarProgress =
        (shrinkOffset / _toolbarHeight).clamp(0.0, 1.0);
    final double opacity = (1.0 - (shrinkOffset / 35)).clamp(0.0, 1.0);
    final double toolbarTop = statusBarHeight - (toolbarProgress * 35);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: ColoredBox(
        color: ATColors.black,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: <Widget>[
            Positioned(
              top: toolbarTop,
              left: 0,
              right: 0,
              height: _toolbarHeight,
              child: Opacity(
                opacity: opacity,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ATHomeDropDown(
                        offset: const Offset(0, 56),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 18.0, bottom: 6.0, left: 8.0, right: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const ATImgLoader(
                                imgPath: ATImgStrings.amptiveNameLogo,
                                height: 23,
                                width: 94,
                              ),
                              const SizedBox(width: 4.0),
                              const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        liveProgramOverlayKey.currentState?.maximize();
                      },
                      behavior: HitTestBehavior
                          .opaque, // Ensures the entire padding area registers taps
                      child: Padding(
                        padding: const EdgeInsets.all(
                            8.0), // Adds 16px to 30px icon = 46x46 touch target (exceeds Apple HIG standard)
                        child: Stack(
                          children: <Widget>[
                            const ATImgLoader(
                              imgPath: ATImgStrings.walletIcon,
                              height: 30,
                              width: 30,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: const Color(
                                      0xFFFF3B30), // Standard iOS notification red
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ATColors
                                        .black, // Matches background to create a 'cut out' effect
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                        width:
                            8), // Reduced from 24 to compensate for the 8px padding on both sides (8+8+8 = 24)
                    GestureDetector(
                      onTap: () =>
                          context.pushNamed(ATRoutes.creatorProfileScreen),
                      behavior: HitTestBehavior
                          .opaque, // Ensures the entire padding area registers taps
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 8.0, bottom: 8.0, right: 15.0),
                        child: BlocBuilder<LocalUserDataCubit,
                            ATAppState<CachedUserData>>(
                          builder: (_, ATAppState<CachedUserData> state) {
                            final CachedUserData? userData = context
                                .read<LocalUserDataCubit>()
                                .currentUserData;
                            return ATCircularImage(
                              imagePath: userData?.pictureUrl ?? '',
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _HomeTopHeaderDelegate oldDelegate) {
    return statusBarHeight != oldDelegate.statusBarHeight;
  }

  // Flutter's built-in floating header snap — fires when the user releases
  // mid-collapse, including after a fling settles, so the header always ends
  // up either fully visible or fully hidden; never stuck halfway.
  @override
  FloatingHeaderSnapConfiguration get snapConfiguration =>
      FloatingHeaderSnapConfiguration(
        curve: Curves.easeOutCubic,
        duration: const Duration(milliseconds: 200),
      );
}

class _HomeFeedTopSection extends StatelessWidget {
  const _HomeFeedTopSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RowOfLiveUsers(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: ATDivider(),
        ),
      ],
    );
  }
}

class _EmptyHomeFeedState extends StatelessWidget {
  const _EmptyHomeFeedState({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const _HomeFeedTopSection(),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.25,
          child: Center(child: child),
        ),
      ],
    );
  }
}

class _InitialLoadingShimmer extends StatelessWidget {
  const _InitialLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, int index) =>
          index == 0 ? const SizedBox.shrink() : const SizedBox(height: 30),
      itemCount: 6,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 120),
      itemBuilder: (_, int index) {
        if (index == 0) {
          return const _HomeFeedTopSection();
        }
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: RenderHomeFeedItemShimmer(),
        );
      },
    );
  }
}
