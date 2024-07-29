import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
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
            
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              height: 420,
              width: AmptiveHelperFunctions.getScreenWidth(context),                                
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const AmptivePngAndJpegAssetLoaderWidget(
                pngOrJpegPath: AmptiveImageStrings.jpeg2,
                boxFit: BoxFit.cover,
              ),
            ),
            
            const AmptiveDarkColorGradientContainerWidget(),
    
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [    
                  const AmptiveLiveIndicatorWithAnimatingDotWidget(),    
                  Gap(10.h),
                  Text(
                    maxLines: null,
                    "Don't Forget Who You Are ft. Jacob Scipio",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
    
                  Gap(10.h),
                  const AmptiveRowOfNumberOfPeopleListeningWidget(),
    
                  Gap(10.h),
                  const AmptiveRowOfPaidShowAndPlayButtonWidget(),
                ],
              ),
            ),
    
            const Positioned(
              top: 10,
              left: 15,
              child: AmptiveWith2OthersWidget()
            )
          ],
        )
      ],
    );
  }
}
