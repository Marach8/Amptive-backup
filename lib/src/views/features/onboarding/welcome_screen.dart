import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/audio_creator_animation_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/outlined_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/common_widgets/image_loader_widget.dart';


class AmptiveWelcomeScreen extends StatelessWidget {
  const AmptiveWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ATImgLoader(imgPath: ATImgStrings.amptiveLogo),
              Gap(80.h),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AmptiveAudioCreatorWidget(
                      assetName: ATImgStrings.jpeg2,
                      delay: 3,
                    ),                    
                    AmptiveAudioCreatorWidget(
                      assetName: ATImgStrings.jpeg1,
                      delay: 6,
                    ),                    
                    AmptiveAudioCreatorWidget(
                      assetName: ATImgStrings.jpeg3,
                      delay: 9,
                    ),
                  ],
                ),
              ),

              Gap(80.h),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25).r,
                child: Text(
                  ATStrings.monetizeLiveAudioShowsAndEvents,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),

              Gap(30.h),

              AmptiveElevatedButtonWidget(
                onPressed: () => context.pushNamed(ATRoutes.authScreen, extra: true),
                buttonTitle: ATStrings.signUp,
              ),

              Gap(15.h),

              ATOutlinedBtn(
                onPressed: () => context.pushNamed(ATRoutes.authScreen, extra: false),
                buttonTitle: ATStrings.signIn,
              ),

              Gap(10.h),
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
