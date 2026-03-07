import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';

class ScheduleIcon extends StatelessWidget {
  const ScheduleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        const ATImgLoader(
            height: 20, width: 20, imgPath: ATImgStrings.CALENDER_ICON),
        Positioned(
          bottom: -2,
          right: -2,
          child: ATContainer(
            color: ATColors.white,
            border: Border.all(width: 2, color: ATColors.black),
            padding: const EdgeInsets.all(2),
            height: 13,
            width: 13,
            radius: 8,
            child: CustomPaint(
              painter: _LShapePainter(color: ATColors.black, strokeWidth: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _LShapePainter extends CustomPainter {
  _LShapePainter({required this.color, required this.strokeWidth});
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height / 2),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 2, size.height / 2),
      Offset(size.width, 2 * (size.height / 3)),
      paint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
