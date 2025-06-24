import 'dart:io';
import 'dart:ui';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/font_sizes.dart';
import '../../../../utils/constants/font_weights.dart';
import '../../../../utils/constants/strings/image_strings.dart';
import '../../../../utils/constants/strings/other_strings.dart';
import '../../../../utils/helpers/helper_functions/helper_functions.dart';
import '../../../../views/widgets/common_widgets/app_bar_widget.dart';
import '../../../../views/widgets/common_widgets/circle_avatar.dart';
import '../../../../views/widgets/common_widgets/custom_container_widget.dart';
import '../../../../views/widgets/common_widgets/elevated_button_widget.dart';
import '../../../../views/widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import '../../../../views/widgets/common_widgets/row_of_people_listening_widget.dart';
import '../../home_export.dart';
import '../widgets/event_or_show_card.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_show_or_event_full_details_view/hashtags_widget.dart';
import '../widgets/live_and_society_widget.dart';
import '../widgets/whispers_list.dart';

class ATLiveEventDetailedScreen extends StatelessWidget {
  const ATLiveEventDetailedScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 250, sigmaY: 250),
                  child: const ATImgLoader(
                    boxFit: BoxFit.fill,
                    imgPath: ATImgStrings.JOE_POMP_SHOW
                  ),
                ),
              ),
              
              ATContainer(
                color: ATColors.hex0D0D0D.withValues(alpha: 0.75),
                child: BlocProvider<ScrollResponsiveBlurredHeaderBloc>(
                  create: (_) => ScrollResponsiveBlurredHeaderBloc(),
                  child: Builder(
                    builder: (BuildContext blocContext) {
                      return NotificationListener<ScrollNotification>(
                        onNotification: blocContext.read<ScrollResponsiveBlurredHeaderBloc>().onScrollNotification,
                        child: NestedScrollView(
                          headerSliverBuilder: (_, __) => <Widget>[
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: ATSliverHDelegate(
                                maxExt: kToolbarHeight, minExt: kToolbarHeight,
                                child:const ScrollResponsiveBlurredHeader()
                              ),
                            )
                          ],
                          
                          body: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const ATEventOrShowCard(imgPath: ATImgStrings.JOE_POMP_SHOW,),
                                      const SizedBox(height: 15),
                                      Text(
                                        maxLines: 2,
                                        "Figma Confiq 2024",
                                        overflow: TextOverflow.clip,
                                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                          fontSize: ATFontSizes.size24,
                                          fontWeight: ATFontWeights.w600,
                                        ),
                                      ),
                                
                                      const SizedBox(height: 20),
                                      const LiveIndicatorRow(text2: ATStrings.TECHNOLOGY),              
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
                                      ...List<Widget>.generate(
                                        1,
                                        (_) => const TileWithLeadingImage(
                                          padding: EdgeInsets.symmetric(vertical: 9),
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
                                const ATWhispersWidget(),

                                const SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        ATStrings.GOT_TICKET_ID,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          fontSize: ATFontSizes.size17
                                        ),  
                                      ),
                                      Divider(color: ATColors.white.withOpacity(0.1),),
                                      const SizedBox(height: 5),
                                      ATTextFormField(
                                        controller: TextEditingController(),
                                        hintText: 'Enter your Ticked ID',
                                        maxLines: 1,
                                        prefixIcon: const SizedBox(width: 15,),
                                        suffixIcon: const Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 15),
                                            child: ATLoadingIndicator(size: 18,),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: BorderSide(color: ATColors.trsprnt)
                                        )
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
                        ),
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
        
        resizeToAvoidBottomInset: false,

        bottomSheet: ATContainer(
          height: 90, //color: Colors.red,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              ATColors.hex0D0D0D.withValues(alpha: 0.1),
              ATColors.hex0D0D0D
            ]
          ),
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
          child: ATPlainElevatedBtn(
            bgColor: ATColors.white,
            fgColor: ATColors.hex0D0D0D,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  ATStrings.PAY,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: ATFontSizes.size17,
                    color: ATColors.black
                  ),
                ),
                const SizedBox(width: 5,),
                ATCircleAvatar(diameter: 5, color: ATColors.black,),
                const SizedBox(width: 5,),
                Text(
                  '₦5,000',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: ATFontSizes.size17,
                    color: ATColors.black
                  ),
                ),
              ],
            ),
            onPressed: (){}
          ),
        ),
      ),
    );
  }
}