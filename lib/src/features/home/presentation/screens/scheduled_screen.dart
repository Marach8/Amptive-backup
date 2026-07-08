import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';

import 'package:amptive/src/features/home/cubits/followed_shows_cubit.dart';
import 'package:amptive/src/features/shows/data/models/response/followed_shows_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/refresh_widgets.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/back_button.dart';
import '../widgets/scheduled_program.dart';

class ATScheduledPrograms extends StatelessWidget {
  const ATScheduledPrograms({super.key});

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
                  leadingWidth: 200,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ATBackBtn(
                      alignment: Alignment.centerLeft,
                      leadingText: ATStrings.scheduled,
                      leadingStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: ATSizes.size23),
                    ),
                  ),
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


                        final List<FollowedShowItem> scheduledItems = 
                            context.read<FollowedShowsCubit>().scheduledShowsItems;

                        if (scheduledItems.isEmpty) {
                          if (state
                              is LoadingState<FollowedShowsResponseModel>) {
                            return  const _ScheduledProgramShimmer();
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
                            child: Text('No scheduled shows available'),
                          );
                        }

                        return ATRefreshIndicator(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, int index) =>
                                const SizedBox(height: 30),
                            itemCount: scheduledItems.length,
                            itemBuilder: (_, int index) {
                              final FollowedShowItem showItem = scheduledItems[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: ScheduledProgram(showItem: showItem),
                              );
                            },
                          ),
                        );
                      }),
                  };
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduledProgramShimmer extends StatelessWidget {
  const _ScheduledProgramShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (_, __) => const SizedBox(height: 30),
        itemCount: 5,
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 60),
        itemBuilder: (_, __) =>  const ScheduledProgramItem());
  }
}

class ScheduledProgramItem extends StatelessWidget {
  const ScheduledProgramItem({super.key});

 @override
   Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: <Widget>[
        LayoutBuilder(builder: (_, BoxConstraints constraints) {
          return Row(
            spacing: 10,
            children: <Widget>[
              const ATShimmer(
                width: 40,
                height: 40,
                radius: 30,
              ),
              Flexible(
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ATShimmer(
                      height: 10,
                      radius: 3,
                      width: ATHelperFuncs.getRandomNumber(
                          constraints.maxWidth * 0.75),
                    ),
                    const ATShimmer(
                      width: 80,
                      height: 7,
                      radius: 2,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const ATShimmer(
                width: 25,
                height: 5,
                radius: 4,
              ),
            ],
          );
        }),
        const SizedBox(height: 2),
        Container(
            height: 425,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Stack(
              children: <Widget>[
                const ATShimmer(
                  height: 425,
                  radius: 15,
                ),
                Container(
                  width: context.screenWidth,
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          ATColors.transparent,
                          ATColors.transparent,
                          ATColors.transparent,
                          ATColors.transparent,
                          ATColors.containerGradientColorB
                              .withValues(alpha: 0.5),
                          ATColors.containerGradientColorB,
                          ATColors.containerGradientColorB,
                          ATColors.containerGradientColorB,
                        ]),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Container(
                      //   padding: const EdgeInsets.all(6),
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(6),
                      //       color: ATColors.black.withValues(alpha: 0.7)),
                      //   child:
                      //       const ATShimmer(height: 10, width: 70, radius: 3),
                      // ),
                      const Spacer(),
                      const SizedBox(height: 10),
                      ATShimmer(
                        height: 20,
                        radius: 6,
                        width: ATHelperFuncs.getRandomNumber(
                            context.screenWidth * 0.9),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ATShimmer(
                        height: 20,
                        radius: 6,
                        width: ATHelperFuncs.getRandomNumber(
                            context.screenWidth * 0.8),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const OverlappingImagesShimmer(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: Container(
                              padding: const EdgeInsets.all(8.5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ATColors.hex0D0D0D),
                              child: const ATShimmer(
                                  height: 10, width: 60, radius: 3),
                            ),
                          ),
                          const ATShimmer(height: 45, width: 45, radius: 30),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ))
      ],
      );
  
  }
}
