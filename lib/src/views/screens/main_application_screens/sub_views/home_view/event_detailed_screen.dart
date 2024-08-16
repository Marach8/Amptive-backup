import 'dart:io';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/font_sizes.dart';
import '../../../../../utils/constants/font_weights.dart';
import '../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../utils/helpers/helper_functions/other_functions.dart';
import '../../../../widgets/common_widgets/app_bar_widget.dart';
import '../../../../widgets/common_widgets/container_for_rendering_other_widgets.dart';
import '../../../../widgets/common_widgets/elevated_button_widget.dart';
import '../../../../widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import '../../../../widgets/common_widgets/row_of_people_listening_widget.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_video_or_audio_details_view/audio_or_video_display_picture_widget.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_video_or_audio_details_view/hashtags_widget.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_video_or_audio_details_view/row_of_live_and_society_texts_widget.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_video_or_audio_details_view/whispers_list_view_widget.dart';

class AmptiveEventDetailedWidget extends StatelessWidget {
  const AmptiveEventDetailedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AmptiveAppBar(
        hideLeading: true,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            AmptiveHelperFunctions.hideAnyMountedSnackbar(context);
            context.pop();
          },
          child: Platform.isAndroid
            ? Icon(
              Icons.keyboard_arrow_down,
              color: AmptiveColors.whiteColor.withOpacity(0.6),
            )
            : AmptiveCustomContainer(
              margin: const EdgeInsets.symmetric(vertical: 10),
              radius: 5, height: 4, width: 30,
              color: AmptiveColors.whiteColor.withOpacity(0.6),
              child: const SizedBox.shrink(),
            ),
        ),
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AmptiveAudioOrVideoDisplayPictureWithMoreIconWidget(),
                  Gap(15.h),
                  Text(
                    maxLines: 2,
                    "Figma Confiq 2024",
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: AmptiveFontSizes.size24,
                      fontWeight: AmptiveFontWeights.semiBold,
                      fontFamily: "Bricolage Grotesque"
                    ),
                  ),
            
                  Gap(20.h),
                  const AmptiveRowOfLiveAndSocietyTextsWidget(
                    text2: AmptiveOtherStrings.technology,
                  ),
            
                  Gap(30.h),
            
                  Text(
                    AmptiveOtherStrings.hashtags,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: AmptiveFontSizes.size17
                    ),  
                  ),
                  Divider(color: AmptiveColors.whiteColor.withOpacity(0.1),),
                  const Gap(5),
                  const AmptiveHashtagsWidget(),
            
                  Gap(20.h),
            
                  Text(
                    AmptiveOtherStrings.hostedBy,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: AmptiveFontSizes.size17
                    ),  
                  ),
                  Divider(color: AmptiveColors.whiteColor.withOpacity(0.1),),
                  ...List.generate(
                    3,
                    (_) => AmptiveListTileWithLeadingPictureWidget(
                      padding: const EdgeInsets.symmetric(vertical: 9).r,
                      title: 'Gerald',
                      subtitle: 'Host',
                      diameter: 35,
                      leadingImagePath: AmptiveImageStrings.jpeg1,
                    )
                  ),
                  Gap(30.h),
            
                  Text(
                    '12528 Listening',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: AmptiveFontSizes.size17
                    ),  
                  ),
                  Divider(color: AmptiveColors.whiteColor.withOpacity(0.1),),
                  Gap(10.h),
                  const AmptiveRowOfNumberOfPeopleListeningWidget(
                    showNumberInsideContainer: true,
                  ),
                  
                  Gap(20.h),
                  Text(
                    'daniel, jessica, gerald, peter and 652 more',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AmptiveColors.whiteColor.withOpacity(0.6)
                    ),
                  ),
                  Gap(35.h),
            
                  Text(
                    'About Event',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: AmptiveFontSizes.size17
                    ),  
                  ),
                  Divider(color: AmptiveColors.whiteColor.withOpacity(0.1),),
                  ReadMoreText(
                    'Jessica Yellin, founder of the Webby-Award Winning Independent News Brand, News Not Noise, returns to walk us through what is going on right now in the political landscape.',
                    trimMode: TrimMode.Length,
                    trimExpandedText: AmptiveOtherStrings.showLess,
                    trimCollapsedText: AmptiveOtherStrings.showMore,
                    colorClickableText: AmptiveColors.whiteColor,
                    trimLength: 100,
                    style: TextStyle(
                      color: AmptiveColors.whiteColor.withOpacity(0.6),
                      fontSize: AmptiveFontSizes.size14,
                      fontWeight: AmptiveFontWeights.medium,
                    ),
                  ),
                  Gap(30.h),
            
                  Text(
                    AmptiveOtherStrings.whispers,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: AmptiveFontSizes.size17
                    ),  
                  ),
                  Divider(color: AmptiveColors.whiteColor.withOpacity(0.1),),
                ],
              ),
            ),
            const AmptiveWhispersListViewWidget(),
            Gap(30.h),
            Text(
              AmptiveOtherStrings.whispers,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: AmptiveFontSizes.size17
              ),  
            ),
            Divider(color: AmptiveColors.whiteColor.withOpacity(0.1),),
            AmptiveTextFormFieldWidget(
              controller: TextEditingController(),
              hintText: 'Enter your Ticked ID',
            ),
            ReadMoreText(
              'Jessica Yellin, founder of the Webby-Award Winning Independent News Brand, News Not Noise, returns to walk us through what is going on right now in the political landscape.',
              trimMode: TrimMode.Length,
              trimExpandedText: AmptiveOtherStrings.showLess,
              trimCollapsedText: 'Learn more about Ticked ID',
              colorClickableText: AmptiveColors.whiteColor,
              trimLength: 100,
              style: TextStyle(
                color: AmptiveColors.whiteColor.withOpacity(0.6),
                fontSize: AmptiveFontSizes.size14,
                fontWeight: AmptiveFontWeights.medium,
              ),
            ),
            const Gap(70)
          ],
        ),
      ),
      bottomSheet: AmptiveElevatedButtonWidget(
        margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
        bgColor: AmptiveColors.whiteColor,
        fgColor: AmptiveColors.brandBlackColor,
        buttonTitle: 'Join live event',
        onPressed: (){}
      ),
    );
  }
}