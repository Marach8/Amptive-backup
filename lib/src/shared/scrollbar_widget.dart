import 'package:flutter/material.dart';

class ATScrollBar extends StatelessWidget {
  const ATScrollBar({
    super.key,
    required this.child,
    this.scrollController,
    this.orientation,
    this.thickness = 10.0,
    this.mainAxisMargin = 0.0,
  });
  final Widget child;
  final ScrollController? scrollController;
  final ScrollbarOrientation? orientation;
  final double thickness, mainAxisMargin;

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      scrollbarOrientation: orientation,
      mainAxisMargin: mainAxisMargin,
      thumbColor: Theme.of(context).textTheme.headlineMedium!.color!.withValues(alpha: 0.5),
      controller: scrollController,
      trackBorderColor: Theme.of(context).textTheme.headlineMedium!.color!,
      thumbVisibility: true, thickness: thickness,
      radius: Radius.circular(thickness),
      child: child,
    );
  }
}