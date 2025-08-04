import 'dart:math';
import 'package:amptive/src/global_export.dart';
import 'package:flutter/material.dart';


class BlurredRotatingRadialLines extends StatefulWidget {
  const BlurredRotatingRadialLines({super.key, required this.child});
  final Widget child;

  @override
  State<BlurredRotatingRadialLines> createState() => _BlurredRotatingRadialLinesState();
}

class _BlurredRotatingRadialLinesState extends State<BlurredRotatingRadialLines> {
  double _turns = 0.0;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _toggleDirection()
    );
  }

  void _toggleDirection() 
    => setState(() => _turns = _turns == 0.0 ? -0.25 : 0.0);


  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: _turns,
      duration: const Duration(seconds: 5),
      curve: Curves.easeInOut,
      onEnd: () => _toggleDirection(),
      child: widget.child,
    );
  }
}




class RadialLinesPainter extends CustomPainter {
  RadialLinesPainter({
    this.startAngle = 130.0,
    this.endAngle = -20.0,
    this.noOfFanLines = 20,
    this.radius = 50,
  });
  
  final double startAngle, endAngle, radius;
  final int noOfFanLines;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = ATColors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50)
      ..strokeWidth = 3;

    final double centerX = size.width / 2;
    final double originY = size.height; // bottom center

    final double angleStep = (endAngle - startAngle) / (noOfFanLines - 1);

    for (int i = 0; i < noOfFanLines; i++) {
      final double angleDeg = startAngle + i * angleStep;
      final double angleRad = angleDeg * pi / 180;

      // Calculate starting point on the arc
      final Offset start = Offset(
        centerX + radius * cos(angleRad),
        originY - radius * sin(angleRad),
      );

      // Calculate end point of the line
      const double lineLength = 300.0;
      final Offset end = Offset(
        start.dx + lineLength * cos(angleRad),
        start.dy - lineLength * sin(angleRad),
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}