import 'dart:io';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/font_sizes.dart';
import '../../../../../utils/constants/font_weights.dart';
import '../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../utils/helpers/helper_functions/helper_functions.dart';
import '../../../../widgets/common_widgets/app_bar_widget.dart';
import '../../../../widgets/common_widgets/custom_container_widget.dart';
import '../../../../widgets/common_widgets/elevated_button_widget.dart';
import '../../../../widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import '../../../../widgets/common_widgets/row_of_people_listening_widget.dart';
import '../widgets/event_or_show_card.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_show_or_event_full_details_view/hashtags_widget.dart';
import '../widgets/live_and_society_widget.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_show_or_event_full_details_view/whispers_list_view_widget.dart';

class AmptiveEventDetailedScreen extends StatelessWidget {
  const AmptiveEventDetailedScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              ATHelperFuncs.hideAnyMountedSnackbar(context);
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
                    const ATEventOrShowCard(),
                    const SizedBox(height: 15),
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
              
                    const SizedBox(height: 20),
                    const LiveAndSocietyWidget(
                      text2: ATStrings.TECHNOLOGY,
                    ),
              
                    const SizedBox(height: 30),
              
                    Text(
                      ATStrings.HASHTAGS,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATFontSizes.size17
                      ),  
                    ),
                    Divider(color: ATColors.white.withOpacity(0.1),),
                    const SizedBox(height: 5),
                    const AmptiveHashtagsWidget(),
              
                    const SizedBox(height: 20),
              
                    Text(
                      ATStrings.HOSTED_BY,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATFontSizes.size17
                      ),  
                    ),
                    Divider(color: ATColors.white.withOpacity(0.1),),
                    ...List.generate(
                      1,
                      (_) => TileWithLeadingImage(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        title: 'Gerald',
                        subtitle: 'Host',
                        diameter: 35,
                        leadingImagePath: ATImgStrings.jpeg1,
                      )
                    ),
                    const SizedBox(height: 30),
              
                    Text(
                      '12528 Listening',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATFontSizes.size17
                      ),  
                    ),
                    Divider(color: ATColors.white.withOpacity(0.1),),
                    const SizedBox(height: 10),
                    const PeopleListeningWidget(
                      showNumberInsideContainer: true,
                    ),
                    
                    const SizedBox(height: 20),
                    Text(
                      'daniel, jessica, gerald, peter and 652 more',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ATColors.white.withOpacity(0.6)
                      ),
                    ),
                    const SizedBox(height: 35),
              
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
                    const SizedBox(height: 30),
              
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
              const ATWhispers(),
              const SizedBox(height: 30),
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
                    const SizedBox(height: 5),
                    ATTextFormField(
                      controller: TextEditingController(),
                      hintText: 'Enter your Ticked ID',
                      suffixIcon: const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: ATLoadingIndicator(),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 100),
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