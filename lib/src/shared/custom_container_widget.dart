import 'dart:typed_data' show Uint8List;

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
    this.decorImageFit,
    this.decorImage,
    this.clipBehavior = Clip.none,
    this.duration,
    this.onTap,
    this.boxShadow,
    this.onEnd,
    this.child,
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
  final dynamic decorImage;
  final BoxFit? decorImageFit;
  final Clip clipBehavior;
  final int? duration;
  final VoidCallback? onTap;
  final Curve curve;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onEnd;

  @override
  Widget build(BuildContext context) {
    final bool isMemoryImage = decorImage != null && decorImage is Uint8List;
    final bool isAssetImage = decorImage != null && decorImage is String;

    return Material(
      color: ATColors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor ?? ATColors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(radius ?? 10),
        child: AnimatedContainer(
          duration: Duration(milliseconds: duration ?? 500),
          curve: curve,
          alignment: alignment,
          margin: margin,
          onEnd: onEnd,
          clipBehavior: clipBehavior,
          padding: padding,
          height: height,
          width: width,
          constraints: constraints,
          decoration: BoxDecoration(
              image: isAssetImage
                  ? DecorationImage(
                      fit: decorImageFit ?? BoxFit.cover,
                      image: AssetImage(decorImage))
                  : isMemoryImage
                      ? DecorationImage(
                          fit: decorImageFit ?? BoxFit.cover,
                          image: MemoryImage(decorImage))
                      : null,
              gradient: gradient,
              shape: boxShape ?? BoxShape.rectangle,
              color: color,
              border: border,
              borderRadius:
                  boxShape == null ? BorderRadius.circular(radius ?? 0) : null,
              boxShadow: boxShadow),
          child: child,
        ),
      ),
    );
  }
}
