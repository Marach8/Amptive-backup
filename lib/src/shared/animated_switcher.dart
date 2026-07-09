import 'package:flutter/material.dart';

class ATFadingSwitcher extends StatelessWidget {
  const ATFadingSwitcher({
    super.key,
    required this.child,
    this.duration,
  });

  final Widget child;
  final int? duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: duration ?? 500),
        reverseDuration: Duration(milliseconds: duration ?? 500),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: child);
  }
}

class ATScalingSwitcher extends StatelessWidget {
  const ATScalingSwitcher({
    super.key,
    required this.child,
    this.duration,
    this.curve,
  });

  final Widget child;
  final int? duration;
  final Curve? curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: duration ?? 500),
        reverseDuration: Duration(milliseconds: duration ?? 500),
        switchInCurve: curve ?? Curves.easeIn,
        switchOutCurve: curve ?? Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: child);
  }
}

/// Crossfades between two states while smoothly animating the height change
/// between them — for swaps where the two children differ a lot in size (e.g.
/// a short "select" prompt vs a taller selected card). Avoids the pop-in and
/// layout jump of a scale-from-zero switch.
class ATSmoothSwitcher extends StatelessWidget {
  const ATSmoothSwitcher({
    super.key,
    required this.child,
    this.duration,
  });

  final Widget child;
  final int? duration;

  @override
  Widget build(BuildContext context) {
    final Duration d = Duration(milliseconds: duration ?? 260);
    return AnimatedSize(
      duration: d,
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: d,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeIn,
        // Size to the incoming child only — the outgoing one is positioned as
        // an overlay so it doesn't keep the box at its (taller) height. This
        // lets the surrounding layout collapse immediately instead of waiting
        // for the outgoing child to finish fading.
        layoutBuilder:
            (Widget? currentChild, List<Widget> previousChildren) => Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: <Widget>[
            ...previousChildren.map(
              (Widget c) => Positioned(left: 0, right: 0, top: 0, child: c),
            ),
            if (currentChild != null) currentChild,
          ],
        ),
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Fade only over the back half of the timeline. Because the
          // outgoing child plays this in reverse, it clears out in the first
          // half — so the two states hand off cleanly instead of overlapping.
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
            ),
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}

class ATSlidingSwitcher extends StatelessWidget {
  const ATSlidingSwitcher({
    super.key,
    required this.child,
    this.duration,
    this.curve,
  });

  final Widget child;
  final int? duration;
  final Curve? curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: duration ?? 500),
        reverseDuration: Duration(milliseconds: duration ?? 500),
        switchInCurve: curve ?? Curves.easeIn,
        switchOutCurve: curve ?? Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final Animation<Offset> inAnimation = Tween<Offset>(
            begin: const Offset(0, 1.5),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

          return SlideTransition(position: inAnimation, child: child);
        },
        child: child);
  }
}
