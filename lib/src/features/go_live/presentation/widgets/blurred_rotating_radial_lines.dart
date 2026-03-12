import 'dart:math' hide log;
import 'package:amptive/src/global_export.dart';

class RotatingRadialLines extends StatefulWidget {
  const RotatingRadialLines({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 5),
  });

  final Widget child;
  final Duration duration;

  @override
  State<RotatingRadialLines> createState() => _RotatingRadialLinesState();
}

class _RotatingRadialLinesState extends State<RotatingRadialLines>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      lowerBound: -0.25,
      upperBound: 0.0,
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, Widget? child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      },
      child: RepaintBoundary(child: widget.child),
    );
  }
}

class RadialLinesWidget extends StatelessWidget {
  const RadialLinesWidget({
    super.key,
    this.startAngle = 130.0,
    this.endAngle = -20.0,
  });

  final double startAngle, endAngle;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      isComplex: true,
      size: Size(context.screenWidth * 0.7, context.screenHeight * 0.3),
      painter: RadialLinesPainter(
          startAngle: startAngle,
          endAngle: endAngle,
          lineLength: context.screenHeight * 0.45),
    );
  }
}

class RadialLinesPainter extends CustomPainter {
  RadialLinesPainter({
    required this.lineLength,
    required this.startAngle,
    required this.endAngle,
    this.noOfFanLines = 20,
    this.radius = 50,
  });

  final double startAngle, endAngle, radius, lineLength;
  final int noOfFanLines;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = ATColors.white
      ..strokeWidth = 3;

    final double centerX = size.width / 2;
    final double originY = size.height;

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
      final Offset end = Offset(
        start.dx + lineLength * cos(angleRad),
        start.dy - lineLength * sin(angleRad),
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
