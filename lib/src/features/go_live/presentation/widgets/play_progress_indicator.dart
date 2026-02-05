import 'dart:math';
import 'package:amptive/src/global_export.dart';


class PlayProgressIndicator extends StatefulWidget {
  const PlayProgressIndicator({super.key});

  @override
  State<PlayProgressIndicator> createState() => _PlayProgressIndicatorState();
}

class _PlayProgressIndicatorState extends State<PlayProgressIndicator> 
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );

  late final Animation<double> _animation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _controller.forward()
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return CustomPaint(
          size: const Size(140, 140),
          painter: CircleBorderPainter(_animation.value),
        );
      },
    );
  }
}

class CircleBorderPainter extends CustomPainter {

  CircleBorderPainter(this.progress);
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = ATColors.hex307FE2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width / 2) - 2;

    // Only draw if there's progress
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CircleBorderPainter oldDelegate)
    => oldDelegate.progress != progress;
}
