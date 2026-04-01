import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/features/discover/cubits/communities_cubit.dart';
import 'package:amptive/src/features/discover/data/models/response/communities_response_model.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/features/discover/presentation/widgets/community_card_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../config/routing/route_strings.dart';
import '../../../../shared/blurred_header.dart';

class ATCommunityScreen extends StatelessWidget {
  const ATCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommunitiesCubit>(create: (_) => CommunitiesCubit()..fetchCommunities(),
      child: ATAnnotatedRegion(
        statusBarColor: ATColors.transparent,
        child: Scaffold(
          body: BlocProvider<BlurredHeaderCubit>(
            create: (_) => BlurredHeaderCubit(),
            child: Builder(builder: (BuildContext blocContext) {
              return NotificationListener<ScrollNotification>(
                onNotification:
                    blocContext.read<BlurredHeaderCubit>().onScrollNotification,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: ATSliverHDelegate(
                          maxExt:
                              kToolbarHeight + MediaQuery.paddingOf(context).top,
                          minExt:
                              kToolbarHeight + MediaQuery.paddingOf(context).top,
                          child: ATBlurredHeaderWidget(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: ATRoundedBackBtn(
                                    bgColor: ATColors.transparent,
                                  ),
                                ),
                                Text(
                                  ATStrings.COMMUNITIES,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(
                                  width: 30,
                                )
                              ],
                            ),
                          )),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          maxLines: 3,
                          ATStrings.DISCOVER_COMMUNITIES,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: ATColors.hexA8A8A8),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 10,
                    )),
                    BlocConsumer<CommunitiesCubit, ATAppState<CommunitiesResponseModel>> (
                      listener: (BuildContext context, ATAppState<CommunitiesResponseModel> state) {
                        if (state is FailureState<CommunitiesResponseModel>) {
                         showAppNotification2(
                          context: context,
                           text: state.message,
                           type: NotificationType.failure);
                        }
                      },
                      builder: (BuildContext context, ATAppState<CommunitiesResponseModel> state) {
                        return switch (state) {
                          InitialState<CommunitiesResponseModel>() => const SizedBox.shrink(),
                          LoadingState<CommunitiesResponseModel>() || 
                          FailureState<CommunitiesResponseModel>() ||
                           SuccessState<CommunitiesResponseModel>()  =>
                          Builder(
                            builder: (BuildContext context) {
                              final CommunitiesResponseModel? community = context.read<CommunitiesCubit>().currentCommunities;
                              final Map<String, Community> communities = community?.communities ?? <String, Community>{};
                              final List<String> communityIds =
                        community?.communityIds ?? <String>[];
                              if (communities.isEmpty) {
                                if (state is LoadingState) {
                                  return const SliverToBoxAdapter(
                                    child: Center(
                                      child: CommunitiesShimmer(),
                                    ),
                                  );
                                }
                                if (state is FailureState) {
                                  return SliverFillRemaining(
                                    child: Center(
                                      child: IconButton(
                                        icon: const Icon(Icons.refresh),
                                        onPressed: () => context.read<CommunitiesCubit>().fetchCommunities(),
                                      ),
                                    ),
                                  );
                                }
                                return const SliverFillRemaining(
                                  child: Center(
                                    child: Text('communities not available yet'),
                                  ),
                                );
                              }
                    final int count = communityIds.length;

                            
                        
                      
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      sliver: SliverGrid(
                          delegate:
                              SliverChildListDelegate(List<Widget>.generate(
                                  count,
                                   (index) {
          final String? id = communityIds[index];
          final Community? community = communities[id];
                                  return CommunityCardWidget(
                                    title: community?.name ?? '',
                                        picture: community?.image ?? ATImgStrings.COMMUNITY_CARD,
                                        padding: EdgeInsets.zero,
                                        onTap: () => context
                                            .pushNamed(ATRoutes.SOCIETY_SCREEN),
                                       );
        },
      ),
    ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 0,
                                  childAspectRatio: 1.28)),
                    );
                            }
                          )
                        };
                      },
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
class CommunitiesShimmer extends StatelessWidget {
  const CommunitiesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 122, 
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 15),
        itemCount: 5, 
        itemBuilder: (BuildContext context, int index) {
          return const RenderCommunityCardShimmer();
        },
      ),
    );
  }
}

class RenderCommunityCardShimmer extends StatelessWidget {
  const RenderCommunityCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 15),
      child: ATShimmer(
        width: 160,
        height: 122,
        radius: 10, 
      ),
    );
  }
}
