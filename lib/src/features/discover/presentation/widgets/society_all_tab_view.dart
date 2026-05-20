import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/discover/presentation/views/discover_page_view.dart';
import 'package:amptive/src/features/events/cubits/hosted_events_cubit.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/features/home/cubits/followed_shows_cubit.dart';
import 'package:amptive/src/features/shows/cubits/hosted_shows_cubit.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/utils/image_strings.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../shared/custom_container_widget.dart';
import 'top_creator_widget.dart';
import 'render_trending_hashtag.dart';
import 'hashtag_heading_row.dart';

class SocietyAllTabView extends StatelessWidget {
  const SocietyAllTabView({super.key, this.communityId});
  final String? communityId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // ==================== TRENDING ====================
        HastagHeadingRow(
          title: ATStrings.TRENDING,
          viewAllOnpressed: () =>
              context.pushNamed(ATRoutes.TRENDING_SOCIETY_SCREEN),
        ),
        const SizedBox(height: 10),

        BlocBuilder<HostedShowsCubit, ATAppState<HostedShowsResponseModel>>(
          builder: (_, ATAppState<HostedShowsResponseModel> state) {
            return switch (state) {
              InitialState<HostedShowsResponseModel>() =>
                const SizedBox.shrink(),
              LoadingState<HostedShowsResponseModel>() ||
              FailureState<HostedShowsResponseModel>() ||
              SuccessState<HostedShowsResponseModel>() =>
                Builder(builder: (_) {
                  final HostedShowsResponseModel? showsData =
                      context.read<HostedShowsCubit>().currentHostedShowsData;
                  final List<HostedShow> shows =
                      showsData?.hostedShows ?? <HostedShow>[];
                  final List<HostedShow> communityShows = communityId != null
                      ? shows
                          .where((HostedShow e) =>
                              e.community?.communityId == communityId)
                          .toList()
                      : <HostedShow>[];

                  if (communityShows.isEmpty) {
                    if (state is LoadingState<HostedShowsResponseModel>) {
                      return const SizedBox(
                        height: 120,
                        child: DiscoverPageCommunitiesShimmer(),
                      );
                    }
                    if (state is FailureState<HostedShowsResponseModel>) {
                      return Center(
                        child: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => context
                              .read<HostedShowsCubit>()
                              .fetchHostedShows(),
                        ),
                      );
                    }
                    return const Text(
                        'No trending shows available in this community.');
                  }

                  return SizedBox(
                    height: 180,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: communityShows.length,
                      itemBuilder: (_, int index) => RenderTrendingHashTag(
                        trendingPicture: communityShows[index].coverUrl ??
                            ATImgStrings.weCanDoHardThingsBgImage,
                        title: communityShows[index].title,
                      ),
                    ),
                  );
                }),
            };
          },
        ),

        const SeparatorDivider(),
        const SizedBox(height: 40),

        // ==================== PAID SHOWS ====================
        HastagHeadingRow(title: ATStrings.PAID_SHOWS, viewAllOnpressed: () {}),
        const SizedBox(height: 10),

        BlocBuilder<HostedShowsCubit, ATAppState<HostedShowsResponseModel>>(
          builder: (_, ATAppState<HostedShowsResponseModel> state) {
            return switch (state) {
              InitialState<HostedShowsResponseModel>() =>
                const SizedBox.shrink(),
              LoadingState<HostedShowsResponseModel>() ||
              FailureState<HostedShowsResponseModel>() ||
              SuccessState<HostedShowsResponseModel>() =>
                Builder(builder: (_) {
                  final HostedShowsResponseModel? showsData =
                      context.read<HostedShowsCubit>().currentHostedShowsData;
                  final List<HostedShow> shows =
                      showsData?.hostedShows ?? <HostedShow>[];
                  final List<HostedShow> paidShows = shows
                      .where(
                        (HostedShow e) => e.showType == 'paid',
                      )
                      .toList();
                  final List<HostedShow> communityPaidShows =
                      communityId != null
                          ? paidShows
                              .where((HostedShow e) =>
                                  e.community?.communityId == communityId)
                              .toList()
                          : <HostedShow>[];

                  if (communityPaidShows.isEmpty) {
                    if (state is LoadingState<HostedShowsResponseModel>) {
                      return const SizedBox(
                          height: 120, child: DiscoverPageCommunitiesShimmer());
                    }
                    if (state is FailureState<HostedShowsResponseModel>) {
                      return Center(
                        child: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => context
                              .read<HostedShowsCubit>()
                              .fetchHostedShows(),
                        ),
                      );
                    }
                    return const Text(
                        'No paid shows available in this community.');
                  }

                  return SizedBox(
                    height: 180,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: communityPaidShows.length,
                      itemBuilder: (_, int index) => RenderTrendingHashTag(
                        trendingPicture: communityPaidShows[index].coverUrl ??
                            ATImgStrings.OFFICE_LADIES,
                        title: communityPaidShows[index].title,
                      ),
                    ),
                  );
                }),
            };
          },
        ),

        const SeparatorDivider(),
        const SizedBox(height: 40),

        // ==================== FREE SHOWS ====================
        HastagHeadingRow(title: ATStrings.FREE_SHOWS, viewAllOnpressed: () {}),
        const SizedBox(height: 10),

        BlocBuilder<HostedShowsCubit, ATAppState<HostedShowsResponseModel>>(
          builder: (_, ATAppState<HostedShowsResponseModel> state) {
            return switch (state) {
              InitialState<HostedShowsResponseModel>() =>
                const SizedBox.shrink(),
              LoadingState<HostedShowsResponseModel>() ||
              FailureState<HostedShowsResponseModel>() ||
              SuccessState<HostedShowsResponseModel>() =>
                Builder(builder: (_) {
                  final HostedShowsResponseModel? showsData =
                      context.read<HostedShowsCubit>().currentHostedShowsData;
                  final List<HostedShow> shows =
                      showsData?.hostedShows ?? <HostedShow>[];
                  final List<HostedShow> freeShows = shows
                      .where(
                        (HostedShow e) => e.showType == 'free',
                      )
                      .toList();
                  final List<HostedShow> communityFreeShows =
                      communityId != null
                          ? freeShows
                              .where((HostedShow e) =>
                                  e.community?.communityId == communityId)
                              .toList()
                          : <HostedShow>[];

                  if (communityFreeShows.isEmpty) {
                    if (state is LoadingState<HostedShowsResponseModel>) {
                      return const SizedBox(
                          height: 120, child: DiscoverPageCommunitiesShimmer());
                    }
                    if (state is FailureState<HostedShowsResponseModel>) {
                      return Center(
                        child: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => context
                              .read<HostedShowsCubit>()
                              .fetchHostedShows(),
                        ),
                      );
                    }
                    return const Text(
                        'No free shows available in this community.');
                  }

                  return SizedBox(
                    height: 180,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: communityFreeShows.length.clamp(0, 10),
                      itemBuilder: (_, int index) => RenderTrendingHashTag(
                        trendingPicture: communityFreeShows[index].coverUrl ??
                            ATImgStrings.JOE_POMP_SHOW,
                        title: communityFreeShows[index].title,
                      ),
                    ),
                  );
                }),
            };
          },
        ),

        const SeparatorDivider(),
        const SizedBox(height: 40),

        // ==================== POPULAR CREATORS ====================
        ATContainer(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: Text(ATStrings.POPULAR_CREATORS,
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (_, __) =>
                const TopCreatorWidget(picture: ATImgStrings.MAN_PHOTO),
          ),
        ),

        const SeparatorDivider(),
        const SizedBox(height: 35),

        // ==================== PAID EVENTS ====================
        HastagHeadingRow(title: ATStrings.PAID_EVENTS, viewAllOnpressed: () {}),
        const SizedBox(height: 10),

        BlocBuilder<HostedEventsCubit, ATAppState<HostedEventsResponseModel>>(
          builder: (_, ATAppState<HostedEventsResponseModel> state) {
            return switch (state) {
              InitialState<HostedEventsResponseModel>() =>
                const SizedBox.shrink(),
              LoadingState<HostedEventsResponseModel>() ||
              FailureState<HostedEventsResponseModel>() ||
              SuccessState<HostedEventsResponseModel>() =>
                Builder(builder: (_) {
                  final HostedEventsResponseModel? eventsData =
                      context.read<HostedEventsCubit>().currentHostedEventsData;

                  final List<HostedEvent> events =
                      eventsData?.hostedEvents ?? <HostedEvent>[];

                  final List<HostedEvent> paidEvents = events
                      .where(
                        (HostedEvent e) => e.showType == 'paid',
                      )
                      .toList();

                  if (paidEvents.isEmpty) {
                    if (state is LoadingState<dynamic>) {
                      return const SizedBox(
                          height: 120, child: DiscoverPageCommunitiesShimmer());
                    }
                    if (state is FailureState<dynamic>) {
                      return Center(
                        child: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => context
                              .read<HostedEventsCubit>()
                              .fetchHostedEvents(),
                        ),
                      );
                    }
                    return const Text(
                        'No paid events available in this community.');
                  }

                  return SizedBox(
                    height: 180,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: paidEvents.length,
                      itemBuilder: (_, int index) {
                        return RenderTrendingHashTag(
                          trendingPicture: paidEvents[index].coverUrl ??
                              ATImgStrings.weCanDoHardThingsBgImage,
                          title: paidEvents[index].title,
                        );
                      },
                    ),
                  );
                }),
            };
          },
        ),

        const SeparatorDivider(),
        const SizedBox(height: 35),

        // ==================== FREE EVENTS ====================
        HastagHeadingRow(title: ATStrings.FREE_EVENTS, viewAllOnpressed: () {}),
        const SizedBox(height: 10),

        BlocBuilder<HostedEventsCubit, ATAppState<HostedEventsResponseModel>>(
          builder: (_, ATAppState<HostedEventsResponseModel> state) {
            return switch (state) {
              InitialState<HostedEventsResponseModel>() =>
                const SizedBox.shrink(),
              LoadingState<HostedEventsResponseModel>() ||
              FailureState<HostedEventsResponseModel>() ||
              SuccessState<HostedEventsResponseModel>() =>
                Builder(builder: (_) {
                  final HostedEventsResponseModel? eventsData =
                      context.read<HostedEventsCubit>().currentHostedEventsData;
                  final List<HostedEvent> events =
                      eventsData?.hostedEvents ?? <HostedEvent>[];

                  final List<HostedEvent> freeEvents = events
                      .where(
                        (HostedEvent e) => e.showType == 'free',
                      )
                      .toList();

                  if (freeEvents.isEmpty) {
                    if (state is LoadingState<dynamic>) {
                      return const SizedBox(
                          height: 120, child: DiscoverPageCommunitiesShimmer());
                    }
                    if (state is FailureState<dynamic>) {
                      return Center(
                        child: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => context
                              .read<HostedEventsCubit>()
                              .fetchHostedEvents(),
                        ),
                      );
                    }
                    return const Text(
                        'No free events available in this community.');
                  }

                  return SizedBox(
                    height: 180,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: freeEvents.length,
                      itemBuilder: (_, int index) {
                        return RenderTrendingHashTag(
                          trendingPicture: freeEvents[index].coverUrl ??
                              ATImgStrings.weCanDoHardThingsBgImage,
                          title: freeEvents[index].title,
                        );
                      },
                    ),
                  );
                }),
            };
          },
        ),

        const SizedBox(height: 50),
      ],
    );
  }
}

class SeparatorDivider extends StatelessWidget {
  const SeparatorDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(indent: 15, endIndent: 15, color: ATColors.hex252525);
  }
}
