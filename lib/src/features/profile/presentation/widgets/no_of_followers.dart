import 'dart:math';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class NoOfFollowers extends StatelessWidget {
  const NoOfFollowers({
    super.key,
    required this.noOfFollowers
  });

  final String noOfFollowers;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      splashColor: ATColors.white.withValues(alpha: 0.5),
      onTap: () => context.pushNamed(ATRoutes.PROFILE_FOLLOWING_SCREEN),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CustomPaint(
            size: const Size(16, 16),
            painter: RoundedScallopedPainter(
              color: ATColors.dimWhiteColor1
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(Icons.star, color: ATColors.black, size: 12),
            ),
          ),
          const SizedBox(width: 2,),
          Text(
            noOfFollowers.isNotEmpty? noOfFollowers :'0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: ATSizes.size16
            ),
          ),
          const SizedBox(width: 5,),
          Text(
            ATStrings.followers,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: ATSizes.size16
            ),
          ),
        ],
      ),
    );
  }
}





class RoundedScallopedPainter extends CustomPainter {
  const RoundedScallopedPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color..style = PaintingStyle.fill;

    final Path path = Path();
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2; // Radius of the main circle
    const int scallopCount = 10; // Number of scallops
    final double scallopRadius = size.width / 10; // Radius of each scallop

    for (int i = 0; i < scallopCount; i++) {
      double theta1 = (2 * pi / scallopCount) * i; // Start angle of the scallop
      double theta2 = (2 * pi / scallopCount) * (i + 1); // End angle of the scallop

      // Points for the scallop curve
      Offset startPoint = Offset(
        center.dx + (radius - scallopRadius) * cos(theta1),
        center.dy + (radius - scallopRadius) * sin(theta1),
      );
      Offset endPoint = Offset(
        center.dx + (radius - scallopRadius) * cos(theta2),
        center.dy + (radius - scallopRadius) * sin(theta2),
      );

      // Control point for smooth curves between scallops
      Offset controlPoint = Offset(
        center.dx + radius * cos((theta1 + theta2) / 2),
        center.dy + radius * sin((theta1 + theta2) / 2),
      );

      // Add the scallop curve
      if (i == 0) {
        path.moveTo(startPoint.dx, startPoint.dy);
      }
      path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        endPoint.dx,
        endPoint.dy,
      );
    }

    path.close(); // Connect the path back to the starting point
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
