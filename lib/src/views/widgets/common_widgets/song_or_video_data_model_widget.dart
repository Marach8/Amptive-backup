import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/live_indicator_with_animating_dot_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/dark_color_gradient_container_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/list_tile_with_trailing_more_icon_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/row_of_paid_show_and_play_button_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/row_of_people_listening_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/with_2_others_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AmptiveSongOrVideoDataModelWidget extends StatelessWidget {
  const AmptiveSongOrVideoDataModelWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AmptiveListTileWithTrailingMoreIconWidget(),
        SizedBox(
          height: 2.h,
        ),
        SizedBox(
          height: 400.h,
          width: 360.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: 360.h,
                  width: 360.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const AmptiveImageLoaderWidget(
                    imagePath: AmptiveImageStrings.weCanDoHardThingsBigPicture,
                    boxFit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                top: 227.h,
                child: const AmptiveDarkColorGradientContainerWidget(),
              ),
              Positioned(
                top: 227.h,
                left: 0.w,
                right: 0.w,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 17.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AmptiveLiveIndicatorWithAnimatingDotWidget(),
                      Gap(10.h),
                      Text(
                        maxLines: 2,
                        "Don't Forget Who You Are ft. Jacob Scipio",
                        overflow: TextOverflow.clip,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: AmptiveFontSizes.size24,
                                fontWeight: AmptiveFontWeights.semiBold,
                                fontFamily: "Bricolage Grotesque"),
                      ),
                      Gap(12.h),
                      const AmptiveRowOfNumberOfPeopleListeningWidget(),
                      Gap(10.h),
                      const AmptiveRowOfPaidShowAndPlayButtonWidget(),
                      Gap(15.h),

                    ],
                  ),
                ),
              ),
              const Positioned(
                top: 10,
                left: 15,
                child: AmptiveWith2OthersWidget(),
              )
            ],
          ),
        )
      ],
    );
  }
}
