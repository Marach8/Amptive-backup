import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/auth/auth_options_screen.dart';
import 'package:amptive/src/features/onboarding/presentation/widgets/audio_creator_animation_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/outlined_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../views/widgets/common_widgets/image_loader_widget.dart';


class ATPostOnboardingScreen extends StatelessWidget {
  const ATPostOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const ATImgLoader(imgPath: ATImgStrings.AMPTIVE_LOGO),
              const SizedBox(height: 80,),

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
              
              const SizedBox(height: 80,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  ATStrings.monetizeLiveAudioShowsAndEvents,
                  textAlign: TextAlign.center, maxLines: 2,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),

              const SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ATPlainElevatedBtn(
                  onPressed: () => context.pushNamed(ATRoutes.AUTH_OPTIONS_SCREEN, extra: AuthType.signUp),
                  btnTitle: ATStrings.SIGN_UP,
                ),
              ),

              const SizedBox(height: 15,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ATOutlinedBtn(
                  onPressed: () => context.pushNamed(ATRoutes.AUTH_OPTIONS_SCREEN, extra: AuthType.signIn),
                  btnTitle: ATStrings.SIGN_IN,
                ),
              ),

              const SizedBox(height: 10,),
              TextButton(
                onPressed: (){},
                child: const Text(ATStrings.attendAsGuest)
              )
            ]
          ),
        ),
      ),
    ));
  }
}
