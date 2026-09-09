import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';

class SpotlightBeam extends StatelessWidget {
  const SpotlightBeam({
    super.key,
    required this.gradient,
    this.duration,
    this.height,
    this.width,
    this.halfWidthOfSpot,
  });
  final Gradient? gradient;
  final int? duration;
  final double? height, width, halfWidthOfSpot;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: SpotlightClipper(halfWidthOfSpot: halfWidthOfSpot ?? 30.0),
      child: ATContainer(
          duration: duration,
          height: height ?? context.screenHeight * 0.4,
          width: width ?? context.screenWidth * 0.5,
          gradient: gradient),
    );
  }
}

class SpotlightClipper extends CustomClipper<Path> {
  SpotlightClipper({required this.halfWidthOfSpot});

  final double halfWidthOfSpot;

  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo((size.width / 2) - halfWidthOfSpot, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo((size.width / 2) + halfWidthOfSpot, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_) => false;
}
