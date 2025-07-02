import 'package:flutter/material.dart';

class CustomPageRouteTransitionBuilder extends PageRouteBuilder {

  CustomPageRouteTransitionBuilder({required this.page}): super(
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => page,
    transitionsBuilder: (_, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      const Offset begin = Offset(0.0, 1.0);
      const Offset end = Offset.zero;
      const Curve curve = Curves.linear;

      Animation<Offset> tween = Tween(begin: begin, end: end).animate(

        CurvedAnimation(
          parent: animation,
          curve: curve,
        ),
      );

      return SlideTransition(
        position: tween,
        child: child,
      );
    },
    reverseTransitionDuration: const Duration(milliseconds: 700),
    transitionDuration: const Duration(milliseconds: 700),
  );
  final Widget page;
}
