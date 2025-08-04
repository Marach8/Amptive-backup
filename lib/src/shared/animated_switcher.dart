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
      transitionBuilder: (Widget child, Animation<double> animation) {
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
  const ATScalingSwitcher({
    super.key,
    required this.child,
    this.duration,
    this.curve,
  });
  
  final Widget child;
  final int? duration;
  final Curve? curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: duration ?? 500),
      reverseDuration: Duration(milliseconds: duration ?? 500),
      switchInCurve: curve ?? Curves.easeIn,
      switchOutCurve: curve ?? Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: child
        );
      },
      child: child
    );
  }
}