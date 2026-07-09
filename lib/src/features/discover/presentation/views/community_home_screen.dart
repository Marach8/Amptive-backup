import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
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
import '../../../main_app_nav_bar.dart';

class ATCommunityScreen extends StatelessWidget {
  const ATCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommunitiesCubit>(
      create: (_) => CommunitiesCubit()..fetchCommunities(),
      child: ATAnnotatedRegion(
        statusBarColor: ATColors.transparent,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomSheet: const AppBottomMenu(),
          body: BlocProvider<BlurredHeaderCubit>(
            create: (_) => BlurredHeaderCubit(),
            child: Builder(builder: (BuildContext blocContext) {
              return NotificationListener<ScrollNotification>(
                onNotification:
                    blocContext.read<BlurredHeaderCubit>().onScrollNotification,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: ATSliverHDelegate(
                          maxExt: kToolbarHeight +
                              MediaQuery.paddingOf(context).top +
                              12,
                          minExt: kToolbarHeight +
                              MediaQuery.paddingOf(context).top +
                              12,
                          child: ColoredBox(
                            color: ATColors.black,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.paddingOf(context).top,
                                  bottom: 12),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 7),
                                      child: ATBackBtn(
                                        alignment: Alignment.centerLeft,
                                        leadingText: ATStrings.COMMUNITIES,
                                        leadingStyle: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontSize: ATSizes.size26,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 2, 15, 20),
                        child: Text(
                          maxLines: 3,
                          ATStrings.DISCOVER_COMMUNITIES,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: ATColors.hexC2C2C2),
                        ),
                      ),
                    ),
                    BlocConsumer<CommunitiesCubit,
                        ATAppState<CommunitiesResponseModel>>(
                      listener: (BuildContext context,
                          ATAppState<CommunitiesResponseModel> state) {
                        if (state is FailureState<CommunitiesResponseModel>) {
                          showAppNotification2(
                              context: context,
                              text: state.message,
                              type: NotificationType.failure);
                        }
                      },
                      builder: (BuildContext context,
                          ATAppState<CommunitiesResponseModel> state) {
                        return switch (state) {
                          InitialState<CommunitiesResponseModel>() =>
                            const SizedBox.shrink(),
                          LoadingState<CommunitiesResponseModel>() ||
                          FailureState<CommunitiesResponseModel>() ||
                          SuccessState<CommunitiesResponseModel>() =>
                            Builder(builder: (BuildContext context) {
                              final CommunitiesResponseModel? community =
                                  context
                                      .read<CommunitiesCubit>()
                                      .currentCommunities;
                              final Map<String, Community> communities =
                                  community?.communities ??
                                      <String, Community>{};
                              final List<String> communityIds =
                                  community?.communityIds ?? <String>[];
                              if (communities.isEmpty) {
                                if (state is LoadingState) {
                                  return const CommunitiesShimmer();
                                }

                                if (state is FailureState) {
                                  return SliverFillRemaining(
                                    child: Center(
                                      child: IconButton(
                                        icon: const Icon(Icons.refresh),
                                        onPressed: () => context
                                            .read<CommunitiesCubit>()
                                            .fetchCommunities(),
                                      ),
                                    ),
                                  );
                                }
                                return const SliverFillRemaining(
                                  child: Center(
                                    child:
                                        Text('communities not available yet'),
                                  ),
                                );
                              }
                              final int count = communityIds.length;

                              return SliverPadding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 120),
                                sliver: SliverGrid(
                                    delegate: SliverChildListDelegate(
                                      List<Widget>.generate(
                                        count,
                                        (int index) {
                                          final String id = communityIds[index];
                                          final Community? community =
                                              communities[id];
                                          return CommunityCardWidget(
                                            picture: community?.image ??
                                                ATImgStrings.COMMUNITY_CARD,
                                            semanticLabel:
                                                '${community?.name ?? 'Community'} community',
                                            padding: EdgeInsets.zero,
                                            onTap: () => context.pushNamed(
                                              ATRoutes.SOCIETY_SCREEN,
                                              extra: <String, String>{
                                                'communityId': id,
                                                'communityName':
                                                    community?.name ?? 'Community',
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 170 / 122)),
                              );
                            })
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
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 120),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) =>
              const RenderCommunityCardShimmer(),
          childCount: 10,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 170 / 122,
        ),
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
        width: 170,
        height: 122,
        radius: 10,
      ),
    );
  }
}
