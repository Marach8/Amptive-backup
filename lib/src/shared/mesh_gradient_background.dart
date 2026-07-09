import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:amptive/src/config/utils/dominant_color_extractor.dart';
import 'package:amptive/src/global_export.dart';

class ATMeshGradientBackground extends StatefulWidget {
  final DominantColorState state;
  final Widget child;

  /// When false, the ribbons render in place but don't drift. Used to keep
  /// the mesh perfectly cheap (a single paint) during route transitions.
  final bool animate;

  const ATMeshGradientBackground({
    super.key,
    required this.state,
    required this.child,
    this.animate = true,
  });

  @override
  State<ATMeshGradientBackground> createState() =>
      _ATMeshGradientBackgroundState();
}

class _ATMeshGradientBackgroundState extends State<ATMeshGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  DominantColorLoaded? _lastLoadedState;

  @override
  void initState() {
    super.initState();
    if (widget.state is DominantColorLoaded) {
      _lastLoadedState = widget.state as DominantColorLoaded;
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );
    if (widget.animate) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant ATMeshGradientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state is DominantColorLoaded) {
      _lastLoadedState = widget.state as DominantColorLoaded;
    }
    if (widget.animate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.animate && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRibbon({
    required double w,
    required double h,
    required Color color,
    required double top,
    required double left,
    required double widthScale,
    required double heightScale,
    required double rotateZ,
    required double scaleX,
    required double scaleY,
    required double stop,
    required double phase,
    double opacity = 0.95,
  }) {
    final double angle = (_controller.value * math.pi * 2) + phase;
    final double horizontalDrift = math.sin(angle) * w * 0.045;
    final double verticalDrift = math.cos(angle + 0.7) * h * 0.025;
    final double rotationDrift = math.sin(angle + 1.4) * 0.045;
    final double breathing = 1 + math.cos(angle + 2.1) * 0.025;

    return Positioned(
      top: top + verticalDrift,
      left: left + horizontalDrift,
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..rotateZ(rotateZ + rotationDrift)
          ..scale(scaleX * breathing, scaleY * breathing),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          width: w * widthScale,
          height: h * heightScale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0.0),
              ],
              stops: [stop, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DominantColorLoaded? loadedState =
        (widget.state is DominantColorLoaded)
            ? widget.state as DominantColorLoaded
            : _lastLoadedState;

    if (loadedState != null) {
      final Color dominant = loadedState.dominantColor;
      final Color vibrant = loadedState.vibrantColor;

      final double w = MediaQuery.of(context).size.width;
      final double h = MediaQuery.of(context).size.height;

      return AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (BuildContext context, Widget? child) => RepaintBoundary(
          child: Stack(
            children: [
              // Base Canvas Color (Color 1)
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                color: dominant,
              ),

              // Top Left Glow Ribbon (Color 2)
              _buildRibbon(
                w: w,
                h: h,
                color: vibrant,
                top: -h * 0.3,
                left: -w * 0.4,
                widthScale: 2.2,
                heightScale: 2.2,
                rotateZ: -0.2,
                scaleX: 1.2,
                scaleY: 0.8,
                stop: 0.2,
                phase: 0,
              ),

              // Bottom Right Wave Ribbon (Color 2) - Offset phase for fluid motion
              _buildRibbon(
                w: w,
                h: h,
                color: vibrant,
                top: h * 0.3,
                left: w * 0.1,
                widthScale: 2.5,
                heightScale: 2.5,
                rotateZ: -0.4,
                scaleX: 1.4,
                scaleY: 0.7,
                stop: 0.15,
                phase: 3.1,
                opacity: 0.85,
              ),

              // The Subtle Shadow Overlay for text legibility
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ATColors.hex0D0D0D.withValues(alpha: 0.2),
                        ATColors.hex0D0D0D.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
              ),

              // The UI content
              child!,
            ],
          ),
        ),
      );
    }

    final Color fallbackColor = widget.state is DominantColorError
        ? (widget.state as DominantColorError).defaultColor
        : ATColors.hex0D0D0D;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      color: fallbackColor,
      child: widget.child,
    );
  }
}
