import 'package:flutter/material.dart';

class ATFadingSwitcher extends StatelessWidget {
  const ATFadingSwitcher({
    super.key,
    required this.child,
    this.duration
  });

  final Widget child;
  final int? duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: duration ?? 1000),
      reverseDuration: Duration(milliseconds: duration ?? 1000),
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



class ATScalingSwitcher extends StatelessWidget {
  final Widget child;
  final int? duration;
  const ATScalingSwitcher({
    super.key,
    required this.child,
    this.duration
  });

  @override
  Widget build(context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: duration ?? 1000),
      reverseDuration: Duration(milliseconds: duration ?? 1000),
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