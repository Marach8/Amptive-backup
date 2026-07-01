import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/home/cubits/followed_shows_cubit.dart';
import 'package:amptive/src/features/home/presentation/screens/home_landing_screen.dart';
import 'package:amptive/src/features/shows/data/models/response/followed_shows_response_model.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/colors.dart';
import '../../../../shared/back_button.dart';
import '../../../../shared/custom_container_widget.dart';
import '../widgets/followed_program.dart';

class ATFollowedPrograms extends StatelessWidget {
  const ATFollowedPrograms({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FollowedShowsCubit>(
      create: (_) => FollowedShowsCubit()..fetchFollowedShows(),
      child: ATAnnotatedRegion(
        child: Scaffold(
          body: SafeArea(
            child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (_, __) => <Widget>[
                      SliverAppBar(
                        floating: true,
                        leadingWidth: 200.w,
                        leading: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: ATBackBtn(
                              alignment: Alignment.centerLeft,
                              leadingText: ATStrings.following,
                              leadingStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontSize: ATSizes.size23),
                            )),
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(0),
                          child: ATContainer(
                            color: ATColors.white,
                            height: 0.15,
                            width: double.infinity,
                            child: const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ],
                body: BlocBuilder<FollowedShowsCubit,
                    ATAppState<FollowedShowsResponseModel>>(
                  builder: (BuildContext context,
                      ATAppState<FollowedShowsResponseModel> state) {
                    return switch (state) {
                      InitialState<FollowedShowsResponseModel>() =>
                        const SizedBox.shrink(),
                      LoadingState<FollowedShowsResponseModel>() ||
                      FailureState<FollowedShowsResponseModel>() ||
                      SuccessState<FollowedShowsResponseModel>() =>
                        Builder(builder: (_) {
                          final FollowedShowsResponseModel? showsData = context
                              .read<FollowedShowsCubit>()
                              .currentFollowedShows;
                          final List<FollowedShowItem> followedShowsItems =
                              showsData?.items ?? <FollowedShowItem>[];

                          if (followedShowsItems.isEmpty) {
                            if (state
                                is LoadingState<FollowedShowsResponseModel>) {
                              return const InitialLoadingShimmer();
                            }
                            if (state
                                is FailureState<FollowedShowsResponseModel>) {
                              return Center(
                                child: IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: () => context
                                      .read<FollowedShowsCubit>()
                                      .fetchFollowedShows(),
                                ),
                              );
                            }
                            return const Center(
                              child: Text('No feed items available'),
                            );
                          }

                          final bool hasMore = showsData?.hasMore ?? false;
                          final int count = followedShowsItems.length;

                          return ATRefreshIndicator(
                            onRefresh:  () {
                              return context.read<FollowedShowsCubit>().fetchFollowedShows();
                            },
                              child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, int index) =>
                                const SizedBox(height: 30),
                            itemCount: hasMore ? count + 1 : count,
                            itemBuilder: (_, int index) {
                              if (index < count) {
                                final FollowedShowItem followedShowItem =
                                    followedShowsItems[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: FollowedProgram(
                                      showItem: followedShowItem),
                                );
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ));
                        }),
                    };
                  },
                )),
          ),
        ),
      ),
    );
  }
}
