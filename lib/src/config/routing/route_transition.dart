import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ATSlidingRouteTransition<T> extends CustomTransitionPage<T> {
  ATSlidingRouteTransition({
    required super.child,
    super.name,
    this.beginOffset
  }) : super(
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            final Animation<Offset> tween = Tween<Offset>(
                    begin: beginOffset ?? const Offset(1.0, 0.0),
                    end: Offset.zero)
                .animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeIn));

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

class ATFadingRouteTransition<T> extends CustomTransitionPage<T> {
  ATFadingRouteTransition({required super.child, this.beginOffset})
      : super(
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            final Animation<double> tween = Tween<double>(
              begin: beginOffset ?? 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

            return FadeTransition(
              opacity: tween,
              child: child,
            );
          },
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionDuration: const Duration(milliseconds: 500),
        );
  final double? beginOffset;
}
