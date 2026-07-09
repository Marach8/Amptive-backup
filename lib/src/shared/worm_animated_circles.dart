import 'dart:async';
import 'dart:math' as math;
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:flutter/material.dart';

class WormAnimatedCircles extends StatefulWidget {
  const WormAnimatedCircles({super.key, required this.userAvatarUrl, this.borderColor});
  final String userAvatarUrl;
  final Color? borderColor;

  @override
  State<WormAnimatedCircles> createState() => _WormAnimatedCirclesState();
}

class _WormAnimatedCirclesState extends State<WormAnimatedCircles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Initial animation delay on load
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) _controller.forward();
    });

    // Repeat the worm animation at subtle intervals (every 7 seconds)
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (mounted) {
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedCircle(Widget child, double beginTime, double endTime) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, childWidget) {
        double t = 0.0;
        final double progress = _controller.value;
        
        // Calculate where we are in this specific circle's animation window
        if (progress >= beginTime && progress <= endTime) {
          t = (progress - beginTime) / (endTime - beginTime);
        }

        // Create a smooth upward bump using a sine wave
        final double dy = -6.0 * math.sin(t * math.pi);

        return Transform.translate(
          offset: Offset(0, dy),
          child: childWidget,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: 65, // 35 + 15 + 15
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            child: _buildAnimatedCircle(
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2A2A2A),
                  border: Border.all(
                      color: widget.borderColor ?? ATColors.containerGradientColorB, width: 2),
                ),
              ),
              0.0,
              0.5,
            ),
          ),
          Positioned(
            left: 15,
            child: _buildAnimatedCircle(
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF505050),
                  border: Border.all(
                      color: widget.borderColor ?? ATColors.containerGradientColorB, width: 2),
                ),
              ),
              0.25,
              0.75,
            ),
          ),
          Positioned(
            left: 30,
            child: _buildAnimatedCircle(
              ATCircularImage(
                imagePath: widget.userAvatarUrl,
                diameter: 35,
                addBorder: true,
                borderColor: widget.borderColor ?? ATColors.containerGradientColorB,
                borderWidth: 2,
              ),
              0.5,
              1.0,
            ),
          ),
        ],
      ),
    );
  }
}
