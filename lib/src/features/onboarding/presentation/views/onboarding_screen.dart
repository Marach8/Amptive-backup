import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/onboarding/presentation/widgets/dot_indicator_row.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/features/onboarding/presentation/widgets/custom_onboarding_page_widget.dart';
import 'package:flutter/material.dart';


class ATOnboardingScreen extends StatefulWidget {
  const ATOnboardingScreen({super.key});

  @override
  State<ATOnboardingScreen> createState() => _ATOnboardingScreenState();
}

class _ATOnboardingScreenState extends State<ATOnboardingScreen> {
  final PageController _pageCntrl = PageController();
  final ScrollController _scrollCntrl1 = ScrollController();
  final ScrollController _scrollCntrl2 = ScrollController();
  final ScrollController _scrollCntrl3 = ScrollController();


  @override
  void dispose() {
    _pageCntrl.dispose();
    _scrollCntrl1.dispose();
    _scrollCntrl2.dispose();
    _scrollCntrl3.dispose();
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
                    scrollCntrl: _scrollCntrl1,
                    title: ATStrings.GO_LIVE_LIKE_NEVER_B4,
                    description:  ATStrings.READILY_MONETIZE_UR_LIVE_AUDIO_PROGS,
                    pictureBgColor: ATColors.hex2D2D2D,
                  ),
                  CustomOnboardPageWidget(
                    scrollCntrl: _scrollCntrl2,
                    title: ATStrings.experienceItUniquely,
                    description: ATStrings.joinTheLargerAudience,
                    pictureBgColor: ATColors.grey2Color,
                  ),
                  CustomOnboardPageWidget(
                    scrollCntrl: _scrollCntrl3,
                    title: ATStrings.liveAudioAndEventShows,
                    description: ATStrings.tuneIntoLiveAudioShowsAndEvents,
                    pictureBgColor: ATColors.grey4Color,
                  ),
                ],
              ),
            ),
            DotIndicatorRow(pageCntrl: _pageCntrl),
          ],
        ),
      ),
    );
  }
}


