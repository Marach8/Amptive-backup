import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/live_indicator_with_animating_dot_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/overlapping_images.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/row_of_paid_show_and_play_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/row_of_people_listening_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/with_2_others_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../services/create_show/create_show_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../utils/constants/strings/route_strings.dart';
import '../../../../../utils/dialogs/options_dialog.dart';
import '../../../../widgets/common_widgets/image_loader_widget.dart';

class FollowedProgram extends StatelessWidget {
  const FollowedProgram({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TileWithLeadingImage(
          leadingImagePath: ATImgStrings.jpeg3,
          trailingOnPressed: (){
            showProgramOptions(context);
          },
          title: 'glennodoyle',
          subtitle: 'scheduled a live show',
        ),
        const SizedBox(height: 2),
        ATContainer(
          height: 425, clipBehavior: Clip.hardEdge, radius: 15,
          child: Stack(
            children: [
              const ATImgLoader(imgPath: ATImgStrings.weCanDoHardThingsBgImage),
              ATContainer(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                radius: 15,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ATColors.trsprnt,
                    ATColors.trsprnt,
                    ATColors.trsprnt,
                    ATColors.trsprnt,
                    ATColors.containerGradientColorB.withOpacity(0.5),
                    ATColors.containerGradientColorB,
                    ATColors.containerGradientColorB,
                    ATColors.containerGradientColorB,
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AmptiveWith2OthersWidget(),
                    const Spacer(),
                    const LiveWithAnimatingDot(),
                    const SizedBox(height: 10,),
                    Text(
                      maxLines: 2,
                      "Don't Forget Who You Are ft. Jacob Scipio",
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: ATFontSizes.size24,
                        fontWeight: ATFontWeights.w600,
                      ),
                    ),
                    const SizedBox(height: 12,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ATOverlappingImages(
                          imgPaths: getHostList().take(3).map(
                            (host) => host.obj.profilePicture ?? ''
                          ).toList(),
                          imgSize: 30, overlapOffset: 18,
                        ),
                        const SizedBox(width: 8,),
                        Text(
                          '656 listening',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: ATFontSizes.size13
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ATContainer(
                          color: ATColors.hex0D0D0D, radius: 5,
                          padding: const EdgeInsets.all(8.5),
                          child: Text(
                            ATStrings.PAID_SHOW.toUpperCase(),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: ATFontWeights.w500,
                              fontSize: ATFontSizes.size10
                            )
                          ),
                        ),
                        ATContainer(
                          onTap: (){},
                          height: 45, width: 45, radius: 30,
                          color: ATColors.authHintColor,
                          child: Icon(
                            Icons.play_arrow,
                            color: ATColors.hex0D0D0D, size: 30,
                          )
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
