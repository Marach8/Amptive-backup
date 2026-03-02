import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/onboarding/presentation/widgets/dot_indicator_row.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/features/onboarding/presentation/widgets/custom_onboarding_page_widget.dart';
import 'package:flutter/material.dart';

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
        body: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: _pageCntrl,
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  CustomOnboardPageWidget(
                    title: ATStrings.GO_LIVE_LIKE_NEVER_B4,
                    description:  ATStrings.READILY_MONETIZE_UR_LIVE_AUDIO_PROGS,
                    pictureBgColor: ATColors.hex2D2D2D,
                  ),
                  CustomOnboardPageWidget(
                    title: ATStrings.experienceItUniquely,
                    description: ATStrings.joinTheLargerAudience,
                    pictureBgColor: ATColors.grey2Color,
                  ),
                  CustomOnboardPageWidget(
                    title: ATStrings.liveAudioAndEventShows,
                    description: ATStrings.tuneIntoLiveAudioShowsAndEvents,
                    pictureBgColor: ATColors.grey4Color,
                  ),
                ],
              ),
            ),
            DotIndicatorRow(pageCntrl: _pageCntrl),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
