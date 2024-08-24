import 'package:flutter/material.dart';

class AmptiveAnimatedCrossFadeWidget extends StatelessWidget {
  final Widget firstChild, secondChild;
  final bool condition;
  const AmptiveAnimatedCrossFadeWidget({
    super.key,
    required this.firstChild,
    required this.secondChild,
    required this.condition
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstCurve: Curves.easeIn,
      secondCurve: Curves.easeIn,
      sizeCurve: Curves.decelerate,
      duration: const Duration(seconds: 1),
      firstChild: firstChild,
      secondChild: secondChild,
      crossFadeState: condition ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
