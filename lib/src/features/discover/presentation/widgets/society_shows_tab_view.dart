import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/discover_export.dart';
import 'package:amptive/src/features/shows/cubits/hosted_shows_cubit.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/utils/image_strings.dart';
import '../../../../config/utils/other_strings.dart';

class SocietyShowsTabView extends StatelessWidget {
  const SocietyShowsTabView({super.key, this.communityId});
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
        const SizedBox(
          height: 40,
        ),
        HastagHeadingRow(
          title: ATStrings.PAID_SHOWS,
          viewAllOnpressed: () {},
        ),
        const SizedBox(
          height: 10,
        ),

        const SeparatorDivider(),
        const SizedBox(
          height: 40,
        ),
        HastagHeadingRow(
          title: ATStrings.FREE_SHOWS,
          viewAllOnpressed: () {},
        ),
        const SizedBox(
          height: 10,
        ),
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
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
