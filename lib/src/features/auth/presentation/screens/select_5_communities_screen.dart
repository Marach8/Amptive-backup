import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/discover/cubits/communities_cubit.dart';
import 'package:amptive/src/features/discover/data/models/response/communities_response_model.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/app_bar_widget.dart';
import '../../../../shared/loading_indicator.dart';
import '../widgets/community_card_preference.dart';

class Select5CommunitiesScreen extends StatelessWidget {
  const Select5CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommunitiesCubit>(
      create: (_) => CommunitiesCubit(),
      child: const _SubWidget(),
    );
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget();

  @override
  State<_SubWidget> createState() => __SubWidgetState();
}

class __SubWidgetState extends State<_SubWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CommunitiesCubit>().fetchCommunities();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommunitiesCubit>(
      create: (_) => CommunitiesCubit()..fetchCommunities(),
      child: ATAnnotatedRegion(
          child: Scaffold(
        appBar: const ATAppBar(
          leading: ATBackBtn(),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            spacing: 16,
            children: <Widget>[
              Text(
                ATStrings.select5Communities,
                maxLines: 3,
                style: context.textTheme.headlineLarge,
              ),
              Text(
                ATStrings.selectedInterestNote,
                maxLines: 3,
                style: context.textTheme.titleMedium
                    ?.copyWith(color: ATColors.hexCDCDCD),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    BlocBuilder<CommunitiesCubit,
                            ATAppState<CommunitiesResponseModel>>(
                        builder:
                            (_, ATAppState<CommunitiesResponseModel> state) {
                      return switch (state) {
                        InitialState<CommunitiesResponseModel>() =>
                          const SizedBox.shrink(),
                        LoadingState<CommunitiesResponseModel>() ||
                        FailureState<CommunitiesResponseModel>() ||
                        SuccessState<CommunitiesResponseModel>() =>
                          Builder(
                            builder: (_) {
                              final CommunitiesResponseModel? communitiesData =
                                  context
                                      .read<CommunitiesCubit>()
                                      .currentCommunities;
                              final Map<String, Community> communities =
                                  communitiesData?.communities ??
                                      <String, Community>{};
                              final List<String> communityIds =
                                  communitiesData?.communityIds ?? <String>[];

                              if (communities.isEmpty) {
                                if (state
                                    is LoadingState<CommunitiesResponseModel>) {
                                  return const Center(
                                      child: ATLoadingIndicator());
                                }
                                if (state
                                    is FailureState<CommunitiesResponseModel>) {
                                  return Center(
                                      child: IconButton(
                                    onPressed: () {
                                      context
                                          .read<CommunitiesCubit>()
                                          .fetchCommunities();
                                    },
                                    icon: const Icon(Icons.refresh),
                                  ));
                                }
                                return Center(
                                  child: Text(
                                    'Communities not available yet',
                                    style: context.textTheme.titleMedium,
                                  ),
                                );
                              }

                              final bool hasMoreItems =
                                  communitiesData?.hasMore ?? true;
                              final int count = communityIds.length;

                              return GridView.builder(
                                itemCount: hasMoreItems
                                    ? (count + (count.isEven ? 2 : 1))
                                    : count,
                                controller: scrollController,
                                cacheExtent: 450,
                                // Bottom padding so last row isn't clipped by the bottomSheet button
                                padding: const EdgeInsets.only(bottom: 100),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 4,
                                        mainAxisSpacing: 4,
                                        crossAxisCount: 2,
                                        childAspectRatio: 169 / 122),
                                itemBuilder: (_, int index) {
                                  if (index < count) {
                                    final String id = communityIds[index];
                                    final Community community =
                                        communities[id]!;
                                    return RenderACommunityCard(
                                      community: community,
                                    );
                                  }
                                  // Show spinner in extra slots during pagination load
                                  if (state is LoadingState<
                                      CommunitiesResponseModel>) {
                                    return const Center(
                                        child: ATLoadingIndicator());
                                  }
                                  return const SizedBox.shrink();
                                },
                              );
                            },
                          )
                      };
                    }),
                    // Full-screen loading overlay — blocks interaction while initial load is in progress
                    BlocBuilder<CommunitiesCubit,
                        ATAppState<CommunitiesResponseModel>>(
                      builder: (_, ATAppState<CommunitiesResponseModel> state) {
                        if (state is LoadingState<CommunitiesResponseModel> &&
                            (context
                                    .read<CommunitiesCubit>()
                                    .currentCommunities
                                    ?.communities
                                    ?.isEmpty ??
                                true)) {
                          return const ColoredBox(
                            color: Colors.transparent,
                            child: Center(child: ATLoadingIndicator()),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 50),
          child: ATPlainElevatedBtn(
            onPressed: () {
              context.goNamed(ATRoutes.allowNotificationsScreen);
            },
            btnTitle: ATStrings.next,
            bgColor: Colors.white,
            fgColor: Colors.black,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      )),
    );
  }
}

class SelectedCommunitiesCubit extends Cubit<List<String>> {
  SelectedCommunitiesCubit() : super(<String>[]);

  void addCommunity(String communityId) {
    emit(<String>[...state, communityId]);
  }

  void removeCommunity(String communityId) {
    emit(state.where((String id) => id != communityId).toList());
  }
}
