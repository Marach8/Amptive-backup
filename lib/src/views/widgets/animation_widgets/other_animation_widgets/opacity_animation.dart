import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ATAnimOpacity extends StatefulWidget {
  const ATAnimOpacity({super.key, required this.child, this.minOpacity = 0.3});

  final Widget child;
  final double minOpacity;

  @override
  State<ATAnimOpacity> createState() => _SizeAnimationState();
}

class _SizeAnimationState extends State<ATAnimOpacity>
    with SingleTickerProviderStateMixin {
  late AnimationController opacityController;
  late Animation<double> opacityAnimation;
  final Key _visibilityKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    opacityAnimation = Tween<double>(begin: widget.minOpacity, end: 1.0)
        .animate(CurvedAnimation(
            parent: opacityController, curve: Curves.easeInOut));
  }

  // Pauses the repeating pulse while scrolled off-screen or covered by
  // another route, so long pages full of live indicators don't keep
  // animating (and burning frames) invisibly.
  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    final bool visible = info.visibleFraction > 0;
    if (visible && !opacityController.isAnimating) {
      opacityController.repeat(reverse: true);
    } else if (!visible && opacityController.isAnimating) {
      opacityController.stop();
    }
  }

  @override
  void dispose() {
    opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(_) => VisibilityDetector(
        key: _visibilityKey,
        onVisibilityChanged: _onVisibilityChanged,
        child: AnimatedBuilder(
            animation: opacityAnimation,
            builder: (_, __) => FadeTransition(
                  opacity: opacityAnimation,
                  child: widget.child,
                )),
      );
}
