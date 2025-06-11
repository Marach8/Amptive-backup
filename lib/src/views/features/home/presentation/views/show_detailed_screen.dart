import 'dart:io';
import 'dart:ui';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/extensions/context_extensions.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/features/home/home_export.dart';
import 'package:amptive/src/views/features/home/presentation/widgets/show_or_event_indicator_with_title.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/features/home/presentation/widgets/event_or_show_card.dart';
import 'package:amptive/src/views/widgets/common_widgets/overlapping_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import '../../../../../utils/constants/font_sizes.dart';
import '../../../../../utils/constants/font_weights.dart';
import '../../../../widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import '../../../../widgets/common_widgets/row_of_people_listening_widget.dart';
import '../../../../widgets/common_widgets/sliver_header_delegate.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_show_or_event_full_details_view/hashtags_widget.dart';
import '../widgets/live_and_society_widget.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_show_or_event_full_details_view/whispers_list_view_widget.dart';
import 'dart:developer';

class ATProgramDetailedScreen extends StatelessWidget {
  const ATProgramDetailedScreen({super.key});

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
                    imgPath: ATImgStrings.weCanDoHardThingsBgImage,
                  ),
                ),
              ),
              ATContainer(
                color: ATColors.brandBlack.withValues(alpha: 0.75),
                child: BlocProvider<_PrivateBloc>(
                  create: (_) => _PrivateBloc(),
                  child: Builder(
                    builder: (BuildContext blocContext) {
                      return NotificationListener<ScrollNotification>(
                        onNotification: blocContext.read<_PrivateBloc>().onNotification,
                        child: NestedScrollView(
                          headerSliverBuilder: (_, __) => <Widget>[
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: ATSliverHDelegate(
                                maxExt: kToolbarHeight, minExt: kToolbarHeight,
                                child:const NewWidget()
                              ),
                            )
                          ],

                          body: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const ATEventOrShowCard(),
                                      const SizedBox(height: 24),
                                      const ShowOrEventIndicatorWithTitle(),
                                      const SizedBox(height: 12,),
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
                                      const LiveAndSocietyWidget(),
                                
                                      const SizedBox(height: 40,),
                                
                                      Text(
                                        ATStrings.HASHTAGS,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          fontSize: ATFontSizes.size17
                                        ),  
                                      ),
                                      Divider(color: ATColors.white.withValues(alpha:0.1),),
                                      const SizedBox(height: 5),
                                      const AmptiveHashtagsWidget(),
                                
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
                                      const SizedBox(height: 30,),
                                
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
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: ATPlainElevatedBtn(
            bgColor: ATColors.white,
            fgColor: ATColors.brandBlack,
            btnTitle: 'Subscrible N1,900/month',
            onPressed: (){}
          ),
        ),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BlocBuilder<_PrivateBloc, bool>(
        builder: (_, state) {
          return BackdropFilter(
            filter: state ? ImageFilter.blur(sigmaX: 53, sigmaY: 53)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: ATContainer(//color: Colors.red,
              height: kToolbarHeight,
              width: context.screenWidth,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  ATHelperFuncs.hideAnyMountedSnackbar(context);
                  context.pop();
                },
                child: Platform.isAndroid
                  ? Icon(
                    Icons.keyboard_arrow_down, size: 30,
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
          );
        }
      ),
    );
  }
}

class _PrivateBloc extends Cubit<bool>{
  _PrivateBloc():super(false);


  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final extentBefore = notification.metrics.extentBefore;
      if(extentBefore > 0.0 && !state){
        log('backdrop is shown');
        log(notification.metrics.extentInside.toString());
        emit(true);
      }
      else if(extentBefore == 0.0 && state){
        log('Backdrop is hidden');
        emit(false);
      }
    }

    return true; // Allow notifications to bubble
  }
}