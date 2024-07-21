import 'package:amptive/src/bloc/onboarding_bloc/onboarding_bloc.dart';
import 'package:amptive/src/bloc/onboarding_bloc/onboarding_events.dart';
import 'package:amptive/src/bloc/onboarding_bloc/onboarding_states.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/onboarding_page_view_slide_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AmptiveOnboardingScreen extends StatefulWidget {
  const AmptiveOnboardingScreen({super.key});

  @override
  State<AmptiveOnboardingScreen> createState() => _AmptiveOnboardingScreenState();
}

class _AmptiveOnboardingScreenState extends State<AmptiveOnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        body: Stack(
          children: [

            PageView(
              controller: _controller,
              onPageChanged: (index) => context.read<AmptiveOnboardingBloc>().add(SwipeToAnotherPageOnboardingEvent(indexOfDestinationPage: index)),
              children: [
                AmptiveCustomOnboardingPageViewSlideWidget(
                  title: AmptiveOtherStrings.goLiveLikeNeverBefore, 
                  description: AmptiveOtherStrings.monetizeYouLiveShowsAndEvents,
                  pictureBgColor: AmptiveColors.grey1Color,
                ),
                AmptiveCustomOnboardingPageViewSlideWidget(
                  title: AmptiveOtherStrings.experienceItUniquely, 
                  description: AmptiveOtherStrings.joinTheLargerAudience,
                  pictureBgColor: AmptiveColors.grey2Color,
                ),
                AmptiveCustomOnboardingPageViewSlideWidget(
                  title: AmptiveOtherStrings.liveAudioAndEventShows,
                  description: AmptiveOtherStrings.tuneIntoLiveAudioShowsAndEvents,
                  pictureBgColor: AmptiveColors.grey3Color,
                ),
              ],
            ),

            Positioned(
              bottom: 0,
              right: 20,
              child: Row(
               mainAxisSize: MainAxisSize.min,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotHeight: 10.h,
                      dotWidth: 10.w,
                      activeDotColor: AmptiveColors.activeDotColor,
                      dotColor: AmptiveColors.inactiveDotColor,
                    ),
                  ),
                  Gap(80.r),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => context.pushReplacementNamed(AmptiveRoutes.welcome),
                    child: BlocBuilder<AmptiveOnboardingBloc, AmptiveOnboardingState>(
                      builder: (_, state) {
                        final currentState = state as CurrentOnboardingPageViewIndexState;
                        final currentPageIndex = currentState.currentPageIndex;
                        return Text(currentPageIndex > 1 ? AmptiveOtherStrings.next : AmptiveOtherStrings.skip);
                      }
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}