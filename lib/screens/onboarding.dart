import 'package:amptive/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController(viewportFraction: 1.0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final pages = [
      const OnboardingPage(title: "Onboarding Title One",
        description: "Onboarding brief description",
        pictureColor: AmpColors.gray1,
      ),
      const OnboardingPage(title: "Onboarding Title Two",
        description: "Onboarding brief description",
        pictureColor: AmpColors.gray2,
      ),
      const OnboardingPage(title: "Onboarding Title Three",
        description: "Onboarding brief description",
        pictureColor: AmpColors.gray3,
      )
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: AmpColors.brandBlack,
        body: Column(
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
              margin: const EdgeInsets.only(bottom: 33.0),
              child: SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect: const WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: AmpColors.dotActive,
                  dotColor: AmpColors.dotInActive,
                  type: WormType.thinUnderground,
                ),
              ),
            ),
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
    super.key, required this.title, required this.description, required this.pictureColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PicturePage(color: pictureColor,),
        const SizedBox(
          height: 30.0,
        ),
        Container(
          margin: const EdgeInsets.only(left: 24.0),
            child: DescriptionPage(title: title, description: description,)),
      ],
    );
  }
}

class DescriptionPage extends StatelessWidget {
  final String title;
  final String description;

  const DescriptionPage({
    super.key, required this.title, required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: "Bricolage Grotesque",
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AmpColors.white,
            height: 37 / 24,
          ),
          textAlign: TextAlign.left,
        ),
        Text(
          description,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Color(0xffcdcdcd),
            height: 37 / 17,
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
    super.key, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 455.0,
      padding: const EdgeInsets.symmetric(
        vertical: 200.0,
        horizontal: 152.0,
      ),
      color: color,
      child: SvgPicture.asset(
        "assets/empty_image.svg",
        semanticsLabel: 'Amptive Logo',
      ),
    );
  }
}
