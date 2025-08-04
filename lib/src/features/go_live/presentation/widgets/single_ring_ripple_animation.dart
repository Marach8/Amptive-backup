import 'package:amptive/src/config/config_export.dart';
import 'package:flutter/material.dart';

class SingleRingRippleAnimation extends StatelessWidget {
  const SingleRingRippleAnimation({
    super.key,
    this.minRadius = 65.0,
    this.maxRadius = 120.0,
    required this.rippleNotifier,
  });

  final double minRadius;
  final double maxRadius;
  final ValueNotifier<bool> rippleNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: rippleNotifier,
      builder: (_, bool shouldAnimate, __) {
        if(!shouldAnimate) return const SizedBox.shrink();
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: minRadius, end: maxRadius),
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeOut,
          builder: (_, double currentRadius, __) {
            final double opacity = 1.0 - ((currentRadius - minRadius) / (maxRadius - minRadius));        
            return Container(
              width: currentRadius * 2,
              height: currentRadius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ATColors.white.withValues(alpha: opacity * 0.3),
                  width: 2
                ),
              ),
            );
          },
        );
      }
    );
  }
}