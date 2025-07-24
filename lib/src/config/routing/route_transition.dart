import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ATRouteTransition<T> extends CustomTransitionPage<T>{
  ATRouteTransition({
    required super.child,
    this.beginOffset
  }) : super(
    transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      Animation<Offset> tween = Tween<Offset>(
        begin: beginOffset ?? const Offset(1.0, 0.0), 
        end: Offset.zero
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeIn)
      );

      return SlideTransition(
        position: tween,
        child: child,
      );
    },
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionDuration: const Duration(milliseconds: 200),
  );
  final Offset? beginOffset;
}
