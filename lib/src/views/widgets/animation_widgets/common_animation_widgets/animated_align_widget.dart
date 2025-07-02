import 'package:flutter/material.dart';

class ATAnimatedAlign extends StatelessWidget {
  const ATAnimatedAlign({
    super.key,
    required this.startAlignment,
    required this.child,
    required this.endAlignment,
    required this.condition,
    this.curve,
    this.duration
  });
  final Widget child;
  final AlignmentGeometry startAlignment,
  endAlignment;
  final bool condition;
  final int? duration;
  final Curve? curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      curve: curve ?? Curves.decelerate,
      alignment: condition ? startAlignment : endAlignment,
      duration: Duration(milliseconds: duration ?? 1000),
      child: child,
    );
  }
}