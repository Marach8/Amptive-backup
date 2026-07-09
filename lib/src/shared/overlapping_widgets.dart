import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/shimmer.dart';

class ATOverlappingImages extends StatefulWidget {
  const ATOverlappingImages({
    super.key,
    required this.imgPaths,
    this.imgSize = 20.0,
    this.overlapOffset = 15.0,
    this.borderWidth = 0.5,
    this.borderColor,
    this.animateChanges = false,
  });

  final List<String> imgPaths;
  final double imgSize;
  final Color? borderColor;
  final bool animateChanges;
  final double overlapOffset, borderWidth;

  @override
  State<ATOverlappingImages> createState() => _ATOverlappingImagesState();
}

class _ATOverlappingImagesState extends State<ATOverlappingImages>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;
  Timer? _changeTimer;
  Set<String> _newlyAddedPaths = <String>{};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Initial animation delay on load
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) _controller.forward();
    });

    // Repeat the worm animation at subtle intervals (every 7 seconds)
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (mounted) {
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _changeTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ATOverlappingImages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.animateChanges) return;

    _newlyAddedPaths = widget.imgPaths
        .where((String path) => !oldWidget.imgPaths.contains(path))
        .toSet();
    if (_newlyAddedPaths.isEmpty) return;

    _changeTimer?.cancel();
    _changeTimer = Timer(const Duration(milliseconds: 420), () {
      if (mounted) setState(() => _newlyAddedPaths = <String>{});
    });
  }

  Widget _buildAnimatedCircle(Widget child, double beginTime, double endTime) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, childWidget) {
        double t = 0.0;
        final double progress = _controller.value;
        if (progress >= beginTime && progress <= endTime) {
          t = (progress - beginTime) / (endTime - beginTime);
        }
        final double dy = -6.0 * math.sin(t * math.pi);
        return Transform.translate(
          offset: Offset(0, dy),
          child: childWidget,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final int length = widget.imgPaths.length;
    final double width = widget.imgSize + ((length - 1) * widget.overlapOffset);

    if (length == 0) return SizedBox(width: width, height: widget.imgSize);

    return SizedBox(
      height: widget.imgSize,
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        children: widget.imgPaths.indexed.map(((int, String) entry) {
          double beginTime = 0.0;
          double endTime = 1.0;

          if (length > 1) {
            final double step = 0.5 / (length - 1);
            beginTime = entry.$1 * step;
            endTime = beginTime + 0.5;
          } else {
            beginTime = 0.0;
            endTime = 0.5;
          }

          final bool isNew = _newlyAddedPaths.contains(entry.$2);
          final Widget avatar = TweenAnimationBuilder<double>(
            key: ValueKey<String>('${entry.$2}-$isNew'),
            tween: Tween<double>(begin: isNew ? 0 : 1, end: 1),
            duration: isNew ? const Duration(milliseconds: 360) : Duration.zero,
            curve: Curves.easeOutBack,
            builder: (BuildContext context, double value, Widget? child) {
              final double opacity = value.clamp(0, 1);
              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, 5 * (1 - opacity)),
                  child: Transform.scale(
                    scale: 0.78 + (0.22 * opacity),
                    child: child,
                  ),
                ),
              );
            },
            child: _buildAnimatedCircle(
              ATCircularImage(
                imagePath: entry.$2,
                diameter: widget.imgSize,
                addBorder: true,
                borderColor: widget.borderColor,
                borderWidth: widget.borderWidth,
              ),
              beginTime,
              endTime,
            ),
          );

          return AnimatedPositioned(
            key: ValueKey<String>(entry.$2),
            duration: widget.animateChanges
                ? const Duration(milliseconds: 280)
                : Duration.zero,
            curve: Curves.easeOutCubic,
            left: entry.$1 * widget.overlapOffset,
            child: avatar,
          );
        }).toList(),
      ),
    );
  }
}

class ATOverlappingCircles extends StatelessWidget {
  const ATOverlappingCircles({
    super.key,
    required this.maxNumber,
    this.circleSize = 42.0,
    this.overlapOffset = 32.0,
    this.borderWidth = 1,
    this.borderColor,
  });

  final double circleSize;
  final Color? borderColor;
  final double overlapOffset, borderWidth;
  final int maxNumber;

  @override
  Widget build(BuildContext context) {
    final List<int> numbers =
        List<int>.generate(maxNumber, (int index) => index);
    final double width = circleSize + ((numbers.length - 1) * overlapOffset);

    return SizedBox(
      height: circleSize,
      width: width,
      child: Stack(
        children: numbers.indexed.map(((int, int) entry) {
          return Positioned(
            left: entry.$1 * overlapOffset,
            child: Container(
              height: circleSize,
              width: circleSize,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(circleSize),
                  color: ATColors.black.withValues(alpha: 0.05),
                  border: Border.all(
                    color: borderColor ?? ATColors.white.withValues(alpha: 0.4),
                    width: borderWidth,
                  )),
              child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Center(
                      child: Text((entry.$1 + 1).toString(),
                          style: context.textTheme.labelSmall
                              ?.copyWith(fontSize: ATSizes.size11)),
                    ),
                  )),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class OverlappingImagesShimmer extends StatelessWidget {
  const OverlappingImagesShimmer({
    super.key,
    this.size = 35,
    this.overlapOffset = 25,
    this.borderWidth = 1,
    this.number = 4,
  });

  final double size, number;
  final double overlapOffset, borderWidth;

  @override
  Widget build(BuildContext context) {
    final double width = size + ((number - 1) * overlapOffset);

    return SizedBox(
      height: size,
      width: width,
      child: Stack(
          children: List<Widget>.generate(number.toInt(), (int index) {
        return Positioned(
          left: index * overlapOffset,
          child: Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ATColors.white,
                  width: borderWidth,
                )),
            child: ATShimmer(
              height: size,
              width: size,
              radius: size,
            ),
          ),
        );
      })),
    );
  }
}
