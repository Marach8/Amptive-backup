import 'dart:io';
import 'dart:ui';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import '../../../../../../utils/constants/font_sizes.dart';
import '../../../../../../utils/constants/font_weights.dart';
import '../../../../../widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import '../../../../../widgets/common_widgets/row_of_people_listening_widget.dart';
import '../../../../../widgets/other_widgets/main_application_widgets/widgets_in_show_or_event_full_details_view/audio_or_video_display_picture_widget.dart';
import '../../../../../widgets/other_widgets/main_application_widgets/widgets_in_show_or_event_full_details_view/hashtags_widget.dart';
import '../../../../../widgets/other_widgets/main_application_widgets/widgets_in_show_or_event_full_details_view/row_of_live_and_society_texts_widget.dart';
import '../../../../../widgets/other_widgets/main_application_widgets/widgets_in_show_or_event_full_details_view/row_of_subtitle_and_forward_icon_widget.dart';
import '../../../../../widgets/other_widgets/main_application_widgets/widgets_in_show_or_event_full_details_view/whispers_list_view_widget.dart';

class ATShowDetailedScreen extends StatelessWidget {
  const ATShowDetailedScreen({super.key});

  @override
  Widget build(context) {
    return ATAnnotatedRegionWidget(
      statusBarColor: ATColors.trspntColor,
      child: Scaffold(
        body: Stack(
          children: [
            const Positioned.fill(
              child: AmptiveImageLoaderWidget(
                boxFit: BoxFit.fill,
                imagePath: ATImgStrings.weCanDoHardThingsBgImage
              )
            ),
            NestedScrollView(
              headerSliverBuilder: (_, __) => [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: ATSliverHDelegate(
                    maxExt: 70, minExt: 70,
                    child: ATContainer(
                      color: ATColors.black.withOpacity(0.8),
                      height: 70,
                      width: ATHelperFuncs.getScreenWidth(context),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              ATHelperFuncs.hideAnyMountedSnackbar(context);
                              context.pop();
                            },
                            child: Platform.isAndroid
                              ? Icon(
                                Icons.keyboard_arrow_down, size: 30,
                                color: ATColors.whiteColor.withOpacity(0.6),
                              )
                              : ATContainer(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                radius: 5, height: 4, width: 30,
                                color: ATColors.whiteColor.withOpacity(0.6),
                                child: const SizedBox.shrink(),
                              ),
                          ),
                        ),
                      ),
                    ),
                  )
                )
              ],
            
              body: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 150.0, sigmaY: 150.0),
                child: Container(
                  color: ATColors.black.withOpacity(0.8),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const ATEventOrShowCard(),
                              const SizedBox(height: 30),
                              const ShowOrEventIndicatorWithTitle(),
                              const SizedBox(height: 15),
                              Text(
                                maxLines: 2,
                                "Don't Forget Who You Are ft. Jacob Scipio",
                                overflow: TextOverflow.clip,
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontSize: AmptiveFontSizes.size24,
                                  fontWeight: AmptiveFontWeights.w600,
                                  fontFamily: "Bricolage Grotesque"
                                ),
                              ),
                                                    
                              const SizedBox(height: 20),
                              const AmptiveRowOfTwoIconsAndTwoTextsWidget(),
                              const SizedBox(height: 30),
                                                    
                              Text(
                                ATStrings.hashtags,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: AmptiveFontSizes.size17
                                ),  
                              ),
                              Divider(color: ATColors.whiteColor.withOpacity(0.1),),
                              const Gap(5),
                              const AmptiveHashtagsWidget(),
                                                    
                              Gap(20.h),
                                                    
                              Text(
                                ATStrings.hostedBy,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: AmptiveFontSizes.size17
                                ),  
                              ),
                              Divider(color: ATColors.whiteColor.withOpacity(0.1),),
                              ...List.generate(
                                3,
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
                                '656 Listening',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: AmptiveFontSizes.size17
                                ),  
                              ),
                              Divider(color: ATColors.whiteColor.withOpacity(0.1),),
                              Gap(10.h),
                              const AmptiveRowOfNumberOfPeopleListeningWidget(
                                showNumberInsideContainer: true,
                              ),
                              
                              Gap(20.h),
                              Text(
                                'daniel, jessica, gerald, peter and 652 more',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: ATColors.whiteColor.withOpacity(0.6)
                                ),
                              ),
                              Gap(35.h),
                                                    
                              Text(
                                'About Episode',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: AmptiveFontSizes.size17
                                ),  
                              ),
                              Divider(color: ATColors.whiteColor.withOpacity(0.1),),
                              ReadMoreText(
                                'Jessica Yellin, founder of the Webby-Award Winning Independent News Brand, News Not Noise, returns to walk us through what is going on right now in the political landscape.',
                                trimMode: TrimMode.Length,
                                trimExpandedText: ATStrings.showLess,
                                trimCollapsedText: ATStrings.showMore,
                                colorClickableText: ATColors.whiteColor,
                                trimLength: 100,
                                style: TextStyle(
                                  color: ATColors.whiteColor.withOpacity(0.6),
                                  fontSize: AmptiveFontSizes.size14,
                                  fontWeight: AmptiveFontWeights.w500,
                                ),
                              ),
                              Gap(30.h),
                                                    
                              Text(
                                ATStrings.WHISPERS,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: AmptiveFontSizes.size17
                                ),  
                              ),
                              Divider(color: ATColors.whiteColor.withOpacity(0.1),),
                            ],
                          ),
                        ),
                        const ATWhispers(),
                        const Gap(70)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomSheet: ATContainer(
          clipBehavior: Clip.hardEdge,
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: AmptivePlainElevatedBtnWidget(
              bgColor: ATColors.whiteColor,
              fgColor: ATColors.brandBlack,
              buttonTitle: 'Subscrible N1,900/month',
              onPressed: (){}
            ),
          ),
        ),
      ),
    );
  }
}