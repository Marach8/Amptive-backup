import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/features/events/cubits/hosted_events_cubit.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/features/profile/presentation/widgets/program_display_shimmer.dart';
import 'package:amptive/src/features/shows/cubits/hosted_shows_cubit.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/show_event_nd_paid_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/custom_container_widget.dart';
import '../../../../shared/image_loader_widget.dart';

class ProfileEventOrShowDisplay extends StatelessWidget {
  const ProfileEventOrShowDisplay({super.key, required this.tabType});
  final ProfileTabType tabType;

  @override
  Widget build(BuildContext context) {
    return switch (tabType) {
      ProfileTabType.shows => BlocProvider<HostedShowsCubit>(
          create: (_) => HostedShowsCubit()..fetchHostedShows(),
          child: BlocBuilder<HostedShowsCubit,
              ATAppState<HostedShowsResponseModel>>(
            builder: (BuildContext context,
                ATAppState<HostedShowsResponseModel> state) {
              return switch (state) {
                InitialState<HostedShowsResponseModel>() => const SizedBox.shrink(),
                LoadingState<HostedShowsResponseModel>() ||
                FailureState<HostedShowsResponseModel>() ||
                SuccessState<HostedShowsResponseModel>() =>
                  Builder(
                    builder: (_) {
                      final HostedShowsResponseModel? showsData = context
                          .read<HostedShowsCubit>()
                          .currentHostedShowsData;
                      final List<HostedShow> hostedShows =
                          showsData?.hostedShows ?? <HostedShow>[];
                      if (hostedShows.isEmpty) {
                        if (state is LoadingState<HostedShowsResponseModel>) {
                          return const ProgramDisplayShimmer();
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
                        return const Center(
                            child: Text('Nothing to show here yet...'));
                      }
                      return ListView.builder(
                        itemCount: hostedShows.length,
                        itemBuilder: (BuildContext _, int index) {
                          final HostedShow show = hostedShows[index];
                          return ATContainer(
                            onTap: () {},
                            margin: const EdgeInsets.fromLTRB(15, 12, 15, 12),
                            height: 80,
                            radius: 0,
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: ATImgLoader(
                                    imgPath: show.coverUrl ??
                                        ATImgStrings.weCanDoHardThingsBgImage,
                                    height: 77,
                                    width: 77,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          const ATShowIcon(),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              show.title ??
                                                  'We Can Do Hard Things',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontSize: ATSizes.size12,
                                                color: ATColors.hexC2C2C2,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                              Icons
                                                  .keyboard_arrow_right_outlined,
                                              color: ATColors.hexC2C2C2,
                                              size: 20)
                                        ],
                                      ),
                                      Text(
                                        maxLines: 2,
                                        show.description ?? 'Description',
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontSize: ATSizes.size15),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          ATPaidIndicatorIcon(
                                              size: 10,
                                              radius: 1,
                                              color: ATColors.hexC2C2C2),
                                          const SizedBox(width: 5),
                                          Text(
                                            show.category ?? 'Society',
                                            style: context.textTheme.titleSmall
                                                ?.copyWith(
                                                    color: ATColors.hexC2C2C2),
                                          ),
                                          const SizedBox(width: 5),
                                          ATCircleAvatar(
                                              diameter: 3,
                                              color: ATColors.hexC2C2C2),
                                          const SizedBox(width: 5),
                                          Text(
                                            show.createdAt?.toNormalDate ??
                                                'Date',
                                            style: context.textTheme.titleSmall
                                                ?.copyWith(
                                                    color: ATColors.hexC2C2C2),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                _ => const SizedBox(),
              };
            },
          ),
        ),
      ProfileTabType.events => BlocProvider<HostedEventsCubit>(
          create: (_) => HostedEventsCubit()..fetchHostedEvents(),
          child: BlocBuilder<HostedEventsCubit,
              ATAppState<HostedEventsResponseModel>>(
            builder: (BuildContext context,
                ATAppState<HostedEventsResponseModel> state) {
              return switch (state) {
                InitialState<HostedEventsResponseModel>() ||
                LoadingState<HostedEventsResponseModel>() ||
                FailureState<HostedEventsResponseModel>() ||
                SuccessState<HostedEventsResponseModel>() =>
                  Builder(
                    builder: (_) {
                      final HostedEventsResponseModel? eventsData = context
                          .read<HostedEventsCubit>()
                          .currentHostedEventsData;
                      final List<HostedEvent> hostedEvents =
                          eventsData?.hostedEvents ?? <HostedEvent>[];
                      if (hostedEvents.isEmpty) {
                        if (state is LoadingState<HostedEventsResponseModel>) {
                          return const ProgramDisplayShimmer();
                        }
                        if (state is FailureState<HostedEventsResponseModel>) {
                          return Center(
                            child: IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => context
                                  .read<HostedEventsCubit>()
                                  .fetchHostedEvents(),
                            ),
                          );
                        }
                        return const Center(
                            child: Text('Nothing to show here yet...'));
                      }
                      return ListView.builder(
                        itemCount: hostedEvents.length,
                        itemBuilder: (BuildContext _, int index) {
                          final HostedEvent event = hostedEvents[index];
                          return ATContainer(
                            onTap: () {},
                            margin: const EdgeInsets.fromLTRB(15, 12, 15, 12),
                            height: 80,
                            radius: 0,
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: ATImgLoader(
                                    imgPath: event.coverUrl ??
                                        ATImgStrings.weCanDoHardThingsBgImage,
                                    height: 77,
                                    width: 77,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          const ATShowIcon(),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              event.title ?? 'Event Title',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontSize: ATSizes.size12,
                                                color: ATColors.hexC2C2C2,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                              Icons
                                                  .keyboard_arrow_right_outlined,
                                              color: ATColors.hexC2C2C2,
                                              size: 20)
                                        ],
                                      ),
                                      Text(
                                        maxLines: 2,
                                        event.description ?? 'Description',
                                        overflow: TextOverflow.ellipsis,
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontSize: ATSizes.size15),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          ATPaidIndicatorIcon(
                                              size: 10,
                                              radius: 1,
                                              color: ATColors.hexC2C2C2),
                                          const SizedBox(width: 5),
                                          Text(
                                            event.category ?? 'Category',
                                            style: context.textTheme.titleSmall
                                                ?.copyWith(
                                                    color: ATColors.hexC2C2C2),
                                          ),
                                          const SizedBox(width: 5),
                                          ATCircleAvatar(
                                              diameter: 3,
                                              color: ATColors.hexC2C2C2),
                                          const SizedBox(width: 5),
                                          Text(
                                            event.startedAt?.toNormalDate ??
                                                'Date',
                                            style: context.textTheme.titleSmall
                                                ?.copyWith(
                                                    color: ATColors.hexC2C2C2),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
              };
            },
          ),
        ),
      ProfileTabType.scheduled => BlocProvider<HostedEventsCubit>(
          create: (_) => HostedEventsCubit()..fetchHostedEvents(),
          child: BlocBuilder<HostedEventsCubit,
              ATAppState<HostedEventsResponseModel>>(
            builder: (BuildContext context,
                ATAppState<HostedEventsResponseModel> state) {
              return switch (state) {
                InitialState<HostedEventsResponseModel>() ||
                LoadingState<HostedEventsResponseModel>() ||
                FailureState<HostedEventsResponseModel>() ||
                SuccessState<HostedEventsResponseModel>() =>
                  Builder(
                    builder: (_) {
                      final HostedEventsResponseModel? eventsData = context
                          .read<HostedEventsCubit>()
                          .currentHostedEventsData;
                      final List<HostedEvent> allEvents =
                          eventsData?.hostedEvents ?? <HostedEvent>[];
                      final List<HostedEvent> filteredEvents = allEvents
                          .where((HostedEvent event) =>
                              event.status == 'scheduled' ||
                              (event.scheduledFor != null &&
                                  DateTime.tryParse(event.scheduledFor!)
                                          ?.isAfter(DateTime.now()) ==
                                      true))
                          .toList();
                      if (filteredEvents.isEmpty) {
                        if (state is LoadingState<HostedEventsResponseModel>) {
                          return const ProgramDisplayShimmer();
                        }
                        if (state is FailureState<HostedEventsResponseModel>) {
                          return Center(
                            child: IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => context
                                  .read<HostedEventsCubit>()
                                  .fetchHostedEvents(),
                            ),
                          );
                        }
                        return const Center(
                            child: Text('Nothing to show here yet...'));
                      }
                      return ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (BuildContext _, int index) {
                          final HostedEvent event = filteredEvents[index];
                          return ATContainer(
                            onTap: () {},
                            margin: const EdgeInsets.fromLTRB(15, 12, 15, 12),
                            height: 80,
                            radius: 0,
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: ATImgLoader(
                                    imgPath: event.coverUrl ??
                                        ATImgStrings.weCanDoHardThingsBgImage,
                                    height: 77,
                                    width: 77,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          const ATShowIcon(),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              event.title ?? 'Event Title',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontSize: ATSizes.size12,
                                                color: ATColors.hexC2C2C2,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                              Icons
                                                  .keyboard_arrow_right_outlined,
                                              color: ATColors.hexC2C2C2,
                                              size: 20)
                                        ],
                                      ),
                                      Text(
                                        maxLines: 2,
                                        event.description ?? 'Description',
                                        overflow: TextOverflow.ellipsis,
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontSize: ATSizes.size15),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          ATPaidIndicatorIcon(
                                              size: 10,
                                              radius: 1,
                                              color: ATColors.hexC2C2C2),
                                          const SizedBox(width: 5),
                                          Text(
                                            event.category ?? 'Category',
                                            style: context.textTheme.titleSmall
                                                ?.copyWith(
                                                    color: ATColors.hexC2C2C2),
                                          ),
                                          const SizedBox(width: 5),
                                          ATCircleAvatar(
                                              diameter: 3,
                                              color: ATColors.hexC2C2C2),
                                          const SizedBox(width: 5),
                                          Text(
                                            event.scheduledFor?.toNormalDate ??
                                                'Date',
                                            style: context.textTheme.titleSmall
                                                ?.copyWith(
                                                    color: ATColors.hexC2C2C2),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
              };
            },
          ),
        ),
      ProfileTabType.ended => BlocProvider<HostedEventsCubit>(
          create: (_) => HostedEventsCubit()..fetchHostedEvents(),
          child: BlocBuilder<HostedEventsCubit,
              ATAppState<HostedEventsResponseModel>>(
            builder: (BuildContext context,
                ATAppState<HostedEventsResponseModel> state) {
              return switch (state) {
                InitialState<HostedEventsResponseModel>() ||
                LoadingState<HostedEventsResponseModel>() ||
                FailureState<HostedEventsResponseModel>() ||
                SuccessState<HostedEventsResponseModel>() =>
                  Builder(
                    builder: (_) {
                      final HostedEventsResponseModel? eventsData = context
                          .read<HostedEventsCubit>()
                          .currentHostedEventsData;
                      final List<HostedEvent> allEvents =
                          eventsData?.hostedEvents ?? <HostedEvent>[];
                      final List<HostedEvent> filteredEvents = allEvents
                          .where((HostedEvent event) =>
                              event.status == 'ended' ||
                              (event.endedAt != null &&
                                  DateTime.tryParse(event.endedAt!)
                                          ?.isBefore(DateTime.now()) ==
                                      true))
                          .toList();
                      if (filteredEvents.isEmpty) {
                        if (state is LoadingState<HostedEventsResponseModel>) {
                          return const ProgramDisplayShimmer();
                        }
                        if (state is FailureState<HostedEventsResponseModel>) {
                          return Center(
                            child: IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => context
                                  .read<HostedEventsCubit>()
                                  .fetchHostedEvents(),
                            ),
                          );
                        }
                        return const Center(
                            child: Text('Nothing to show here yet...'));
                      }
                      return ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (BuildContext _, int index) {
                          final HostedEvent event = filteredEvents[index];
                          return ATContainer(
                            onTap: () {},
                            margin: const EdgeInsets.fromLTRB(15, 12, 15, 12),
                            height: 80,
                            radius: 0,
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: ATImgLoader(
                                    imgPath: event.coverUrl ??
                                        ATImgStrings.weCanDoHardThingsBgImage,
                                    height: 77,
                                    width: 77,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          const ATShowIcon(),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              event.title ?? 'Event Title',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontSize: ATSizes.size12,
                                                color: ATColors.hexC2C2C2,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                              Icons
                                                  .keyboard_arrow_right_outlined,
                                              color: ATColors.hexC2C2C2,
                                              size: 20)
                                        ],
                                      ),
                                      Text(
                                        maxLines: 2,
                                        event.description ?? 'Description',
                                        overflow: TextOverflow.ellipsis,
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontSize: ATSizes.size15),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          ATPaidIndicatorIcon(
                                              size: 10,
                                              radius: 1,
                                              color: ATColors.hexC2C2C2),
                                          const SizedBox(width: 5),
                                          Text(
                                            event.category ?? 'Category',
                                            style: context.textTheme.titleSmall
                                                ?.copyWith(
                                                    color: ATColors.hexC2C2C2),
                                          ),
                                          const SizedBox(width: 5),
                                          ATCircleAvatar(
                                              diameter: 3,
                                              color: ATColors.hexC2C2C2),
                                          const SizedBox(width: 5),
                                          Text(
                                            event.endedAt?.toNormalDate ??
                                                'Date',
                                            style: context.textTheme.titleSmall
                                                ?.copyWith(
                                                    color: ATColors.hexC2C2C2),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
              };
            },
          ),
        ),
    };
  }
}

