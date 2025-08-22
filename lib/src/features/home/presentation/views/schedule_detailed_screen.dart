import 'dart:ui';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/home/home_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../config/utils/font_weights.dart';
import '../../../../views/widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import '../../../../views/widgets/common_widgets/sliver_header_delegate.dart';
import '../../../../shared/hashtags_widget.dart';
import '../widgets/home_widgets_export.dart';

class ATScheduleDetailedScreen extends StatelessWidget {
  const ATScheduleDetailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight = kToolbarHeight + MediaQuery.paddingOf(context).top;
    return ATAnnotatedRegion(
      statusBarColor: ATColors.trsprnt,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 250, sigmaY: 250),
                child: const ATImgLoader(
                  boxFit: BoxFit.fill,
                  imgPath: ATImgStrings.weCanDoHardThingsBgImage,
                ),
              ),
            ),
            ATContainer(
              color: ATColors.hex0D0D0D.withValues(alpha: 0.75),
              child: BlocProvider<BlurredHeaderBloc>(
                create: (_) => BlurredHeaderBloc(),
                child: Builder(
                  builder: (BuildContext blocContext) {
                    return NotificationListener<ScrollNotification>(
                      onNotification: blocContext.read<BlurredHeaderBloc>().onScrollNotification,
                      child: NestedScrollView(
                        headerSliverBuilder: (_, __) => <Widget>[
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: ATSliverHDelegate(
                              maxExt: blurredHeaderHeight, minExt: blurredHeaderHeight,
                              child:const ATBlurredHeaderWidget()
                            ),
                          )
                        ],
        
                        body: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, kBottomNavigationBarHeight * 1.5),
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const ATEventOrShowCard(),
                              const SizedBox(height: 24),
                              //const ShowOrEventIndicatorWithTitle(),
                              //const SizedBox(height: 12,),
                              Text(
                                maxLines: 2,
                                "Don't Forget Who You Are ft. Jacob Scipio",
                                overflow: TextOverflow.clip,
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontSize: ATFontSizes.size24,
                                  fontWeight: ATFontWeights.w600,
                                ),
                              ),
                                                      
                              const SizedBox(height: 12,),
                              const ScheduleDateIndicator(),
                              const SizedBox(height: 40,),
                                                      
                              Text(
                                ATStrings.HASHTAGS,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: ATFontSizes.size17
                                ),  
                              ),
                              Divider(color: ATColors.white.withValues(alpha:0.1),),
                              const SizedBox(height: 5),
                              const ATHashtagsWidget(),
                              const SizedBox(height: 30,),
                                                      
                              Text(
                                ATStrings.HOSTED_BY,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: ATFontSizes.size17
                                ),  
                              ),
                              Divider(color: ATColors.white.withValues(alpha:0.1),),
                              ...List<Widget>.generate(
                                3,
                                (_) => const TileWithLeadingImage(
                                  padding: EdgeInsets.symmetric(vertical: 9),
                                  title: 'Gerald',
                                  subtitle: 'Host',
                                  diameter: 42,
                                  leadingImagePath: ATImgStrings.jpeg1,
                                )
                              ),
                              const SizedBox(height: 30,),
                                                      
                              Text(
                                '656 Listening',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: ATFontSizes.size17
                                ),  
                              ),
                              Divider(color: ATColors.white.withValues(alpha: 0.1),),
                              const SizedBox(height: 10,),
                              
                              const NoOfListenersWidget(),
                              
                              const SizedBox(height: 20,),
                              Text(
                                'daniel, jessica, gerald, peter and 652 more',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: ATColors.white.withValues(alpha: 0.6)
                                ),
                              ),
                              const SizedBox(height: 35,),
                                                      
                              Text(
                                'About Episode',
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

        bottomSheet: ATContainer(
          height: 90,
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
            btnTitle: 'Add to Calender',
            onPressed: (){}
          ),
        ),
      ),
    );
  }
}
