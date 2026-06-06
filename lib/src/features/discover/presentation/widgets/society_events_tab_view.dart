import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/discover_export.dart';
import 'package:amptive/src/features/events/cubits/hosted_events_cubit.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../config/utils/other_strings.dart';

class SocietyEventsTabView extends StatelessWidget {
  const SocietyEventsTabView({
    super.key,
    this.communityId,
  });
  final String? communityId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HastagHeadingRow(
          title: ATStrings.TRENDING,
          viewAllOnpressed: () {},
        ),
        const SizedBox(
          height: 10,
        ),
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

                  if (events.isEmpty) {
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
                    return const Text('No trending events available.');
                  }

                  return SizedBox(
                    height: 180,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (_, int index) {
                        return RenderTrendingHashTag(
                          trendingPicture: events[index].coverUrl ??
                              ATImgStrings.weCanDoHardThingsBgImage,
                          title: events[index].title,
                        );
                      },
                    ),
                  );
                }),
            };
          },
        ),
        const SeparatorDivider(),
        const SizedBox(
          height: 40,
        ),
        HastagHeadingRow(
          title: ATStrings.PAID_EVENTS,
          viewAllOnpressed: () {},
        ),
        const SizedBox(
          height: 10,
        ),
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
                    return const Text('No paid events available.');
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
        const SizedBox(
          height: 40,
        ),
        HastagHeadingRow(
          title: ATStrings.FREE_EVENTS,
          viewAllOnpressed: () {},
        ),
        const SizedBox(
          height: 10,
        ),
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
                    return const Text('No free events available.');
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
        const SeparatorDivider(),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
