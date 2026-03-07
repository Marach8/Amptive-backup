import 'dart:async';

import 'package:amptive/src/config/config_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class ATSlidingRouteTransition<T> extends CustomTransitionPage<T> {
  ATSlidingRouteTransition({required super.child, this.beginOffset})
      : super(
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            Animation<Offset> tween = Tween<Offset>(
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
            Animation<double> tween = Tween<double>(
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

FutureOr<String?> tempRedirect(
    BuildContext context, GoRouterState state) async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  final String? shouldRedirect = await storage.read(
    key: ATStrings.SHOULD_REDIRECT,
  );
  final String? isNewUser = await storage.read(key: ATStrings.isNewUser);

  if (shouldRedirect == 'true') {
    await storage.write(
        key: ATStrings.SHOULD_REDIRECT, value: false.toString());

    if (isNewUser == 'false') {
      return ATRoutes.POST_ONBOARDING_SCREEN.addSlash;
    } else {
      return ATRoutes.ONBOARDING_SCREEN.addSlash;
    }
  }

  return null;
}
