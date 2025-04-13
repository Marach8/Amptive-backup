import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';


class SpotlightBeam extends StatelessWidget {
  const SpotlightBeam({
    super.key,
    required this.gradient,
    this.duration
  });
  final Gradient? gradient;
  final int? duration;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: SpotlightClipper(),
      child: ATContainer(
        duration: duration,
        height: ATHelperFuncs.getScreenHeight(context) * 0.4,
        width: ATHelperFuncs.getScreenWidth(context) * 0.5,
        gradient: gradient
      ),
    );
  }
}

class SpotlightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2 - 30, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2 + 30, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
