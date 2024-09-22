import 'package:flutter/material.dart';

class AmptiveAnimatedAlignWidget extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry startAlignment,
  endAlignment;
  final bool condition;
  final int? duration;
  const AmptiveAnimatedAlignWidget({
    super.key,
    required this.startAlignment,
    required this.child,
    required this.endAlignment,
    required this.condition,
    this.duration
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      curve: Curves.fastEaseInToSlowEaseOut,
      alignment: condition ? startAlignment : endAlignment,
      duration: Duration(milliseconds: duration ?? 1000),
      child: child,
    );
  }
}