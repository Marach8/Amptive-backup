import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/live_indicator_with_animating_dot_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/png_jpeg_asset_loader_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/dark_color_gradient_container_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/list_tile_with_trailing_more_icon_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/row_of_paid_show_and_play_button_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/row_of_people_listening_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/with_2_other_widget.dart';
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
        Container(
          clipBehavior: Clip.hardEdge,
          height: 455.h,
          width: 360.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: 360.h,
                  width: 360.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: const AmptivePngAndJpegAssetLoaderWidget(
                    pngOrJpegPath: AmptiveImageStrings.weCanDoAllThingsJpg,
                    boxFit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                top: 227.h,
                right: 0,
                left: 0,
                child: SizedBox(
                  width: 360.w,
                    child: const AmptiveDarkColorGradientContainerWidget()),
              ),
              Positioned(
                top: 227.h,
                left: 0,
                right: 0,
                child: Container(
                  width: 360.w,
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
                          height: 1.25.sp,
                               ),
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
              Positioned(
                top: 15.h,
                left: 17.w,
                child: const AmptiveWith2OthersWidget(),
              )
            ],
          ),
        )
      ],
    );
  }
}
