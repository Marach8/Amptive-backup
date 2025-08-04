import 'package:amptive/src/global_export.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class InstructionsSwitcher extends StatelessWidget {
  const InstructionsSwitcher({
    super.key,
    required this.carouselCntrl,
  });

  final  CarouselSliderController carouselCntrl;

  static final List<String> texts = <String>[
    ATStrings.TAP_D_RECORD_BTN, ATStrings.SPEAK_IN_2_MIC,
    ATStrings.SOUND_CHECK, ATStrings.GOING_LIVE_ON_AIR
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      height: 106,
      child: CarouselSlider(
        items: texts.map(
          (String text){
            return SizedBox(
              width: 300, height: 110,
              child: Text(
                text.toUpperCase(),
                key: ValueKey<String>(text),
                textAlign: TextAlign.center, 
                maxLines: 3,
                style: context.textTheme.displayMedium?.copyWith(
                  color: ATColors.hexC2C2C2,
                  fontSize: 38, height: 0.85,
                  fontWeight: ATFontWeights.w800
                )
              ),
            );
          }
        ).toList(),
        carouselController: carouselCntrl,
        options: CarouselOptions(
          scrollPhysics: const NeverScrollableScrollPhysics(),
          viewportFraction: 1
        )
      ),
    );
  }
}