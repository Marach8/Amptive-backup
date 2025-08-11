// import 'dart:math';
// import 'dart:ui' as ui;
// import 'dart:ui' show PictureRecorder, Picture;
// import 'package:amptive/src/config/config_export.dart';
// import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
// import 'package:flutter/material.dart';


// class OnboardCustomPaint extends StatelessWidget {
//   const OnboardCustomPaint({
//     super.key,
//     this.startAngle = 130.0,
//     this.endAngle = -20.0,
//   });

//   final double startAngle, endAngle;

//   @override
//   Widget build(BuildContext context) {
//     return _CachedRadialLines(
//       size: const Size(300, 300),
//       startAngle: startAngle,
//       endAngle: endAngle,
//     );
//   }
// }



// class BlurredRotatingRadialLines extends StatefulWidget {
//   const BlurredRotatingRadialLines({
//     super.key,
//     required this.child,
//     this.duration = const Duration(seconds: 5),
//   });

//   final Widget child;
//   final Duration duration;

//   @override
//   State<BlurredRotatingRadialLines> createState() => _BlurredRotatingRadialLinesState();
// }



// class _BlurredRotatingRadialLinesState extends State<BlurredRotatingRadialLines>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: widget.duration,
//       vsync: this,
//     )..repeat(reverse: true);

//     _animation = Tween<double>(begin: 0.0, end: -0.25).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       child: AnimatedBuilder(
//         animation: _animation,
//         builder: (_, Widget? child) {
//           return Transform.rotate(
//             angle: _animation.value * 2 * pi,
//             child: child,
//           );
//         },
//         child: widget.child,
//       ),
//     );
//   }
// }



// class _CachedRadialLines extends StatefulWidget {
//   const _CachedRadialLines({
//     super.key,
//     required this.size,
//     this.startAngle = 130.0,
//     this.endAngle = -20.0,
//     this.noOfFanLines = 20,
//     this.radius = 50,
//   });

//   final Size size;
//   final double startAngle, endAngle, radius;
//   final int noOfFanLines;

//   @override
//   State<_CachedRadialLines> createState() => _CachedRadialLinesState();
// }

// class _CachedRadialLinesState extends State<_CachedRadialLines> {
//   ui.Image? _cachedImage;
//   bool _isGenerating = false;

//   @override
//   void initState() {
//     super.initState();
//     _generateCachedImage();
//   }

//   Future<void> _generateCachedImage() async {
//     if (_isGenerating) return;
//     _isGenerating = true;

//     final PictureRecorder recorder = ui.PictureRecorder();
//     final Canvas canvas = Canvas(recorder);
    
//     final Paint paint = Paint()
//       ..color = ATColors.white
//       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50)
//       ..strokeWidth = 3;

//     final double centerX = widget.size.width / 2;
//     final double originY = widget.size.height; // bottom center
//     final double angleStep = (widget.endAngle - widget.startAngle) / (widget.noOfFanLines - 1);

//     for (int i = 0; i < widget.noOfFanLines; i++) {
//       final double angleDeg = widget.startAngle + i * angleStep;
//       final double angleRad = angleDeg * pi / 180;

//       // Calculate starting point on the arc
//       final Offset start = Offset(
//         centerX + widget.radius * cos(angleRad),
//         originY - widget.radius * sin(angleRad),
//       );

//       // Calculate end point of the line
//       const double lineLength = 300.0;
//       final Offset end = Offset(
//         start.dx + lineLength * cos(angleRad),
//         start.dy - lineLength * sin(angleRad),
//       );

//       canvas.drawLine(start, end, paint);
//     }

//     final Picture picture = recorder.endRecording();
//     final ui.Image image = await picture.toImage(
//       widget.size.width.toInt(),
//       widget.size.height.toInt(),
//     );

//     if (mounted) {
//       setState(() {
//         _cachedImage?.dispose();
//         _cachedImage = image;
//         _isGenerating = false;
//       });
//     }

//     picture.dispose();
//   }

//   @override
//   void dispose() {
//     _cachedImage?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_cachedImage == null) {
//       return SizedBox.fromSize(
//         size: widget.size,
//         child: const Center(child: ATLoadingIndicator()),
//       );
//     }

//     return CustomPaint(
//       size: widget.size,
//       painter: _CachedImagePainter(_cachedImage!),
//     );
//   }
// }



// class _CachedImagePainter extends CustomPainter {
//   const _CachedImagePainter(this.image);
  
//   final ui.Image image;

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawImage(image, Offset.zero, Paint());
//   }

//   @override
//   bool shouldRepaint(_)  => false;
// }
