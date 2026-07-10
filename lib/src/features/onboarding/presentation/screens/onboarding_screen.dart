import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/features/onboarding/presentation/widgets/onboarding_illustrations.dart';
import 'package:amptive/src/features/onboarding/presentation/widgets/onboarding_messages.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../config/routing/route_strings.dart';
import '../../../../config/utils/extensions/context_extensions.dart';

class ATOnboardingScreen extends StatefulWidget {
  const ATOnboardingScreen({super.key});

  @override
  State<ATOnboardingScreen> createState() => _ATOnboardingScreenState();
}

class _ATOnboardingScreenState extends State<ATOnboardingScreen> {
  final PageController _pageCntrl = PageController();

  @override
  void dispose() {
    _pageCntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        backgroundColor: ATColors.black,
        body: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: _pageCntrl,
                physics: const ClampingScrollPhysics(),
                children: const <Widget>[
                  ClipRect(child: OnboardingOne()),
                  ClipRect(child: OnboardingTwo()),
                  ClipRect(child: OnboardingThree()),
                ],
              ),
            ),

            DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: ATColors.black,
                    offset: const Offset(0, 5),
                    blurRadius: 8,
                    spreadRadius: 10
                  )
                ]
              ),
              child: Column(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 260,
                    child: OnboardingMessages(pageController: _pageCntrl),
                  ),
                  SmoothPageIndicator(
                    controller: _pageCntrl,
                    count: 3,
                    onDotClicked: (int index) => _pageCntrl.animateToPage(index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.decelerate),
                    effect: ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 7,
                      expansionFactor: 2.4,
                      activeDotColor: ATColors.hexD9D9D9,
                      dotColor: ATColors.hex5B5B5B,
                    ),
                  ),
              
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ATPlainElevatedBtn(
                      onPressed: () {
                        if(_pageCntrl.page == 2) {
                          context.goNamed(ATRoutes.postOnboardingScreen);
                        }
                        else{
                          _pageCntrl.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      btnTitle: 'Next',
                      fgColor: ATColors.black,
                      bgColor: ATColors.white,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextButton(
                      onPressed: () {
                        context.goNamed(ATRoutes.postOnboardingScreen);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: ATColors.white,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: const Size(double.infinity, 0), // Absolute minimum height wrapper
                        alignment: Alignment.topCenter,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 15, 
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40), 

          ],
        ),
      ),
    );
  }
}
