import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/discover/cubits/trending_hashtags_cubit.dart';
import 'package:amptive/src/features/discover/data/models/response/trending_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/discover_export.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrendingHashTagsScreen extends StatelessWidget {
  const TrendingHashTagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrendingHashtagsCubit>(
      create: (_) => TrendingHashtagsCubit()..fetchTrendingTags(),
      child: ATAnnotatedRegion(
        child: Scaffold(
          body: SafeArea(
            child: BlocConsumer<TrendingHashtagsCubit,
                ATAppState<TrendingTagsResponseModel>>(
              listener: (BuildContext context,
                  ATAppState<TrendingTagsResponseModel> state) {
                if (state is FailureState<TrendingTagsResponseModel>) {
                  showAppNotification2(
                    context: context,
                    text: state.message,
                    type: NotificationType.failure,
                  );
                }
              },
              builder: (BuildContext context,
                  ATAppState<TrendingTagsResponseModel> state) {
                return switch (state) {
                  InitialState<TrendingTagsResponseModel>() =>
                    const SizedBox.shrink(),
                  LoadingState<TrendingTagsResponseModel>() ||
                  FailureState<TrendingTagsResponseModel>() ||
                  SuccessState<TrendingTagsResponseModel>() =>
                    CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: <Widget>[
                        SliverAppBar(
                          title: Text(
                            ATStrings.trendingHashtags,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          elevation: 0,
                          centerTitle: true,
                          floating: true,
                          leading: const ATRoundedBackBtn(),
                        ),
                        Builder(
                          builder: (BuildContext context) {
                            final TrendingTagsResponseModel? hashtags = context
                                .read<TrendingHashtagsCubit>()
                                .currentTrendingTags;
                            final List<HashTag> trendingHashtags =
                                hashtags?.trendingHashtag ?? <HashTag>[];

                            if (trendingHashtags.isEmpty) {
                              if (state is LoadingState) {
                                return const TrendingHashtagsShimmer();
                              }
                              if (state is FailureState) {
                                return SliverFillRemaining(
                                  child: Center(
                                    child: IconButton(
                                      icon: const Icon(Icons.refresh),
                                      onPressed: () => context
                                          .read<TrendingHashtagsCubit>()
                                          .fetchTrendingTags(),
                                    ),
                                  ),
                                );
                              }
                              return const SliverFillRemaining(
                                child: Center(
                                  child: Text(
                                      'No trending hashtags available at the moment'),
                                ),
                              );
                            }

                            return SliverList(
                              delegate: SliverChildListDelegate.fixed(<Widget>[
                                ...trendingHashtags.map((HashTag tag) => Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: HashTagsSubtitleRow(
                                            hashTagTitle: tag.name ??
                                                '', 
                                            hashTagSubTitle:
                                                '${tag.usageCount ?? 0} posts',
                                            trailingOnpressed: () {},
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        SizedBox(
                                          height: 180,
                                          child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 5,
                                            itemBuilder: (_, __) =>
                                                const RenderTrendingHashTag(
                                              trendingPicture: ATImgStrings
                                                  .weCanDoHardThingsBgImage,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 40),
                                      ],
                                    )),
                                const SizedBox(height: 60),
                              ]),
                            );
                          },
                        ),
                      ],
                    ),
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TrendingHashtagsShimmer extends StatelessWidget {
  const TrendingHashtagsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) =>
              const RenderTrendingHashtagRowShimmer(),
          childCount: 5),
    );
  }
}

class RenderTrendingHashtagRowShimmer extends StatelessWidget {
  const RenderTrendingHashtagRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: <Widget>[
                  ATShimmer(
                    width: 120,
                    height: 16,
                    radius: 4,
                  ),
                  ATShimmer(
                    width: 200,
                    height: 10,
                    radius: 3,
                  ),
                ],
              ),
              ATShimmer(
                  width: 20, height: 20, radius: 4), // Trailing arrow icon
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            padding: const EdgeInsets.only(left: 15),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.only(right: 15),
              child: ATShimmer(
                width: 140,
                height: 180,
                radius: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
