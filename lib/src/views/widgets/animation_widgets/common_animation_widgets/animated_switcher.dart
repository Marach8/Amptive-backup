import 'package:flutter/material.dart';

class AmptiveFadingAnimatedSwitcherWidget extends StatelessWidget {
  final Widget child;
  final int? duration;
  const AmptiveFadingAnimatedSwitcherWidget({
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



class AmptiveScalingAnimatedSwitcherWidget extends StatelessWidget {
  final Widget child;
  final int? duration;
  const AmptiveScalingAnimatedSwitcherWidget({
    super.key,
    required this.child,
    this.duration
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: duration ?? 1000),
      reverseDuration: Duration(seconds: duration ?? 1),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child
        );
      },
      child: child
    );
  }
}