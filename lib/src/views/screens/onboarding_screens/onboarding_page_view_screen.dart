import 'package:amptive/src/bloc/onboarding_bloc/onboarding_bloc.dart';
import 'package:amptive/src/bloc/onboarding_bloc/onboarding_events.dart';
import 'package:amptive/src/bloc/onboarding_bloc/onboarding_states.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/onboarding_widgets/onboarding_page_view_slide_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AmptiveOnboardingScreen extends StatefulWidget {
  const AmptiveOnboardingScreen({super.key});

  @override
  State<AmptiveOnboardingScreen> createState() =>
      _AmptiveOnboardingScreenState();
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
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) => context
                  .read<AmptiveOnboardingBloc>()
                  .add(SwipeToAnotherPageOnboardingEvent(
                      indexOfDestinationPage: index)),
              children: [
                AmptiveCustomOnboardingPageViewSlideWidget(
                  title: ATStrings.goLiveLikeNeverBefore,
                  description:
                      ATStrings.monetizeYouLiveShowsAndEvents,
                  pictureBgColor: ATColors.hex2D2D2D,
                ),
                AmptiveCustomOnboardingPageViewSlideWidget(
                  title: ATStrings.experienceItUniquely,
                  description: ATStrings.joinTheLargerAudience,
                  pictureBgColor: ATColors.grey2Color,
                ),
                AmptiveCustomOnboardingPageViewSlideWidget(
                  title: ATStrings.liveAudioAndEventShows,
                  description:
                      ATStrings.tuneIntoLiveAudioShowsAndEvents,
                  pictureBgColor: ATColors.grey4Color,
                ),
              ],
            ),
            Positioned(
              bottom: 22.h,
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
                      activeDotColor: ATColors.hexD9D9D9,
                      dotColor: ATColors.inactiveDotColor,
                    ),
                  ),
                  Gap(80.r),
                  Container(
                    margin: EdgeInsets.only(right: 10.w),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 12.w),
                        ),
                        onPressed: () =>
                            context.pushReplacementNamed(ATRoutes.welcome),
                        child: BlocBuilder<AmptiveOnboardingBloc,
                            AmptiveOnboardingState>(builder: (_, state) {
                          final currentState =
                              state as CurrentOnboardingPageViewIndexState;
                          final currentPageIndex =
                              currentState.currentPageIndex;
                          return Text(currentPageIndex > 1
                              ? ATStrings.NEXT
                              : ATStrings.skip);
                        })),
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
