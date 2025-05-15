import 'package:flutter/material.dart';

class ATAnimatedSlide extends StatelessWidget {
  const ATAnimatedSlide({
    super.key,
    required this.startOffset,
    required this.child,
    required this.endOffset,
    required this.condition,
    this.curve,
    this.duration
  });

  final Widget child;
  final Offset startOffset, endOffset;
  final bool condition;
  final int? duration;
  final Curve? curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      curve: curve ?? Curves.decelerate,
      offset: condition ? startOffset : endOffset,
      duration: Duration(milliseconds: duration ?? 500),
      child: child,
    );
  }
}