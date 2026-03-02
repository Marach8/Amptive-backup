import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/live_indicator_with_animating_dot_widget.dart';
import 'package:amptive/src/shared/list_tile_with_leading_picture_widget.dart';
import 'package:amptive/src/features/home/presentation/widgets/row_of_paid_show_and_play_button_widget.dart';
import 'package:amptive/src/shared/row_of_people_listening_widget.dart';
import 'package:amptive/src/features/home/presentation/widgets/with_2_others_widget.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import 'program_actions_modal.dart';

class ATShowOrEventInfo extends StatelessWidget {
  const ATShowOrEventInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TileWithLeadingImage(
          leadingImagePath: ATImgStrings.jpeg3,
          trailingOnPressed: () {
            
          },
          title: 'glennodoyle',
          subtitle: 'started a live show',
        ),
        const SizedBox(height: 2,),
        ATContainer(
          height: 425,
          clipBehavior: Clip.hardEdge,
          radius: 15,
          child: Stack(
            children: <Widget>[
              const ATImgLoader(imgPath: ATImgStrings.weCanDoHardThingsBgImage),
              ATContainer(
                width: ATHelperFuncs.getScreenWidth(context),
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                radius: 15,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const With2OthersWidget(),
                    const Spacer(),
                    const LiveWithAnimatingDot(),
                    const SizedBox(height: 10),
                    Text(
                      maxLines: 2,
                      "Don't Forget Who You Are ft. Jacob Scipio",
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
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
