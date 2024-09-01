import 'package:flutter/material.dart';

class AmptiveAnimatedSwitcherWidget extends StatelessWidget {
  final Widget child;
  final int? duration;
  const AmptiveAnimatedSwitcherWidget({
    super.key,
    required this.child,
    this.duration
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(seconds: duration ?? 1),
      reverseDuration: Duration(seconds: duration ?? 1),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child
        );
      },
      child: child
    );
  }
}