import 'package:flutter/material.dart';

class CustomPageRouteTransitionBuilder extends PageRouteBuilder {
  final Widget page;

  CustomPageRouteTransitionBuilder({required this.page}): super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.linear;

      var tween = Tween(begin: begin, end: end).animate(

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
}
