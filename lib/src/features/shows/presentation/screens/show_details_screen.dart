import 'dart:ui';
import 'package:amptive/src/features/calender/calender_export.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/presentation/widgets/event_or_show_card.dart';
import 'package:amptive/src/features/home/presentation/widgets/live_and_society_widget.dart';
import 'package:amptive/src/features/home/presentation/widgets/people_listening.dart';
import 'package:amptive/src/features/home/presentation/widgets/program_actions_modal.dart';
import 'package:amptive/src/features/home/presentation/widgets/show_or_event_indicator_with_title.dart';
import 'package:amptive/src/features/home/presentation/widgets/whispers_list.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import 'package:readmore/readmore.dart';
import '../../../../shared/list_tile_with_leading_picture_widget.dart';
import '../../../../shared/sliver_header_delegate.dart';

class PreviewShowScreen extends StatelessWidget {
  const PreviewShowScreen({super.key, required this.hostedShow});

  final HostedShow hostedShow;

  @override
  Widget build(_) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<ShowDetailCubit>(
          create: (_) => ShowDetailCubit(initialShow: hostedShow)
            ..fetchShowDetails()
        ),
        BlocProvider<BlurredHeaderBloc>(create: (_) => BlurredHeaderBloc()),
        BlocProvider<ToggleFollowingCubit>(
          create: (_) => ToggleFollowingCubit(
            initialStatus: FollowingStatus(
              isFollowing: true,
              followerCount: hostedShow.followerCount ?? 0,
            )
          )
        )
      ],
      child: Builder(
        builder: (BuildContext context) {
          final double blurredHeaderHeight = kToolbarHeight +
            MediaQuery.paddingOf(context).top;
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => context.read<ShowDetailCubit>().fetchShowDetails(),
          );
          return ATAnnotatedRegion(
            statusBarColor: ATColors.transparent,
            child: Scaffold(
              body: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 250, sigmaY: 250),
                      child: ATImgLoader(
                        boxFit: BoxFit.fill,
                        imgPath: hostedShow.coverUrl ?? ''
                      ),
                    ),
                  ),
              
                  ATContainer(
                    color: ATColors.hex0D0D0D.withValues(alpha: 0.75),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: context.read<BlurredHeaderBloc>().onScrollNotification,
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
                                      child: ATRoundedBackBtn(bgColor: ATColors.transparent,),
                                    ),
                                    Text(
                                      hostedShow.host?.displayName ?? '',
                                      style: context.textTheme.bodyMedium,
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
                                    CoverPicWithTopRightMoreIcon(
                                      imgPath: hostedShow.coverUrl ?? '',
                                      onMoreTapped: ()async{
                                        final SelectedProgramAction? foo = await showProgramOptions(
                                          context: context,
                                          toggleFollowingCubit: context.read<ToggleFollowingCubit>(),
                                          targetUserName: hostedShow.host?.displayName ?? '',
                                          targetUserId: hostedShow.host?.userId ?? '',
                                        );
                                      }
                                    ),
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
                                      hostedShow.title ?? '',
                                      overflow: TextOverflow.clip,
                                      style: context.textTheme.displayMedium?.copyWith(
                                        fontSize: ATSizes.size24,
                                        fontWeight: ATFontWeights.w600,
                                      ),
                                    ),
                              
                                    const SizedBox(height: 12,),
                                    const LiveIndicatorRow(),                                
                                    const SizedBox(height: 40,),
                              
                                    Text(
                                      ATStrings.HASHTAGS,
                                      style: context.textTheme.bodySmall?.copyWith(
                                        fontSize: ATSizes.size17
                                      ),  
                                    ),
                                    Divider(color: ATColors.white.withValues(alpha:0.1),),
                                    const SizedBox(height: 5),
                                    const ATHashtagsWidget(),
                                    const SizedBox(height: 30,),
                              
                                    Text(
                                      ATStrings.HOSTED_BY,
                                      style: context.textTheme.bodySmall?.copyWith(
                                        fontSize: ATSizes.size17
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
                                        fontSize: ATSizes.size17
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
                                    const SizedBox(height: 30,),
                              
                                    Text(
                                      ATStrings.WHISPERS,
                                      style: context.textTheme.bodySmall?.copyWith(
                                        fontSize: ATSizes.size17
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
                    ),
                  ),
                ],
              ),
          
              bottomSheet: ATBlurredBgBtn(
                onPressed: (){
                  context.pushNamed(ATRoutes.CREATE_EPISODE_FORM);
                },
                btnTitle: 'Add Episode',
              ),
            ),
          );
        }
      ),
    );
  }
}
