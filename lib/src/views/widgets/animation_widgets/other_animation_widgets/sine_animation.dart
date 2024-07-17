import 'dart:math';

import 'package:amptive/src/utils/constants/colors.dart';
import 'package:flutter/material.dart';


class SineWaveImplementer extends StatefulWidget {
  const SineWaveImplementer({super.key});

  @override
  State<SineWaveImplementer> createState() => _SineWaveImplementerState();
}

class _SineWaveImplementerState extends State<SineWaveImplementer>
    with SingleTickerProviderStateMixin {
  late AnimationController _sineController;
  late Animation _sineAnimation;

  @override
  void initState() {
    _sineController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    _sineAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _sineController, curve: Curves.linear));

    _sineController.forward(from: 0);
    _sineController.repeat();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (context, child) {
        return CustomPaint(
          painter: SinePainter(_sineController),
          size: const Size(double.infinity, 200),
        );
      },
      animation: _sineAnimation,
    );
  }
}

class SinePainter extends CustomPainter {
  final AnimationController controller;
  final List<int> amplitudeValues = [ 8, 40, 10, 20, 80, 5, 10, 20, 7,  120, 8,
    20,  160, 80, 250, 10, 20, 40, 80,
    10, 20, 120, 160, 20,  250, 5, 10, 20]; // Define amplitude values


  SinePainter(this.controller);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = AmpColors.brandBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    double width = size.width;
    double height = size.height;
    double centerY = height / 2;


    int index = (controller.value * (amplitudeValues.length - 1)).round();

    double period = width / 1.75; // Adjust the period of the sine wave
    double scale = 200 / height;
    double amplitude = (-1 * scale * height / amplitudeValues[index]); // Adjust the amplitude of the sine wave

    Path path = Path();
    path.moveTo(0, centerY);


    for (double x = 0; x <= width; x += 4) {
      double y =
          centerY + sin((x / period) * 2 * pi) * amplitude ;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;


}
