import 'package:amptive/src/config/utils/colors.dart';
import 'package:flutter/material.dart';

class LiveUserAnimationWidget extends StatefulWidget {
  const LiveUserAnimationWidget({super.key, required this.child});
  final Widget child;

  @override
  State<LiveUserAnimationWidget> createState() => _SizeAnimationState();
}

class _SizeAnimationState extends State<LiveUserAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController sizeController;
  late Animation<double> paddingAnimation;

  @override
  void initState() {
    super.initState();
    sizeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(_) => AnimatedBuilder(
    animation: sizeController,
    builder: (_, __) {
      // Evaluating the tween dynamically inside build makes it 100% hot-reloadable!
      final double currentPadding = Tween<double>(begin: 4.5, end: 7.5).evaluate(
        CurvedAnimation(parent: sizeController, curve: Curves.ease),
      );

      return CustomPaint(
        painter: _GradientBorderPainter(
          strokeWidth: 2.5,
          animationValue: sizeController.value,
        ),
        child: Container(
          padding: EdgeInsets.all(currentPadding),
          height: 70,
          width: 70,
          child: ClipOval(
            child: widget.child,
          ),
        ),
      );
    },
  );
}

class _GradientBorderPainter extends CustomPainter {
  _GradientBorderPainter({required this.strokeWidth, required this.animationValue});
  final double strokeWidth;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the main inner thick ring
    final Rect rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final Paint paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Color(0xFFF91880), Color(0xFFF92018)],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawOval(rect, paint);

    // Draw the secondary expanding thin outer ring
    if (animationValue > 0) {
      final double expansion = animationValue * 4.0; // Reduced expansion from 8px to 4px to prevent clipping
      final double outerStrokeWidth = 1.0; // Thinner line
      final Rect outerRect = Rect.fromLTWH(
        -expansion + (outerStrokeWidth / 2),
        -expansion + (outerStrokeWidth / 2),
        size.width + (expansion * 2) - outerStrokeWidth,
        size.height + (expansion * 2) - outerStrokeWidth,
      );

      final Paint outerPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            const Color(0xFFF91880).withOpacity(animationValue),
            const Color(0xFFF92018).withOpacity(animationValue),
          ],
        ).createShader(outerRect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = outerStrokeWidth;

      canvas.drawOval(outerRect, outerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth || oldDelegate.animationValue != animationValue;
  }
}
