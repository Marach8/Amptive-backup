import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/container_for_rendering_other_widgets.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/two_texts_rich_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import '../../../../utils/constants/font_sizes.dart';
import '../../../../utils/constants/font_weights.dart';
import '../../../widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import '../../../widgets/common_widgets/row_of_people_listening_widget.dart';
import '../../../widgets/other_widgets/main_application_widgets/widgets_in_video_or_audio_details_view/whispers_list_view_widget.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AmptiveCustomContainer(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.topRight,
                        height: 360.h,
                        radius: 16,
                        decorationImagePath: AmptiveImageStrings.weCanDoHardThingsBgImage,
                        child: GestureDetector(                      
                          onTap: (){context.pop();},
                          child: AmptiveCustomContainer(
                            height: 32, width: 32,
                            boxShape: BoxShape.circle,
                            color: AmptiveColors.brandBlackColor.withOpacity(0.7),
                            child: const Icon(Icons.more_horiz),
                          ),
                        ),
                      ),
                      Gap(30.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.sIcon),
                          const Gap(5),
                          Text(
                            'We Can Do Hard Things',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontSize: AmptiveFontSizes.size15,
                              color: AmptiveColors.dimWhiteColor1
                            ),
                          ),
                          const Gap(5),
                          const Icon(Icons.arrow_forward_ios_sharp, size: 12, weight: 20,)
                        ],
                      ),
                      Gap(15.h),
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
                
                      Gap(20.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AmptiveImageLoaderWidget(
                            imagePath: AmptiveImageStrings.spreadNetworkIcon,
                            height: 24, width: 24,
                          ),
                          const Gap(5),
                          Text(
                            AmptiveOtherStrings.live.toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AmptiveColors.grey5Color,
                              fontSize: AmptiveFontSizes.size14
                            ),  
                          ),
                          const Gap(20),
                          Icon(Icons.groups, color: AmptiveColors.grey5Color),
                          const Gap(5),
                          Text(
                            AmptiveOtherStrings.society.toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AmptiveColors.grey5Color,
                              fontSize: AmptiveFontSizes.size14
                            ),  
                          ),
                        ],
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
                      Wrap(
                        alignment: WrapAlignment.start,
                        textDirection: TextDirection.ltr,
                        children: List.generate(
                          5,
                          (_) => AmptiveCustomContainer(
                            alignment: Alignment.center,
                            radius: 10,
                            height: 36,
                            width: 100,
                            color: AmptiveColors.whiteColor.withOpacity(0.1),
                            child: AmptiveTwoTextRichTextWidget(
                              text1: '# ',
                              text2: AmptiveOtherStrings.society,
                              style1: Theme.of(context).textTheme.bodyMedium,
                              style2: Theme.of(context).textTheme.bodySmall,
                            )
                          ),
                        )
                      ),
                
                      Gap(30.h),
                
                      Text(
                        AmptiveOtherStrings.hostedBy,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: AmptiveFontSizes.size17
                        ),  
                      ),
                      Divider(color: AmptiveColors.whiteColor.withOpacity(0.1),),
                      ...List.generate(
                        3,
                        (_) => const AmptiveListTileWithLeadingPictureWidget(
                          title: 'Gerald',
                          subtitle: 'Host',
                          leadingImagePath: AmptiveImageStrings.jpeg1,
                        )
                      ),
                      Gap(30.h),
                
                      Text(
                        '656 Listening',
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
                        'About Episode',
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
                const Gap(30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
