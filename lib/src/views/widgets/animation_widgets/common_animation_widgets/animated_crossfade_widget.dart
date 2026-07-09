import 'package:flutter/material.dart';

class ATAnimatedXFade extends StatelessWidget {
  const ATAnimatedXFade(
      {super.key,
      required this.firstChild,
      required this.secondChild,
      required this.condition,
      this.duration,
      this.fadeCurve,
      this.sizeCurve});
  final Widget firstChild, secondChild;
  final bool condition;
  final int? duration;
  final Curve? fadeCurve, sizeCurve;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstCurve: fadeCurve ?? Curves.easeIn,
      secondCurve: fadeCurve ?? Curves.easeIn,
      sizeCurve: sizeCurve ?? Curves.decelerate,
      duration: Duration(milliseconds: duration ?? 500),
      firstChild: firstChild,
      secondChild: secondChild,
      crossFadeState:
          condition ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
