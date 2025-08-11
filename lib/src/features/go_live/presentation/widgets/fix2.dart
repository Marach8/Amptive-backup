// import 'dart:math';

// import 'package:flutter/material.dart';

// class OptimizedRadialLines extends StatelessWidget {
//   const OptimizedRadialLines({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox(
//       width: 300,
//       height: 300,
//       child: CoolWidget(),
//     );
//   }
// }


// class CoolWidget extends StatefulWidget {
//   const CoolWidget({super.key});

//   @override
//   State<CoolWidget> createState() => _CoolWidgetState();
// }

// class _CoolWidgetState extends State<CoolWidget> with SingleTickerProviderStateMixin{
//   late final AnimationController _controller;
//   final _lines = _generateLines(); // Pre-compute line paths

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 10),
//     )..repeat(reverse: true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (_, __) {
//         return CustomPaint(
//           painter: _CachedRadialLinesPainter(
//             progress: _controller.value,
//             lines: _lines,
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   static List<_LineSegment> _generateLines() {
//     const startAngle = 130.0;
//     const endAngle = -20.0;
//     const noOfFanLines = 20;
//     const radius = 50;
    
//     final lines = <_LineSegment>[];
//     final angleStep = (endAngle - startAngle) / (noOfFanLines - 1);

//     for (int i = 0; i < noOfFanLines; i++) {
//       final angleDeg = startAngle + i * angleStep;
//       final angleRad = angleDeg * pi / 180;
      
//       lines.add(_LineSegment(
//         angle: angleRad,
//         start: Offset(
//           radius * cos(angleRad), 
//           radius * sin(angleRad)
//         )
//       ));
//     }
//     return lines;
//   }
// }

// class _CachedRadialLinesPainter extends CustomPainter {
//   final double progress;
//   final List<_LineSegment> lines;

//   _CachedRadialLinesPainter({required this.progress, required this.lines});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width/2, size.height);
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.2)
//       ..strokeWidth = 2;

//     for (final line in lines) {
//       final rotatedAngle = line.angle + (progress * pi / 2);
//       final end = Offset(
//         line.start.dx + 300 * cos(rotatedAngle),
//         line.start.dy + 300 * sin(rotatedAngle)
//       );
      
//       canvas.drawLine(
//         center + line.start,
//         center + end,
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(_CachedRadialLinesPainter old) => old.progress != progress;
// }

// class _LineSegment {
//   final double angle;
//   final Offset start;
  
//   _LineSegment({required this.angle, required this.start});
// }