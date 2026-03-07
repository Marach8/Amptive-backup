import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/discover/cubits/communities_cubit.dart';
import 'package:amptive/src/features/discover/data/models/response/communities_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/rich_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Future<Community?> showCommunitiesModal({
  required BuildContext context,
  required CommunitiesCubit communitiesCubit,
}) async {
  return await showModalBottomSheet<Community>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: ATColors.hex202020,
    builder: (BuildContext dContext) {
      return BlocProvider<CommunitiesCubit>.value(
        value: communitiesCubit,
        child: DraggableScrollableSheet(
          expand: false,
          builder: (_, ScrollController scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 40),
              child: _SubWidget(controller: scrollController),
            );
          },
        ),
      );
    },
  );
}

class _SubWidget extends StatefulWidget {
  const _SubWidget({required this.controller});
  final ScrollController controller;

  @override
  State<_SubWidget> createState() => __SubWidgetState();
}

class __SubWidgetState extends State<_SubWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScrollToEnd);
  }

  void _onScrollToEnd() {
    const double dragThreshold = 80;
    if (widget.controller.position.pixels >=
        widget.controller.position.maxScrollExtent + dragThreshold) {
      context.read<CommunitiesCubit>().fetchCommunities();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const ATModalDismisser(),
        Text(ATStrings.addCommunity, style: context.textTheme.bodyLarge),
        const SizedBox(height: 15),
        ATRichText(
          maxLines: 4,
          items: <String, TextStyle>{
            ATStrings.addCommunityDesc: context.textTheme.labelSmall!
                .copyWith(color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
            ATStrings.learnMore: context.textTheme.labelSmall!
          },
          textOnTap: (String text) {
            if (text == ATStrings.learnMore) {}
          },
        ),
        const SizedBox(height: 25),
        Expanded(
          child: BlocConsumer<CommunitiesCubit,
                  ATAppState<CommunitiesResponseModel>>(
              listener: (_, ATAppState<CommunitiesResponseModel> state) {
            if (state is FailureState<CommunitiesResponseModel>) {
              showAppNotification2(
                  context: context,
                  text: state.message,
                  type: NotificationType.failure);
            }
          }, builder: (_, ATAppState<CommunitiesResponseModel> state) {
            return switch (state) {
              InitialState<CommunitiesResponseModel>() =>
                const SizedBox.shrink(),
              LoadingState<CommunitiesResponseModel>() ||
              FailureState<CommunitiesResponseModel>() ||
              SuccessState<CommunitiesResponseModel>() =>
                Builder(
                  builder: (_) {
                    final CommunitiesResponseModel? communitiesData =
                        context.read<CommunitiesCubit>().currentCommunities;
                    final Map<String, Community> communities =
                        communitiesData?.communities ?? <String, Community>{};
                    final List<String> communityIds =
                        communitiesData?.communityIds ?? <String>[];

                    if (communities.isEmpty) {
                      if (state is LoadingState<CommunitiesResponseModel>) {
                        return const Center(child: ATLoadingIndicator());
                      }
                      if (state is FailureState<CommunitiesResponseModel>) {
                        return Center(
                            child: IconButton(
                          onPressed: () {
                            context.read<CommunitiesCubit>().fetchCommunities();
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

                    final bool hasMoreItems = communitiesData?.hasMore ?? true;
                    final int count = communityIds.length;

                    return ListView.builder(
                      controller: widget.controller,
                      itemCount: hasMoreItems ? count + 1 : count,
                      itemBuilder: (_, int index) {
                        if (index < count) {
                          final String id = communityIds[index];
                          final Community? community = communities[id];
                          return GestureDetector(
                            onTap: () => context.pop(community),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: ATImgLoader(
                                        width: 70,
                                        height: 50,
                                        imgPath: community?.image ?? '',
                                        boxFit: BoxFit.cover),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Flexible(
                                    child: Text(
                                      community?.name ?? '',
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(fontSize: ATSizes.size15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        if (state is LoadingState<CommunitiesResponseModel>) {
                          return const Center(child: ATLoadingIndicator());
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  },
                )
            };
          }),
        ),
      ],
    );
  }
}
