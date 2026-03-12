import 'package:flutter/material.dart';

class ATAnimatedSlide extends StatelessWidget {
  const ATAnimatedSlide(
      {super.key,
      required this.startOffset,
      required this.child,
      required this.endOffset,
      required this.shouldSlide,
      this.curve,
      this.duration,
      this.onEnd});

  final Widget child;
  final Offset startOffset, endOffset;
  final bool shouldSlide;
  final int? duration;
  final Curve? curve;
  final void Function()? onEnd;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      curve: curve ?? Curves.decelerate,
      offset: shouldSlide ? endOffset : startOffset,
      duration: Duration(milliseconds: duration ?? 500),
      onEnd: onEnd,
      child: child,
    );
  }
}
