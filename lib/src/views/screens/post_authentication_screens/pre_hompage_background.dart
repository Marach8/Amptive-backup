
import 'dart:async';

import 'package:amptive/src/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class PreHomePageBackground extends StatefulWidget {
  final Color? color;
  final double angle;
  
  const PreHomePageBackground({
    super.key,
    this.color,
    this.angle = 0.0
  });


  @override
  State<PreHomePageBackground> createState() => _PreHomePageBackgroundState();
}

class _PreHomePageBackgroundState extends State<PreHomePageBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  bool isStretched = false;



  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer)  {
      _toggleMoon();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _toggleMoon() {
    setState(() {
      isStretched = !isStretched;
      if (isStretched) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Transform.rotate(
          angle: widget.angle,
          child: AnimatedContainer(
            duration: const Duration(seconds: 2),
            width: 294.0,
            height: 291,
            child: CustomPaint(
              painter: HalfMoonPainter(
                animation: _animation,
                stretchedMode: isStretched,
                color: widget.color ?? AmptiveColors.hex307FE2,
              ),
            ),
          ),
        ),
      );
  }
}

class HalfMoonPainter extends CustomPainter {
  final Animation<double> animation;
  final bool stretchedMode;
  final Color color;

  HalfMoonPainter({required this.animation, required this.stretchedMode, required this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    var w = size.width;
    var h = size.height;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(1000));

    final path = Path();

    path.moveTo(w * 0.3, h * 0.7);
    path.lineTo(w * 0.2, h * 0.8);

    path.arcToPoint(
        Offset(
          w * 0.45,
          0,
        ),
        radius: Radius.circular(w * 0.5));
    if (stretchedMode) {
      double controlPointY = animation.value * -w * 0.6;
      path.quadraticBezierTo(w * 0.6, controlPointY, w * 0.75, 0);
    }else{
      if(animation.value != 0) {
        double controlPointY = animation.value * -w * 0.5;
        path.quadraticBezierTo(w * 0.6, controlPointY, w * 0.75, 0);
      }
    }
    path.arcToPoint(Offset(w, h * 0.5), radius: Radius.circular(w * 0.45));

    path.lineTo(w * 0.87, h * 0.5);

    path.arcToPoint(Offset(w * 0.3, h * 0.7),
        radius: Radius.circular(w * 0.2), clockwise: false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
