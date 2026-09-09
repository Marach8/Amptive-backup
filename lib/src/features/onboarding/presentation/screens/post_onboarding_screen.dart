import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/auth/presentation/screens/auth_options_screen.dart'
    show AuthType;
import 'package:amptive/src/features/onboarding/presentation/widgets/audio_creator_animation_widget.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/image_loader_widget.dart';

class ATPostOnboardingScreen extends StatelessWidget {
  const ATPostOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
        child: Scaffold(
      body: Center(
        child: SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const ATImgLoader(imgPath: ATImgStrings.amptiveLogo),
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TestWidget(
                    imgPath: ATImgStrings.jpeg2,
                  ),
                  TestWidget(
                    imgPath: ATImgStrings.jpeg1,
                  ),
                  TestWidget(
                    imgPath: ATImgStrings.jpeg3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                ATStrings.monetizeLiveAudioShowsAndEvents,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: context.textTheme.displayMedium,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ATPlainElevatedBtn(
                onPressed: () => context.pushNamed(ATRoutes.authOptionsScreen,
                    extra: AuthType.signUp),
                btnTitle: ATStrings.signUp,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ATOutlinedBtn(
                onPressed: () => context.pushNamed(ATRoutes.authOptionsScreen,
                    extra: AuthType.signIn),
                btnTitle: ATStrings.signIn,
              ),
            ),
            const SizedBox(height: 10,),
            TextButton(
                onPressed: () {}, 
                child: const Text(ATStrings.attendAsGuest))
          ]),
        )
      ),
    ));
  }
}

