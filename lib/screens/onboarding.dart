import 'package:amptive/routers/amptive_routes.dart';
import 'package:amptive/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController(viewportFraction: 1.0, keepPage: true);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(_pageListener);
  }

  @override
  void dispose() {
    controller.removeListener(_pageListener);
    controller.dispose();
    super.dispose();
  }

  void _pageListener() {
    setState(() {
      _currentPage = controller.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const OnboardingPage(
        title: "Onboarding Title One",
        description: "Onboarding brief description",
        pictureColor: AmpColors.gray1,
      ),
      const OnboardingPage(
        title: "Onboarding Title Two",
        description: "Onboarding brief description",
        pictureColor: AmpColors.gray2,
      ),
      const OnboardingPage(
        title: "Onboarding Title Three",
        description: "Onboarding brief description",
        pictureColor: AmpColors.gray3,
      )
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: AmpColors.brandBlack,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SizedBox(
                    child: PageView.builder(
                      allowImplicitScrolling: false,
                      itemCount: pages.length,
                      controller: controller,
                      // itemCount: pages.length,
                      itemBuilder: (_, index) {
                        return pages[index];
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 33.0.h),
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: pages.length,
                    effect: WormEffect(
                      dotHeight: 10.h,
                      dotWidth: 10.w,
                      activeDotColor: AmpColors.dotActive,
                      dotColor: AmpColors.dotInActive,
                      type: WormType.thinUnderground,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
                bottom: 22.h,
                right: 38.w,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushReplacementNamed(AmptiveRoutes.welcome);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AmpColors.brandBlue,
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    _currentPage > 1 ? "Next" : "Skip",
                    style: GoogleFonts.inter(
                      color: AmpColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final Color pictureColor;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.pictureColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PicturePage(
          color: pictureColor,
        ),
        SizedBox(
          height: 30.0.h,
        ),
        Container(
          margin: EdgeInsets.only(left: 24.0.w),
          child: DescriptionPage(
            title: title,
            description: description,
          ),
        ),
      ],
    );
  }
}

class DescriptionPage extends StatelessWidget {
  final String title;
  final String description;

  const DescriptionPage({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AmpColors.white,
            height: 37.sp / 24.sp,
          ),
          textAlign: TextAlign.left,
        ),
        Text(
          description,
          style: GoogleFonts.inter(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xffcdcdcd),
            height: 37.sp / 17.sp,
          ),
          textAlign: TextAlign.left,
        )
      ],
    );
  }
}

class PicturePage extends StatelessWidget {
  final Color color;

  const PicturePage({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 455.0.h,
      padding: EdgeInsets.symmetric(
        vertical: 200.0.h,
        horizontal: 152.0.w,
      ),
      color: color,
      child: SvgPicture.asset(
        "assets/empty_image.svg",
        semanticsLabel: 'Amptive Logo',
      ),
    );
  }
}
