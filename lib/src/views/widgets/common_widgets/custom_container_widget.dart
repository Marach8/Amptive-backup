import 'package:amptive/src/config/utils/colors.dart';
import 'package:flutter/material.dart';

class ATContainer extends StatelessWidget {

  const ATContainer({
    super.key,
    this.padding,
    this.color,
    this.height,
    this.width,
    this.splashColor,
    this.radius,
    this.border,
    this.margin,
    this.gradient,
    this.curve = Curves.easeIn,
    this.boxShape,
    this.constraints,
    this.alignment,
    this.decorationImageFit,
    this.decorationImagePath,
    this.clipBehavior = Clip.none,
    this.duration,
    this.onTap,
    this.boxShadow,
    this.child
  });
  final EdgeInsetsGeometry? padding, margin;
  final Color? color, splashColor;
  final double? height, width, radius;
  final BoxBorder? border;
  final Widget? child;
  final BoxShape? boxShape;
  final BoxConstraints? constraints;
  final Gradient? gradient;
  final AlignmentGeometry? alignment;
  final String? decorationImagePath;
  final BoxFit? decorationImageFit;
  final Clip clipBehavior;
  final int? duration;
  final VoidCallback? onTap;
  final Curve curve;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ATColors.trsprnt,
      child: InkWell(
        onTap: onTap, splashColor: splashColor ?? ATColors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(radius ?? 10),
        child: AnimatedContainer(
          duration: Duration(milliseconds: duration ?? 500),
          curve: curve,
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
      ),
    );
  }
}