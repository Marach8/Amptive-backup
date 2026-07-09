import 'dart:async';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

/// Native iOS-standard push transition with parallax, shadow, and spring curve.
/// This is the exact same animation used by Instagram, Spotify, X, and every
/// other premium iOS app. Uses Flutter's built-in CupertinoPageTransition.
class ATSlidingRouteTransition<T> extends CustomTransitionPage<T> {
  ATSlidingRouteTransition({required super.child})
      : super(
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return CupertinoPageTransition(
              primaryRouteAnimation: animation,
              secondaryRouteAnimation: secondaryAnimation,
              linearTransition: false, // Uses the native spring/ease-out curve
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 400),
        );
}

/// Fade transition for screens that should appear without a directional push
/// (e.g. modals, bottom sheets, tab switches). Uses easeOut so the fade decelerates
/// naturally — starting fast and gently landing on the final frame.
class ATFadingRouteTransition<T> extends CustomTransitionPage<T> {
  ATFadingRouteTransition({required super.child})
      : super(
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut, // Fixed: was easeIn (wrong direction)
              ),
              child: child,
            );
          },
          reverseTransitionDuration: const Duration(milliseconds: 150),
          transitionDuration: const Duration(milliseconds: 200),
        );
}

/// Full-screen creation/action flow presented vertically from the bottom.
/// Unlike [ATModalRouteTransition], this remains opaque and has no rounded
/// sheet corners or drag-to-dismiss behavior.
class ATBottomUpRouteTransition<T> extends CustomTransitionPage<T> {
  ATBottomUpRouteTransition({required super.child})
      : super(
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              )),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 300),
        );
}

/// Bottom-up modal transition — the industry standard for detail screens,
/// media players, and overlays (used by Spotify's Now Playing, Apple Music,
/// and most iOS share sheets).
class ATModalRouteTransition<T> extends Page<T> {
  final Widget child;

  const ATModalRouteTransition({
    required this.child,
    super.key,
    super.name,
    super.arguments,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return RawDialogRoute<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionBuilder: (context, animation, secondaryAnimation, childWidget) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: const Cubic(
                0.2, 1.15, 0.2, 1.0), // Fluid/Liquid bounce on enter
            reverseCurve: Curves.easeOutCubic, // Smooth, non-bouncy exit
          )),
          child: ATInteractiveDragDismiss(
            child: ClipSmoothRect(
              radius: SmoothBorderRadius.vertical(
                top: SmoothRadius(cornerRadius: 32, cornerSmoothing: 1),
              ),
              child: childWidget,
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 550),
      barrierColor: Colors.transparent,
      barrierDismissible: false,
    );
  }
}

/// Interactive Native Bottom Sheet Transition.
/// Provides native drag-down-to-dismiss physics integrated with GoRouter.
class ATInteractiveModalPage<T> extends Page<T> {
  final Widget child;

  const ATInteractiveModalPage({
    required this.child,
    super.key,
    super.name,
    super.arguments,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      builder: (context) => ClipSmoothRect(
        radius: SmoothBorderRadius.vertical(
          top: SmoothRadius(cornerRadius: 32, cornerSmoothing: 1),
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.94,
          child: child,
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: false,
      settings: this,
    );
  }
}

class ModalDragNotifier extends InheritedWidget {
  final Function(double) onDragUpdate;
  final Function(double) onDragEnd;

  const ModalDragNotifier({
    super.key,
    required this.onDragUpdate,
    required this.onDragEnd,
    required super.child,
  });

  static ModalDragNotifier? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ModalDragNotifier>();
  }

  @override
  bool updateShouldNotify(ModalDragNotifier oldWidget) => false;
}

class ATInteractiveDragDismiss extends StatefulWidget {
  final Widget child;
  const ATInteractiveDragDismiss({super.key, required this.child});

  @override
  State<ATInteractiveDragDismiss> createState() =>
      _ATInteractiveDragDismissState();
}

class _ATInteractiveDragDismissState extends State<ATInteractiveDragDismiss>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  double _dragOffset = 0.0;
  bool _popped = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animController.addListener(() {
      setState(() {
        _dragOffset = _animController.value;
      });
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(double delta) {
    if (_popped) return;
    setState(() {
      _dragOffset += delta;
      if (_dragOffset < 0) _dragOffset = 0;
    });
  }

  void _handleDragEnd(double velocity) {
    if (_popped) return;
    if (_dragOffset > 150 || velocity > 300) {
      _popped = true;
      if (ModalRoute.of(context)?.isCurrent == true) {
        Navigator.pop(context);
      }
    } else {
      // Animate back to 0 smoothly
      _animController.value = _dragOffset;
      _animController.animateTo(0.0, curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalDragNotifier(
      onDragUpdate: _handleDragUpdate,
      onDragEnd: _handleDragEnd,
      child: Transform.translate(
        offset: Offset(0, _dragOffset),
        child: NotificationListener<OverscrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis == Axis.vertical &&
                notification.overscroll < 0) {
              _handleDragUpdate(-notification.overscroll);
            }
            return false;
          },
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (notification.metrics.axis == Axis.vertical &&
                  _dragOffset > 0) {
                _handleDragEnd(
                    notification.dragDetails?.primaryVelocity ?? 0.0);
              }
              return false;
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

FutureOr<String?> tempRedirect(
    BuildContext context, GoRouterState state) async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  final String? shouldRedirect = await storage.read(
    key: ATStrings.shouldRedirect,
  );
  final String? isNewUser = await storage.read(key: ATStrings.isNewUser);

  if (shouldRedirect == 'true') {
    await storage.write(key: ATStrings.shouldRedirect, value: false.toString());

    if (isNewUser == 'false') {
      return ATRoutes.postOnboardingScreen.addSlash;
    } else {
      return ATRoutes.onboardingScreen.addSlash;
    }
  }

  return null;
}
