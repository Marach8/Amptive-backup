import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/discover/cubits/communities_cubit.dart';
import 'package:amptive/src/features/discover/cubits/join_communities_cubit.dart';
import 'package:amptive/src/features/discover/data/models/response/communities_response_model.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';

import '../../../../shared/app_bar_widget.dart';
import '../../../../shared/loading_indicator.dart';

class Select5CommunitiesScreen extends StatelessWidget {
  const Select5CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<CommunitiesCubit>(
          create: (_) => CommunitiesCubit()
        ),
        BlocProvider<SelectCommunitiesCubit>(
          create: (_) => SelectCommunitiesCubit()
        ),
        BlocProvider<JoinCommunitiesCubit>(
          create: (_) => JoinCommunitiesCubit()
        ),
      ],
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
    return ATAnnotatedRegion(
        child: Scaffold(
      appBar: ATAppBar(
        leading: const ATBackBtn(),
        actions: <Widget>[
          BlocBuilder<SelectCommunitiesCubit, List<String>>(
            builder: (_, List<String> selectedComIds) {
              return Text(
                '${selectedComIds.length} selected',
                style: context.textTheme.titleSmall
                  ?.copyWith(color: ATColors.hexC2C2C2));
            }
          )
        ],
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
                          builder: (BuildContext context) {
                            final CommunitiesResponseModel? communitiesData =
                                context.read<CommunitiesCubit>().currentCommunities;
                            final Map<String, Community> communities =
                                communitiesData?.communities ??
                                    <String, Community>{};
                            final List<String> communityIds =
                                communitiesData?.communityIds ?? <String>[];
    
                            if (communityIds.isEmpty) {
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
                                padding: const EdgeInsets.only(bottom: 120),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      crossAxisCount: 2,
                                      childAspectRatio: 169 / 122),
                              itemBuilder: (_, int index) {
                                if (index < count) {
                                  final String id = communityIds[index];
                                  final Community community = communities[id]!;
                                  return BlocBuilder<SelectCommunitiesCubit, List<String>>(
                                    builder: (_, List<String> selectedIds) {
                                      return RenderACommunityCard(
                                        community: community,
                                        isSelected: selectedIds.contains(id),
                                      );
                                    }
                                  );
                                }
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
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 50),
        child: BlocConsumer<JoinCommunitiesCubit, ATAppState<bool>>(
          listener: (_, ATAppState<bool> state){
            if (state is SuccessState<bool>) {
              context.goNamed(ATRoutes.allowNotificationsScreen);
            }
            if (state is FailureState<bool>) {
              showAppNotification2(
                context: context,
                text: state.message,
                type: NotificationType.failure
              );
            }
          },
          builder: (_, ATAppState<bool> state) {
            return BlocBuilder<SelectCommunitiesCubit, List<String>>(
                builder: (_, List<String> selectedComIds) {
                return ATPlainElevatedBtn(
                  isLoading: state is LoadingState<bool>,
                  onPressed: selectedComIds.length < 5 ? null : () {
                    context.read<JoinCommunitiesCubit>()
                      .joinCommunities(communityIds: selectedComIds);
                  },
                  btnTitle: ATStrings.next,
                );
              }
            );
          }
        ),
      ),
    ));
  }
}


class RenderACommunityCard extends StatelessWidget {
  const RenderACommunityCard({
    super.key,
    required this.community,
    required this.isSelected,
  });

  final Community community;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          context.read<SelectCommunitiesCubit>()
            .deselectCommunity(community.communityId ?? '');
        } else {
          context.read<SelectCommunitiesCubit>()
            .selectCommunity(community.communityId ?? '');
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: ATImgLoader(
              imgPath: community.image ?? '',
              boxFit: BoxFit.cover,
              height: 120,
              width: 170,
            ),
          ),
          if(isSelected) Positioned(
            right: 6, top: 6,
            child: CircleAvatar(
              backgroundColor: ATColors.white,
              radius: 12,
              child: Icon(
                Icons.check, size: 16,
                color: ATColors.black
              ),
            )
          )
        ],
      ),
    );
  }
}



class SelectCommunitiesCubit extends Cubit<List<String>> {
  SelectCommunitiesCubit() : super(<String>[]);

  void selectCommunity(String communityId) {
    emit(<String>[...state, communityId]);
  }

  void deselectCommunity(String communityId) {
    final List<String> communites = List<String>.from(state);
    communites.remove(communityId);
    emit(communites);
  }
}
