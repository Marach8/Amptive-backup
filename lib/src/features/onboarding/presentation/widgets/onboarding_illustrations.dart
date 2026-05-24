import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';

class OnboardingOne extends StatelessWidget {
  const OnboardingOne({super.key});

  @override
  Widget build(BuildContext context) {
    return const ATImgLoader(
      imgPath: ATImgStrings.onboard1,
    );
  }
}


class OnboardingTwo extends StatelessWidget {
  const OnboardingTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: <Widget>[
        Transform.rotate(
          angle: -0.25,
          child: const ATImgLoader(
            imgPath: ATImgStrings.onboard2c,
            height: 385.52, width: 232.25
          ),
        ),
        Positioned(
          bottom: -10,
          child: Transform.rotate(
            angle: 0.4,
            child: const ATImgLoader(
              imgPath: ATImgStrings.onboard2b,
              height: 385.52, width: 232.25
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          child: Transform.rotate(
            angle: -0.4,
            child: const ATImgLoader(
              imgPath: ATImgStrings.onboard2a,
              height: 385.52, width: 232.25
            ),
          ),
        ),
      ]
    );
  }
}

class OnboardingThree extends StatelessWidget {
  const OnboardingThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          left: -100,
          bottom: 15,
          child: Transform.rotate(
            angle: -0.1,
            child: const ATImgLoader(
              imgPath: ATImgStrings.onboard3a,
              height: 385.52, width: 232.25
            ),
          ),
        ),
        const Positioned(
          bottom: 50,
          child: ATImgLoader(
            imgPath: ATImgStrings.onboard3b,
            height: 385.52, width: 232.25
          ),
        ),
        Positioned(
          right: -120,
          child: Transform.rotate(
            angle: 0.12,
            child: const ATImgLoader(
              imgPath: ATImgStrings.onboard3c,
              height: 385.52, width: 232.25
            ),
          ),
        ),
      ]
    );
  }
}
