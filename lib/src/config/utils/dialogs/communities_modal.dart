import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/discover/cubits/communities_cubit.dart';
import 'package:amptive/src/features/discover/data/models/response/communities_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/rich_text.dart';
import 'package:figma_squircle/figma_squircle.dart';
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
    // Same treatment as the cover-picker sheet: transparent sheet, the
    // corners and fill come from the ClipRRect + Material inside.
    backgroundColor: Colors.transparent,
    barrierColor: ATColors.black.withValues(alpha: 0.5),
    builder: (BuildContext dContext) {
      return BlocProvider<CommunitiesCubit>.value(
        value: communitiesCubit,
        child: DraggableScrollableSheet(
          expand: false,
          // Open nearly full-height (like the cover-picker sheet) instead of
          // halfway; still draggable down.
          initialChildSize: 0.94,
          minChildSize: 0.5,
          maxChildSize: 0.94,
          builder: (_, ScrollController scrollController) {
            return ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              child: Material(
                color: const Color(0xFF1C1C1E),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: _SubWidget(controller: scrollController),
                ),
              ),
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
    widget.controller.addListener(_onCommunitiesScrollToEnd);
  }

  void _onCommunitiesScrollToEnd() {
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
        Container(
          width: double.infinity,
          color: const Color(0xFF1C1C1E),
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  width: 38,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                ATStrings.addCommunity,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.39,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                        itemCount: (hasMoreItems ? count + 1 : count) + 1,
                        itemBuilder: (_, int index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 25),
                              child: ATRichText(
                                maxLines: 4,
                                items: <String, TextStyle>{
                                  ATStrings.addCommunityDesc: context
                                      .textTheme.labelSmall!
                                      .copyWith(
                                          color: ATColors.hexC2C2C2
                                              .withValues(alpha: 0.76)),
                                  ATStrings.learnMore:
                                      context.textTheme.labelSmall!
                                },
                                textOnTap: (String text) {
                                  if (text == ATStrings.learnMore) {}
                                },
                              ),
                            );
                          }

                          final int itemIndex = index - 1;
                          if (itemIndex < count) {
                            final String id = communityIds[itemIndex];
                            final Community? community = communities[id];
                            return GestureDetector(
                              onTap: () => context.pop(community),
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  children: <Widget>[
                                    ClipSmoothRect(
                                      radius: SmoothBorderRadius(
                                        cornerRadius: 5,
                                        cornerSmoothing: 0.8,
                                      ),
                                      child: ATImgLoader(
                                          width: 70,
                                          height: 50,
                                          imgPath: community?.image ?? '',
                                          boxFit: BoxFit.cover),
                                    ),
                                    const SizedBox(width: 15),
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
        ),
      ],
    );
  }
}
