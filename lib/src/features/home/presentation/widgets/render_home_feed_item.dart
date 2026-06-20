import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/shared/overlapping_widgets.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/live_indicators.dart';
import 'package:amptive/src/shared/list_tile_with_leading_picture_widget.dart';
import 'package:amptive/src/features/home/presentation/widgets/row_of_paid_show_and_play_button_widget.dart';
import 'package:amptive/src/shared/row_of_people_listening_widget.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:amptive/src/features/home/presentation/widgets/with_2_others_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/utils/colors.dart';
import 'program_actions_modal.dart';

class RenderHomeFeedItem extends StatelessWidget {
  const RenderHomeFeedItem({
    super.key,
    required this.homeFeedItem,
  });

  final HomeFeedItem homeFeedItem;


  @override
  Widget build(BuildContext context) {
    final String? userId = context
      .read<LocalUserDataCubit>().currentUserData?.userId;

    final String? hostName = homeFeedItem.hostId == userId ? 'You' 
      : homeFeedItem.hostName;
    final bool isLive = homeFeedItem.programStatus == ProgramStatus.live;
    
    final String description = getProgramActivityDescription(
      programStatus: homeFeedItem.programStatus,
      programType: homeFeedItem.programCategory,
      episodeNumber: homeFeedItem.episodeNumber,
      scheduledFor: homeFeedItem.scheduledFor,
      startedAt: homeFeedItem.startedAt,
    );
    
    return Column(
      children: <Widget>[
        TileWithLeadingImage(
          leadingImagePath: 
            homeFeedItem.hostProfileImageUrl ?? ATImgStrings.noAvatarImage,
          trailingOnPressed: () async {
            final SelectedProgramAction? selectedOption =
                await showProgramOptions(
              context: context,
              toggleFollowingCubit: context.read<ToggleFollowingCubit>(),
              targetUserName: homeFeedItem.hostName ?? '',
              targetUserId: homeFeedItem.hostId ?? '',
            );
          },
          title: hostName ?? '',
          subtitle: description,
        ),
        const SizedBox(height: 2),
        Container(
            height: 425,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15)),
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: homeFeedItem.coverUrl
                    ?? homeFeedItem.thumbnailUrl ?? '',
                  child: ATImgLoader(
                    imgPath: homeFeedItem.coverUrl
                      ?? homeFeedItem.thumbnailUrl ?? '',
                    boxFit: BoxFit.cover,
                    height: 425,
                    width: context.screenWidth,
                  ),
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
                      With2OthersWidget(
                        coHostCount: homeFeedItem.cohosts?.length
                      ),
                      const Spacer(),
                      if (isLive) ...<Widget>[
                        const LiveIndicatorWithAnimatingDot(),
                        const SizedBox(height: 10),
                      ],

                      Text(
                        maxLines: 2,
                        homeFeedItem.title ?? '',
                        style: context.textTheme.displayMedium?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      
                      if((homeFeedItem.avatarUrls ?? <String>[]).isNotEmpty) 
                      ...<Widget>[
                        const SizedBox(height: 12),
                        PeopleListeningOrGoing(item: homeFeedItem)
                      ],
                      const SizedBox(height: 10),
                      PaidShowAndPlayBtnWidget(homeFeedItem: homeFeedItem),
                    ],
                  ),
                ),
              ],
            ))
      ],
    );
  }
}

class RenderHomeFeedItemShimmer extends StatelessWidget {
  const RenderHomeFeedItemShimmer({super.key});

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
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: ATColors.black.withValues(alpha: 0.7)),
                        child:
                            const ATShimmer(height: 10, width: 70, radius: 3),
                      ),
                      const Spacer(),
                      const LiveIndicatorWithAnimatingDot(),
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



String getProgramActivityDescription({
  ProgramCategory? programType,
  ProgramStatus? programStatus,
  int? episodeNumber,
  String? scheduledFor,
  String? startedAt,
}) {
  return switch ((programType, programStatus)) {
    (ProgramCategory.standalone, ProgramStatus.draft) =>
      'created a draft event',

    (ProgramCategory.standalone, ProgramStatus.scheduled) =>
      'scheduled an event (${ATHelperFuncs.formatOrdinalDateTime(scheduledFor)})',

    (ProgramCategory.standalone, ProgramStatus.live) =>
      'started a live event (${ATHelperFuncs.formatOrdinalDateTime(startedAt)})',

    (ProgramCategory.standalone, ProgramStatus.ended) =>
      'ended an event',

    (ProgramCategory.standalone, ProgramStatus.cancelled) =>
      'cancelled an event',

    (ProgramCategory.episode, ProgramStatus.draft) =>
      'created a draft show (episode ${episodeNumber ?? ''})',

    (ProgramCategory.episode, ProgramStatus.scheduled) =>
      'scheduled a show (episode ${episodeNumber ?? ''} - ${ATHelperFuncs.formatOrdinalDateTime(scheduledFor)})',

    (ProgramCategory.episode, ProgramStatus.live) =>
      'started a live show (episode ${episodeNumber ?? ''} - ${ATHelperFuncs.formatOrdinalDateTime(startedAt)})',

    (ProgramCategory.episode, ProgramStatus.ended) =>
      'ended show (episode ${episodeNumber ?? ''})',

    (ProgramCategory.episode, ProgramStatus.cancelled) =>
      'cancelled show (episode ${episodeNumber ?? ''})',

    _ => '',
  };
}
