import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dominant_color_extractor.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/features/episodes/cubits/episodes_of_a_show_cubit.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/episodes_response_model.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/blurred_header.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/mesh_gradient_background.dart';
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// What the scheduled-episodes route receives: the show whose episodes to list
/// plus its cover (used to tint the mesh background like the show modal).
class ScheduledEpisodesArgs {
  const ScheduledEpisodesArgs({
    required this.showId,
    this.coverUrl,
    this.showTitle,
    this.showHost,
    this.showCommunity,
  });

  final String showId;
  final String? coverUrl;
  final String? showTitle;
  final Host? showHost;
  final Community? showCommunity;
}

class ScheduledEpisodesScreen extends StatelessWidget {
  const ScheduledEpisodesScreen({
    super.key,
    required this.showId,
    this.coverUrl,
    this.showTitle,
    this.showHost,
    this.showCommunity,
  });

  final String showId;
  final String? coverUrl;
  final String? showTitle;
  final Host? showHost;
  final Community? showCommunity;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<EpisodesOfAShowCubit>(
          create: (_) => EpisodesOfAShowCubit(showId: showId)..refresh(),
        ),
        BlocProvider<BlurredHeaderCubit>(create: (_) => BlurredHeaderCubit()),
        BlocProvider<DominantColorCubit>(
          create: (_) => DominantColorCubit()
            ..extractColor(coverUrl ?? ATImgStrings.createShowPlaceholder),
        ),
      ],
      child: _ScheduledEpisodesView(
        showId: showId,
        showTitle: showTitle,
        showHost: showHost,
        showCommunity: showCommunity,
      ),
    );
  }
}

class _ScheduledEpisodesView extends StatefulWidget {
  const _ScheduledEpisodesView({
    required this.showId,
    this.showTitle,
    this.showHost,
    this.showCommunity,
  });

  final String showId;
  final String? showTitle;
  final Host? showHost;
  final Community? showCommunity;

  @override
  State<_ScheduledEpisodesView> createState() => _ScheduledEpisodesViewState();
}

class _ScheduledEpisodesViewState extends State<_ScheduledEpisodesView> {
  int _tabIndex = 0; // 0 = Upcoming, 1 = Past
  final PageController _pageController = PageController();

  static const Set<String> _pastStatuses = <String>{
    'ended',
    'past',
    'aired',
    'completed',
  };

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectTab(int index) {
    if (index == _tabIndex) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight =
        kToolbarHeight + MediaQuery.paddingOf(context).top;

    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: BlocBuilder<DominantColorCubit, DominantColorState>(
          builder: (_, DominantColorState colorState) {
            return ATMeshGradientBackground(
              state: colorState,
              child: NotificationListener<ScrollNotification>(
                onNotification:
                    context.read<BlurredHeaderCubit>().onScrollNotification,
                child: NestedScrollView(
                  headerSliverBuilder: (_, __) => <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: ATSliverHDelegate(
                        maxExt: blurredHeaderHeight,
                        minExt: blurredHeaderHeight,
                        child: ATBlurredHeaderWidget(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(left: 7),
                                child: ATBackBtn(),
                              ),
                              Text(
                                'Episodes',
                                style: context.textTheme.bodyMedium,
                              ),
                              const SizedBox(width: 44),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      _TabsBar(
                        selectedIndex: _tabIndex,
                        onChanged: _selectTab,
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (int i) =>
                              setState(() => _tabIndex = i),
                          children: <Widget>[
                            _EpisodesList(
                              isPast: false,
                              pastStatuses: _pastStatuses,
                              showId: widget.showId,
                              showTitle: widget.showTitle,
                              showHost: widget.showHost,
                              showCommunity: widget.showCommunity,
                            ),
                            _EpisodesList(
                              isPast: true,
                              pastStatuses: _pastStatuses,
                              showId: widget.showId,
                              showTitle: widget.showTitle,
                              showHost: widget.showHost,
                              showCommunity: widget.showCommunity,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TabsBar extends StatelessWidget {
  const _TabsBar({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const List<String> _labels = <String>['Upcoming', 'Past'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: _labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, int index) {
          final bool isSelected = selectedIndex == index;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(index),
            child: ATContainer(
              radius: 20,
              duration: 120,
              curve: Curves.easeOutCubic,
              color: isSelected
                  ? ATColors.white
                  : ATColors.hex9E9E9E.withValues(alpha: 0.3),
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
              child: Center(
                child: Text(
                  _labels[index],
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isSelected ? ATColors.hex0D0D0D : ATColors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EpisodesList extends StatelessWidget {
  const _EpisodesList({
    required this.isPast,
    required this.pastStatuses,
    required this.showId,
    this.showTitle,
    this.showHost,
    this.showCommunity,
  });

  final bool isPast;
  final Set<String> pastStatuses;
  final String showId;
  final String? showTitle;
  final Host? showHost;
  final Community? showCommunity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EpisodesOfAShowCubit, ATAppState<EpisodesResponseModel>>(
      builder: (BuildContext context, ATAppState<EpisodesResponseModel> state) {
        final List<Episode> all = context
                .read<EpisodesOfAShowCubit>()
                .currentEpisodesData
                ?.episodes ??
            <Episode>[];

        final List<Episode> items = all.where((Episode e) {
          final String status = (e.status ?? '').toLowerCase();
          return isPast ? pastStatuses.contains(status) : status == 'scheduled';
        }).toList();

        if (items.isEmpty) {
          if (state is LoadingState<EpisodesResponseModel>) {
            return const Center(
              child:
                  CupertinoActivityIndicator(radius: 14, color: Colors.white),
            );
          }
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isPast
                      ? 'No past episodes yet.'
                      : 'No upcoming episodes yet.',
                  style: context.textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  isPast
                      ? 'Episodes that have aired will appear here.'
                      : 'Episodes you schedule for this show will appear here.',
                  style: context.textTheme.labelSmall
                      ?.copyWith(fontSize: 14, color: ATColors.hexC2C2C2),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(15, 6, 15, 40),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (_, int index) => _ScheduledEpisodeTile(
            episode: items[index],
            showId: showId,
            showTitle: showTitle,
            showHost: showHost,
            showCommunity: showCommunity,
          ),
        );
      },
    );
  }
}

class _ScheduledEpisodeTile extends StatelessWidget {
  const _ScheduledEpisodeTile({
    required this.episode,
    required this.showId,
    this.showTitle,
    this.showHost,
    this.showCommunity,
  });

  final Episode episode;
  final String showId;
  final String? showTitle;
  final Host? showHost;
  final Community? showCommunity;

  String get _whenLabel {
    final DateTime? when = DateTime.tryParse(episode.scheduledFor ?? '');
    if (when == null) return 'Scheduled';
    return DateFormat('EEE, d MMM • h:mm a').format(when.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // Opens the same styled modal as the homepage feed cards. The wrapper
      // fetches the full episode so host/description show correctly.
      onTap: () async {
        await context.pushNamed(
          ATRoutes.episodeScheduleDetail,
          // The list endpoint omits show_id, so stamp the screen's show id on so
          // the modal can fetch the full episode (host, description, etc.).
          extra: episode.copyWith(
            showId: episode.showId ?? showId,
            parentShowTitle: episode.parentShowTitle ?? showTitle,
            // Seed the show's host + community so they show immediately (no
            // "Society" flash); the fetch then fills in co-hosts and the rest.
            host: episode.host ?? showHost,
            community: episode.community ?? showCommunity,
          ),
        );
        // Coming back from the modal — an edit may have happened, so refresh
        // the list (the edit invalidated the cache).
        if (context.mounted) {
          await context.read<EpisodesOfAShowCubit>().refresh();
        }
      },
      child: Row(
        children: <Widget>[
          ClipSmoothRect(
            radius: SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 0.8),
            child: ATImgLoader(
              imgPath: episode.thumbnailUrl ?? '',
              width: 80,
              height: 80,
              boxFit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  episode.title ?? 'Untitled episode',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    Icon(CupertinoIcons.calendar,
                        size: 14, color: ATColors.hexC2C2C2),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        _whenLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: ATColors.hexC2C2C2,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
