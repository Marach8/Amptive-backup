
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/audio_creator_animation_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/svg_asset_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';


class AmptiveWelcomeScreen extends StatelessWidget {
  const AmptiveWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AmptiveSvgAssetLoaderWidget(svgPath: AmptiveImageStrings.svgLogo),
              Gap(80.h),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AmptiveAudioCreator(
                      assetName: AmptiveImageStrings.jpeg2,
                      delay: 3,
                    ),                    
                    AmptiveAudioCreator(
                      assetName: AmptiveImageStrings.jpeg1,
                      delay: 6,
                    ),                    
                    AmptiveAudioCreator(
                      assetName: AmptiveImageStrings.jpeg3,
                      delay: 9,
                    ),
                  ],
                ),
              ),

              Gap(80.h),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25).r,
                child: Text(
                  AmptiveOtherStrings.monetizeLiveAudioShowsAndEvents,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),

              Gap(30.h),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () => context.push(AmptiveRoutes.authScreen, extra: false),
                  child: const Text(AmptiveOtherStrings.signUp)
                ),
              ),

              Gap(15.h),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 50.h,
                child: OutlinedButton(
                  onPressed: () => context.push(AmptiveRoutes.authScreen, extra: false),
                  child: const Text(AmptiveOtherStrings.signIn)
                ),
              ),

              Gap(10.h),
              TextButton(
                onPressed: (){},
                child: const Text(AmptiveOtherStrings.attendAsGuest)
              )
            ]
          ),
        ),
      ),
    ));
  }
}
