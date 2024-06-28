
import 'package:amptive/utils/utils.dart';
import 'package:flutter/material.dart';

class TempList extends StatefulWidget {
  const TempList({Key? key}) : super(key: key);

  @override
  State<TempList> createState() => _TempListState();
}

class _TempListState extends State<TempList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isStretched = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Moon Animation'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _toggleMoon,
          child: Transform(
            transform: Matrix4.identity()..rotateZ(0.3),
            child: AnimatedContainer(
              duration: Duration(seconds: 2),
              width: 294.0,
              height: 291,
              child: CustomPaint(
                painter: HalfMoonPainter(
                    animation: _animation, stretchedMode: isStretched),
              ),
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

  HalfMoonPainter({required this.animation, required this.stretchedMode})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    var w = size.width;
    var h = size.height;

    final paint = Paint()
      ..color = AmpColors.brandBlue
      ..style = PaintingStyle.fill
      ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(80));

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
      double controlPointY = animation.value * -w * 0.5;
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
