import 'package:flutter/material.dart';

class ATAnimatedCrossFade extends StatelessWidget {
  const ATAnimatedCrossFade({
    super.key,
    required this.firstChild,
    required this.secondChild,
    required this.condition,
    this.duration
  });
  final Widget firstChild, secondChild;
  final bool condition;
  final int? duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstCurve: Curves.easeIn,
      secondCurve: Curves.easeIn,
      sizeCurve: Curves.decelerate,
      duration: Duration(milliseconds: duration ?? 500),
      firstChild: firstChild,
      secondChild: secondChild,
      crossFadeState: condition ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
