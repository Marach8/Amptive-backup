import 'dart:ui';
import 'package:amptive/src/features/home/home_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import '../../../../views/widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import '../../../../views/widgets/common_widgets/sliver_header_delegate.dart';

class PreviewShowScreen extends StatelessWidget {

  const PreviewShowScreen({super.key, required this.coverArt});

  final String coverArt;

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
                child: ATImgLoader(
                  boxFit: BoxFit.fill,
                  imgPath: coverArt
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
                              child: ATBlurredHeaderWidget(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: ATRoundedBackBtn(bgColor: ATColors.trsprnt,),
                                    ),
                                    Text(
                                      'We can do hard things',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(width: 30,)
                                  ],
                                ),
                              )
                            ),
                          )
                        ],
        
                        body: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ATEventOrShowCard(imgPath: coverArt,),
                                    const SizedBox(height: 24),
                                    ShowOrEventIndicatorWithTitle(
                                      leading: ATContainer(
                                        height: 20, width: 20,
                                        color: ATColors.hexFF6482,
                                        child: const ATImgLoader(imgPath: ATImgStrings.CALENDER_ICON),
                                      )
                                    ),
                                    const SizedBox(height: 12,),
                                    Text(
                                      maxLines: 2,
                                      "Don't Forget Who You Are ft. Jacob Scipio",
                                      overflow: TextOverflow.clip,
                                      style: context.textTheme.displayMedium?.copyWith(
                                        fontSize: ATFontSizes.size24,
                                        fontWeight: ATFontWeights.w600,
                                      ),
                                    ),
                              
                                    const SizedBox(height: 12,),
                                    const LiveIndicatorRow(),                                
                                    const SizedBox(height: 40,),
                              
                                    Text(
                                      ATStrings.HASHTAGS,
                                      style: context.textTheme.bodySmall?.copyWith(
                                        fontSize: ATFontSizes.size17
                                      ),  
                                    ),
                                    Divider(color: ATColors.white.withValues(alpha:0.1),),
                                    const SizedBox(height: 5),
                                    const ATHashtagsWidget(),
                                    const SizedBox(height: 30,),
                              
                                    Text(
                                      ATStrings.HOSTED_BY,
                                      style: context.textTheme.bodySmall?.copyWith(
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
                                      style: context.textTheme.bodySmall?.copyWith(
                                        fontSize: ATFontSizes.size17
                                      ),  
                                    ),
                                    Divider(color: ATColors.white.withValues(alpha: 0.1),),
                                    const SizedBox(height: 10,),
                                    
                                    const NoOfListenersWidget(),
                                    
                                    const SizedBox(height: 20,),
                                    Text(
                                      'daniel, jessica, gerald, peter and 652 more',
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: ATColors.white.withValues(alpha: 0.6)
                                      ),
                                    ),
                                    const SizedBox(height: 35,),
                              
                                    Text(
                                      'About Episode',
                                      style: context.textTheme.bodySmall?.copyWith(
                                        fontSize: ATFontSizes.size17
                                      ),  
                                    ),
                                    Divider(color: ATColors.white.withValues(alpha: 0.1),),
                                    ReadMoreText(
                                      'Jessica Yellin, founder of the Webby-Award Winning Independent News Brand, News Not Noise, returns to walk us through what is going on right now in the political landscape.',
                                      trimMode: TrimMode.Length,
                                      trimExpandedText: ATStrings.showLess,
                                      trimCollapsedText: ATStrings.showMore,
                                      colorClickableText: ATColors.white,
                                      trimLength: 100,
                                      style: TextStyle(
                                        color: ATColors.white.withValues(alpha: 0.6),
                                        fontSize: ATFontSizes.size14,
                                        fontWeight: ATFontWeights.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 30,),
                              
                                    Text(
                                      ATStrings.WHISPERS,
                                      style: context.textTheme.bodySmall?.copyWith(
                                        fontSize: ATFontSizes.size17
                                      ),  
                                    ),
                                    Divider(color: ATColors.white.withValues(alpha: 0.1),),
                                  ],
                                ),
                              ),
                              const ATWhispersWidget(),
                              const SizedBox(height: 70,),
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

        bottomSheet: ATBlurredBgBtn(
          onPressed: (){},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                ATStrings.SUBSCRIBE,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: ATFontSizes.size17,
                  color: ATColors.black
                ),
              ),
              const SizedBox(width: 5,),
              ATCircleAvatar(diameter: 5, color: ATColors.black,),
              const SizedBox(width: 5,),
              Text(
                '₦1,900/month',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: ATFontSizes.size17,
                  color: ATColors.black
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
