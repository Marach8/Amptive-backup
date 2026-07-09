import 'package:amptive/src/features/auth/presentation/screens/auth_options_screen.dart'
    show AuthType;
import 'package:amptive/src/features/onboarding/presentation/widgets/audio_creator_animation_widget.dart';
import 'package:amptive/src/features/onboarding/presentation/widgets/audio_envelope.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/image_loader_widget.dart';

import 'package:flutter_svg/flutter_svg.dart';

const String _amptiveLogoSvg = r'''<svg width="105" height="84" viewBox="0 0 105 84" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M96.9489 58.3115C96.7382 63.182 96.0281 67.7666 92.1577 68.4573C91.8456 68.5049 91.5725 68.5347 91.276 68.5347C86.7111 68.5347 82.7783 62.3186 78.6114 55.7691C75.8569 51.4524 72.5951 46.3081 69.7158 44.5397C69.0603 44.1348 68.1083 44.1825 67.5465 44.6647C65.1665 46.7249 63.4186 52.4884 61.9828 57.3172C59.7199 64.8551 57.5662 72 52.5175 72C47.4688 72 45.3152 64.861 43.0522 57.3053C41.6164 52.4706 39.8763 46.6832 37.4964 44.6409C36.9423 44.1646 36.0059 44.111 35.3427 44.504C32.4477 46.2247 29.1625 51.4107 26.3846 55.7751C22.2177 62.3246 18.2849 68.5407 13.72 68.5407C13.4235 68.5407 13.1582 68.5109 12.8383 68.4633C8.97567 67.7666 8.26558 63.182 8.05489 58.3115C7.46965 44.6528 11.5741 31.1668 19.8845 19.3003C22.6469 15.3349 26.0179 11.3933 29.8492 12.078C34.773 12.9413 34.7496 20.2589 34.7262 28.0052C34.7262 32.1611 34.7106 37.0078 35.725 39.8777C36.0996 40.9315 37.9646 41.0804 38.6278 40.1099C40.4226 37.4662 41.8193 32.828 43.0132 28.8388C45.2761 21.283 47.4298 14.1441 52.4785 14.1441C57.5272 14.1441 59.6808 21.283 61.9438 28.8566C63.1455 32.8697 64.55 37.5496 66.3604 40.1813C67.0237 41.1459 68.8808 40.997 69.2554 39.9491C70.2854 37.0852 70.2776 32.1969 70.2776 28.0052C70.2542 20.2589 70.2386 12.9413 75.1546 12.078C79.0094 11.3933 82.3569 15.3349 85.1193 19.3003C93.4297 31.1668 97.5107 44.6528 96.9489 58.3115Z" fill="white"/>
</svg>''';

class ATPostOnboardingScreen extends StatelessWidget {
  const ATPostOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              // Fixed logo at the top
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SvgPicture.string(_amptiveLogoSvg, width: 50),
                ),
              ),
              // Centered content
              const Center(
                child: ATScrollBar(
                  child: _SubWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget();

  @override
  State<_SubWidget> createState() => _SubWidgetState();
}

class _SubWidgetState extends State<_SubWidget> {
  int _activeSpeakerIndex = 1;

  late List<Alignment> _alignments;

  @override
  void initState() {
    super.initState();
    _alignments = <Alignment>[
      const Alignment(-1.0, 0.2), // 0: Left slot (inactive)
      const Alignment(0.0, -0.2), // 1: Center slot (active)
      const Alignment(1.0, 0.2),  // 2: Right slot (inactive)
    ];
  }

  void _setActiveSpeaker(int index) {
    if (_activeSpeakerIndex == index) return;
    setState(() {
      final int currentCenterIndex = _activeSpeakerIndex;
      _activeSpeakerIndex = index;

      final Alignment oldSlot = _alignments[index];
      _alignments[index] = _alignments[currentCenterIndex];
      _alignments[currentCenterIndex] = oldSlot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Avatar Cluster
            SizedBox(
              height: 110, // Increased to allow the center avatar to bounce without clipping
              width: 260, 
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  // Left avatar (Muted Co-Host) - Index 0
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                    alignment: _alignments[0],
                    child: const TestWidget(imgPath: ATImgStrings.jpeg2, isAnimated: false),
                  ),
                  // Center avatar (Nate) - Index 1
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                    alignment: _alignments[1],
                    child: TestWidget(
                      imgPath: ATImgStrings.middleTopRightAvatar, 
                      isAnimated: true,
                      audioAsset: 'sounds/ElevenLabs_2026-06-09T21_16_36_Nate - Natural, Warm, Podcast Voice_pvc_sp100_s50_sb75_se100_b_m2.mp3',
                      envelope: nateVoiceEnvelope,
                      onSpeechStart: () => _setActiveSpeaker(1),
                    ),
                  ),
                  // Right avatar (Brielle) - Index 2
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                    alignment: _alignments[2],
                    child: TestWidget(
                      imgPath: ATImgStrings.jpeg3, 
                      isAnimated: true,
                      audioAsset: 'sounds/ElevenLabs_2026-06-09T22_58_34_Brielle - Podcast girl extremely natural_pvc_sp108_s11_sb75_se45_b_m2.mp3',
                      envelope: brielleVoiceEnvelope,
                      delay: const Duration(milliseconds: 31200),
                      onSpeechStart: () => _setActiveSpeaker(2),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 45, // Tightened gap from 80px to anchor the visual to the headline
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                ATStrings.monetizeLiveAudioShowsAndEvents,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ATPlainElevatedBtn(
                onPressed: () => context.pushNamed(ATRoutes.authOptionsScreen,
                    extra: AuthType.signUp),
                btnTitle: ATStrings.SIGN_UP,
                bgColor: ATColors.white,
                fgColor: ATColors.black,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ATColors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ATPlainElevatedBtn(
                onPressed: () => context.pushNamed(ATRoutes.authOptionsScreen,
                    extra: AuthType.signIn),
                btnTitle: ATStrings.SIGN_IN,
                bgColor: const Color(0xFFFF0078),
                fgColor: ATColors.white,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ATColors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(minimumSize: const Size(64, 44)),
                child: const Text(ATStrings.attendAsGuest))
          ]),
    );
  }
}
