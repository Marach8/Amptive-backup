import 'dart:typed_data' show Uint8List;
import 'dart:ui';
import 'package:amptive/src/features/home/presentation/widgets/event_or_show_card.dart';
import 'package:amptive/src/features/home/cubits/empty.dart';
import 'package:amptive/src/features/home/presentation/widgets/live_and_society_widget.dart';
import 'package:amptive/src/features/home/presentation/widgets/show_or_event_indicator_with_title.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import '../../../../views/widgets/common_widgets/list_tile_with_leading_picture_widget.dart';


class EpisodeDetailPreviewScreen extends StatelessWidget {
  const EpisodeDetailPreviewScreen({super.key, required this.coverArtBytes});

  final Uint8List coverArtBytes;

  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight = kToolbarHeight + MediaQuery.paddingOf(context).top;
    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 250, sigmaY: 250),
                child: Image.memory(coverArtBytes, fit: BoxFit.fill)
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
                              child: SizedBox(
                                height: blurredHeaderHeight,
                                child: const ATBlurredHeaderWidget()
                              )
                            ),
                          )
                        ],
                        
                        body: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ATEventOrShowCard(imgPath: coverArtBytes),
                              const SizedBox(height: 24,),
                              const ShowOrEventIndicatorWithTitle(title: 'Blue Blew',),
                              const SizedBox(height: 15),
                              Text(
                                maxLines: 2,
                                "Figma Confiq 2024",
                                overflow: TextOverflow.clip,
                                style: context.textTheme.displayMedium?.copyWith(
                                  fontSize: ATSizes.size24,
                                  fontWeight: ATFontWeights.w600,
                                ),
                              ),
                                                        
                              const SizedBox(height: 20),
                              const ScheduleDateIndicator(),
                              const SizedBox(height: 30),
                                                        
                              Text(
                                ATStrings.HASHTAGS,
                                style: context.textTheme.bodySmall?.copyWith(
                                  fontSize: ATSizes.size17
                                ),  
                              ),
                              Divider(color: ATColors.white.withValues(alpha: 0.1),),
                              const SizedBox(height: 5),
                              const ATHashtagsWidget(),
                                                        
                              const SizedBox(height: 20),
                                                        
                              Text(
                                ATStrings.HOSTED_BY,
                                style: context.textTheme.bodySmall?.copyWith(
                                  fontSize: ATSizes.size17
                                ),  
                              ),
                              Divider(color: ATColors.white.withValues(alpha: 0.1),),
                              ...List<Widget>.generate(
                                2,
                                (_) => const TileWithLeadingImage(
                                  padding: EdgeInsets.symmetric(vertical: 9),
                                  title: 'Gerald',
                                  subtitle: 'Host',
                                  diameter: 40,
                                  leadingImagePath: ATImgStrings.jpeg1,
                                )
                              ),
                              const SizedBox(height: 30),
                                                        
                              Text(
                                '0 Going',
                                style: context.textTheme.bodySmall?.copyWith(
                                  fontSize: ATSizes.size17
                                ),  
                              ),
                              Divider(color: ATColors.white.withValues(alpha: 0.1),),
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  const ATOverlappingCircles(maxNumber: 3,),
                                  const SizedBox(width: 10,),
                                  Flexible(
                                    child: Text(
                                      ATStrings.ATTENDEES_WILL_SHOW_HERE, maxLines: 2,
                                      style: context.textTheme.titleMedium?.copyWith(
                                        fontSize: ATSizes.size13
                                      ),
                                    ),
                                  ),
                                ],
                              ),                                    
                              const SizedBox(height: 20),
                              Text(
                                ATStrings.SHARE_EPISODE_LINK_DESC, maxLines: 2,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: ATColors.white.withValues(alpha: 0.6)
                                ),
                              ),
                              const SizedBox(height: 35),
                                                        
                              Text(
                                ATStrings.ABOUT_EPISODE,
                                style: context.textTheme.bodySmall?.copyWith(
                                  fontSize: ATSizes.size17
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
                                  fontSize: ATSizes.size14,
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
        
        resizeToAvoidBottomInset: false,
        bottomSheet: ATBlurredBgBtn(
          onPressed: () => context.pop(),
          btnTitle: ATStrings.EDIT_EPISODE,
        )
      ),
    );
  }
}