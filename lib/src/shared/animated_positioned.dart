// import 'package:flutter/material.dart';

// class ATAnimatedPositioned extends StatelessWidget {
//   const ATAnimatedPositioned({
//     super.key,
//     required this.startOffset,
//     required this.child,
//     required this.endOffset,
//     required this.condition,
//     this.curve,
//     this.duration
//   });

//   final Widget child;
//   final Offset startOffset, endOffset;
//   final bool condition;
//   final int? duration;
//   final Curve? curve;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSlide(
//       curve: curve ?? Curves.decelerate,
//       offset: condition ? endOffset : startOffset,
//       duration: Duration(milliseconds: duration ?? 500),
//       child: child,
//     );
//   }
// }