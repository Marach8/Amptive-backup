import 'package:flutter/material.dart';

/// Runs [action] once the enclosing route's entrance animation has fully
/// completed, so expensive work (network fetches, JSON parsing, image
/// decoding) never competes with the page transition for frame time. If
/// there is no route animation (or it already finished), [action] runs on
/// the next frame.
void runAfterRouteTransition(BuildContext context, VoidCallback action) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    final Animation<double>? routeAnimation = ModalRoute.of(context)?.animation;
    if (routeAnimation == null || routeAnimation.isCompleted) {
      action();
      return;
    }
    void onStatus(AnimationStatus status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        routeAnimation.removeStatusListener(onStatus);
        if (context.mounted) action();
      }
    }

    routeAnimation.addStatusListener(onStatus);
  });
}
