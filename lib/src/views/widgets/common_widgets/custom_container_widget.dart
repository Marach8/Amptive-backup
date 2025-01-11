import 'package:flutter/material.dart';

class AmptiveCustomContainer extends StatelessWidget {
  final EdgeInsetsGeometry? padding, margin;
  final Color? color;
  final double? height, width, radius;
  final BoxBorder? border;
  final Widget child;
  final BoxShape? boxShape;
  final BoxConstraints? constraints;
  final Gradient? gradient;
  final AlignmentGeometry? alignment;
  final String? decorationImagePath;
  final BoxFit? decorationImageFit;
  final Clip clipBehavior;
  final int? duration;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;

  const AmptiveCustomContainer({
    super.key,
    this.padding,
    this.color,
    this.height,
    this.width,
    this.radius,
    this.border,
    this.margin,
    this.gradient,
    this.boxShape,
    this.constraints,
    this.alignment,
    this.decorationImageFit,
    this.decorationImagePath,
    this.clipBehavior = Clip.none,
    this.duration,
    this.onTap,
    this.boxShadow,
    required this.child
  });

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: duration ?? 500),
        curve: Curves.easeIn,
        alignment: alignment,
        margin: margin,
        clipBehavior: clipBehavior,
        padding: padding,
        height: height,
        width: width,
        constraints: constraints,
        decoration: BoxDecoration(
          image: decorationImagePath != null ? DecorationImage(
            fit: decorationImageFit ?? BoxFit.cover,
            image: AssetImage(decorationImagePath!)
          ) : null,
          gradient: gradient,
          shape: boxShape ?? BoxShape.rectangle,
          color: color,
          border: border,
          borderRadius: boxShape == null ? BorderRadius.circular(radius ?? 0) : null,
          boxShadow: boxShadow
        ),
        child: child,
      ),
    );
  }
}