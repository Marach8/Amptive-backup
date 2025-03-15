import 'dart:io';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/font_sizes.dart';
import '../../../../../../utils/constants/font_weights.dart';
import '../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../../utils/helpers/helper_functions/helper_functions.dart';
import '../../../../../widgets/common_widgets/app_bar_widget.dart';
import '../../../../../widgets/common_widgets/custom_container_widget.dart';
import '../../../../../widgets/common_widgets/elevated_button_widget.dart';
import '../../../../../widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import '../../../../../widgets/common_widgets/row_of_people_listening_widget.dart';
import '../../../../../widgets/other_widgets/main_application_widgets/widgets_in_show_or_event_full_details_view/audio_or_video_display_picture_widget.dart';
import '../../../../../widgets/other_widgets/main_application_widgets/widgets_in_show_or_event_full_details_view/hashtags_widget.dart';
import '../../../../../widgets/other_widgets/main_application_widgets/widgets_in_show_or_event_full_details_view/row_of_live_and_society_texts_widget.dart';
import '../../../../../widgets/other_widgets/main_application_widgets/widgets_in_show_or_event_full_details_view/whispers_list_view_widget.dart';

class AmptiveEventDetailedScreen extends StatelessWidget {
  const AmptiveEventDetailedScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: AmptiveAppBar(
          hideLeading: true,
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              ATHelperFuncs.hideAnyMountedSnackbar(context);
              context.pop();
            },
            child: Platform.isAndroid
              ? Icon(
                Icons.keyboard_arrow_down,
                color: ATColors.white.withOpacity(0.6),
              )
              : ATContainer(
                margin: const EdgeInsets.symmetric(vertical: 10),
                radius: 5, height: 4, width: 30,
                color: ATColors.white.withOpacity(0.6),
                child: const SizedBox.shrink(),
              ),
          ),
        ),
        
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const EventOrShowDisplay(),
                    Gap(15.h),
                    Text(
                      maxLines: 2,
                      "Figma Confiq 2024",
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: ATFontSizes.size24,
                        fontWeight: ATFontWeights.w600,
                        fontFamily: "Bricolage Grotesque"
                      ),
                    ),
              
                    Gap(20.h),
                    const AmptiveRowOfTwoIconsAndTwoTextsWidget(
                      text2: ATStrings.TECHNOLOGY,
                    ),
              
                    Gap(30.h),
              
                    Text(
                      ATStrings.hashtags,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATFontSizes.size17
                      ),  
                    ),
                    Divider(color: ATColors.white.withOpacity(0.1),),
                    const Gap(5),
                    const AmptiveHashtagsWidget(),
              
                    Gap(20.h),
              
                    Text(
                      ATStrings.hostedBy,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATFontSizes.size17
                      ),  
                    ),
                    Divider(color: ATColors.white.withOpacity(0.1),),
                    ...List.generate(
                      1,
                      (_) => AmptiveListTileWithLeadingPictureWidget(
                        padding: const EdgeInsets.symmetric(vertical: 9).r,
                        title: 'Gerald',
                        subtitle: 'Host',
                        diameter: 35,
                        leadingImagePath: ATImgStrings.jpeg1,
                      )
                    ),
                    Gap(30.h),
              
                    Text(
                      '12528 Listening',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATFontSizes.size17
                      ),  
                    ),
                    Divider(color: ATColors.white.withOpacity(0.1),),
                    Gap(10.h),
                    const AmptiveRowOfNumberOfPeopleListeningWidget(
                      showNumberInsideContainer: true,
                    ),
                    
                    Gap(20.h),
                    Text(
                      'daniel, jessica, gerald, peter and 652 more',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ATColors.white.withOpacity(0.6)
                      ),
                    ),
                    Gap(35.h),
              
                    Text(
                      'About Event',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATFontSizes.size17
                      ),  
                    ),
                    Divider(color: ATColors.white.withOpacity(0.1),),
                    ReadMoreText(
                      'Jessica Yellin, founder of the Webby-Award Winning Independent News Brand, News Not Noise, returns to walk us through what is going on right now in the political landscape.',
                      trimMode: TrimMode.Length,
                      trimExpandedText: ATStrings.showLess,
                      trimCollapsedText: ATStrings.showMore,
                      colorClickableText: ATColors.white,
                      trimLength: 100,
                      style: TextStyle(
                        color: ATColors.white.withOpacity(0.6),
                        fontSize: ATFontSizes.size14,
                        fontWeight: ATFontWeights.w500,
                      ),
                    ),
                    Gap(30.h),
              
                    Text(
                      ATStrings.WHISPERS,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATFontSizes.size17
                      ),  
                    ),
                    Divider(color: ATColors.white.withOpacity(0.1),),
                  ],
                ),
              ),
              const AmptiveWhispersListViewWidget(),
              Gap(30.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ATStrings.gotATicketId,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATFontSizes.size17
                      ),  
                    ),
                    Divider(color: ATColors.white.withOpacity(0.1),),
                    Gap(5.h),
                    AmptiveTextFormFieldWidget(
                      controller: TextEditingController(),
                      hintText: 'Enter your Ticked ID',
                      suffixIcon: const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: AmptiveLoadingIndicatorWidget(),
                      ),
                    ),
                    Gap(10.h),
                    ReadMoreText(
                      'If you already paid for this event on our website, you should have received a Ticket ID. Kindly enter your Ticket Id in the input field about to access the event...',
                      trimMode: TrimMode.Length,
                      trimExpandedText: ATStrings.showLess,
                      trimCollapsedText: 'Learn more about Ticked ID',
                      colorClickableText: ATColors.white,
                      trimLength: 100,
                      style: TextStyle(
                        color: ATColors.white.withOpacity(0.6),
                        fontSize: ATFontSizes.size14,
                        fontWeight: ATFontWeights.w500,
                      ),
                    ),
                    Gap(100.h)
                  ],
                ),
              ),
              
            ],
          ),
        ),
        bottomSheet: AmptiveElevatedButtonWidget(
          margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          bgColor: ATColors.white,
          fgColor: ATColors.brandBlack,
          text1: 'Pay', text2: 'N5,000',
          onPressed: (){}
        ),
      ),
    );
  }
}