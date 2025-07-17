import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/live_indicator_with_animating_dot_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/row_of_paid_show_and_play_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/row_of_people_listening_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/with_2_others_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/dialogs/options_dialog.dart';

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
          trailingOnPressed: () => showProgramOptions(context),
          title: 'glennodoyle',
          subtitle: 'started a live show',
        ),
        Gap(2.h),
        ATContainer(
          height: 425.h,
          clipBehavior: Clip.hardEdge,
          radius: 15.r,
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
                  children: <Widget>[
                    const AmptiveWith2OthersWidget(),
                    const Spacer(),
                    const LiveWithAnimatingDot(),
                    Gap(10.h),
                    Text(
                      maxLines: 2,
                      "Don't Forget Who You Are ft. Jacob Scipio",
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: ATFontSizes.size24,
                        fontWeight: ATFontWeights.w600,
                        height: 1.2,
                      ),
                    ),
                    Gap(12.h),
                    const PeopleListeningWidget(),
                    Gap(10.h),
                    const AmptiveRowOfPaidShowAndPlayButtonWidget(),
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



// AmptiveCustomContainer(
//             padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
//             radius: 15.r,
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 AmptiveColors.transparentColor,
//                 AmptiveColors.transparentColor,
//                 AmptiveColors.transparentColor,
//                 AmptiveColors.transparentColor,
//                 AmptiveColors.containerGradientColorB.withOpacity(0.5),
//                 AmptiveColors.containerGradientColorB,
//                 AmptiveColors.containerGradientColorB,
//                 AmptiveColors.containerGradientColorB,
//               ]
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const AmptiveWith2OthersWidget(),
//                 const Spacer(),
//                 const AmptiveLiveIndicatorWithAnimatingDotWidget(),
//                 Gap(10.h),
//                 Text(
//                   maxLines: 2,
//                   "Don't Forget Who You Are ft. Jacob Scipio",
//                   overflow: TextOverflow.clip,
//                   style: Theme.of(context).textTheme.displayMedium?.copyWith(
//                     fontSize: AmptiveFontSizes.size24,
//                     fontWeight: AmptiveFontWeights.semiBold,
//                     fontFamily: "Bricolage Grotesque"
//                   ),
//                 ),
//                 Gap(12.h),
//                 const AmptiveRowOfNumberOfPeopleListeningWidget(),
//                 Gap(10.h),
//                 const AmptiveRowOfPaidShowAndPlayButtonWidget(),
//               ],
//             ),
//           ),