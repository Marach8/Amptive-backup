import 'package:flutter/material.dart';

class ATScrollBar extends StatelessWidget {
  const ATScrollBar({
    super.key,
    required this.child,
    this.scrollController,
  });
  final Widget child;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      thumbColor: Theme.of(context).textTheme.headlineMedium!.color!.withValues(alpha: 0.5),
      controller: scrollController,
      trackBorderColor: Theme.of(context).textTheme.headlineMedium!.color!,
      thumbVisibility: true, thickness: 10,
      radius: const Radius.circular(10),
      child: child,
    );
  }
}