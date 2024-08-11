import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/container_for_rendering_other_widgets.dart';
import 'package:amptive/src/views/widgets/common_widgets/live_indicator_with_animating_dot_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/row_of_paid_show_and_play_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/row_of_people_listening_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/with_2_others_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../utils/constants/colors.dart';

class AmptiveSongOrVideoDataModelWidget extends StatelessWidget {
  const AmptiveSongOrVideoDataModelWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AmptiveListTileWithLeadingPictureWidget(
          leadingImagePath: AmptiveImageStrings.jpeg3,
          trailingOnPressed: (){},
          title: 'glennodoyle',
          subtitle: 'Started a live show',
        ),
        Gap(2.h),
        AmptiveCustomContainer(
          decorationImagePath: AmptiveImageStrings.weCanDoHardThingsBgImage,
          decorationImageFit: BoxFit.fill,
          height: 432.h,
          radius: 15.r,
          child: AmptiveCustomContainer(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            radius: 15.r,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AmptiveColors.transparentColor,
                AmptiveColors.transparentColor,
                AmptiveColors.transparentColor,
                AmptiveColors.transparentColor,
                AmptiveColors.containerGradientColorB.withOpacity(0.5),
                AmptiveColors.containerGradientColorB,
                AmptiveColors.containerGradientColorB,
                AmptiveColors.containerGradientColorB,
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AmptiveWith2OthersWidget(),
                const Spacer(),
                const AmptiveLiveIndicatorWithAnimatingDotWidget(),
                Gap(10.h),
                Text(
                  maxLines: 2,
                  "Don't Forget Who You Are ft. Jacob Scipio",
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: AmptiveFontSizes.size24,
                    fontWeight: AmptiveFontWeights.semiBold,
                    fontFamily: "Bricolage Grotesque"
                  ),
                ),
                Gap(12.h),
                const AmptiveRowOfNumberOfPeopleListeningWidget(),
                Gap(10.h),
                const AmptiveRowOfPaidShowAndPlayButtonWidget(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
