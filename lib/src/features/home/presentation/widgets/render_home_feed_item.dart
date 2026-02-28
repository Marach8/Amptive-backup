import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/overlapping_widgets.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/live_indicator_with_animating_dot_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import 'package:amptive/src/features/home/presentation/widgets/row_of_paid_show_and_play_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/row_of_people_listening_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/shimmer.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/with_2_others_widget.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/dialogs/options_dialog.dart';

class RenderHomeFeedItem extends StatelessWidget {
  const RenderHomeFeedItem({
    super.key,
    required this.homeFeedItem,
  });

  final HomeFeedItem homeFeedItem;

  @override
  Widget build(BuildContext context) {
    final bool hasProfilePic = (homeFeedItem.hostProfileImageUrl ?? '').isNotEmpty;
    return Column(
      children: <Widget>[
        TileWithLeadingImage(
          leadingImagePath: hasProfilePic ? 
            homeFeedItem.hostProfileImageUrl! : ATImgStrings.jpeg3,
          trailingOnPressed: () => showProgramOptions(context),
          title: homeFeedItem.hostName ?? '',
          subtitle: 'started a live show',
        ),
        const SizedBox(height: 2,),
        Container(
          height: 425,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: <Widget>[
              ATImgLoader(
                imgPath: homeFeedItem.coverUrl ?? '',
                boxFit: BoxFit.cover,
                height: 425,
                width: context.screenWidth,
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
                      ATColors.containerGradientColorB.withValues(alpha: 0.5),
                      ATColors.containerGradientColorB,
                      ATColors.containerGradientColorB,
                      ATColors.containerGradientColorB,
                    ]
                  ),
                ),                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const AmptiveWith2OthersWidget(),
                    const Spacer(),
                    const LiveWithAnimatingDot(),
                    const SizedBox(height: 10),
                    Text(
                      maxLines: 2,
                      homeFeedItem.title ?? '',
                      style: context.textTheme.displayMedium?.copyWith(
                        fontSize: ATSizes.size24,
                        fontWeight: ATFontWeights.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12,),
                    const PeopleListeningWidget(),
                    const SizedBox(height: 10,),
                    const PaidShowAndPlayBtnWidget(),
                  ],
                ),
              ),
            ],
          )
        )
      ],
    );
  }
}


class RenderHomeFeedItemShimmer extends StatelessWidget {
  const RenderHomeFeedItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const ATShimmer(width: 40, height: 40, radius: 30,),
            Column(
              children: <Widget>[
                ATShimmer(
                  height: 12, radius: 3,
                  width: ATHelperFuncs.getRandomNumber(context.screenWidth * 0.8),
                ),
                const ATShimmer(width: 100, height: 8, radius: 2,),
              ],
            ),
            const ATShimmer(width: 40, height: 2, radius: 1,),
          ],
        ),
        const SizedBox(height: 2,),
        Container(
          height: 425,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: <Widget>[
              const ATShimmer(height: 425, radius: 15,),
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
                      ATColors.containerGradientColorB.withValues(alpha: 0.5),
                      ATColors.containerGradientColorB,
                      ATColors.containerGradientColorB,
                      ATColors.containerGradientColorB,
                    ]
                  ),
                ),                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const ATShimmer(height: 14, width: 80, radius: 4,),
                    const Spacer(),
                    const ATShimmer(height: 20, width: 60, radius: 5,),
                    const SizedBox(height: 10),
                    ATShimmer(
                      height: 20, radius: 6,
                      width: ATHelperFuncs.getRandomNumber(context.screenWidth * 0.9),
                    ),
                    const SizedBox(height: 8,),
                    ATShimmer(
                      height: 20, radius: 6,
                      width: ATHelperFuncs.getRandomNumber(context.screenWidth * 0.8),
                    ),
                    const SizedBox(height: 12,),
                    const OverlappingImagesShimmer(),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Container(
                            padding: const EdgeInsets.all(8.5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: ATColors.hex0D0D0D
                            ),
                            child: const ATShimmer(height: 10, width: 60, radius: 5,),
                          ),
                        ),
                        const ATShimmer(height: 45, width: 45, radius: 30),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        )
      ],
    );
  }
}
