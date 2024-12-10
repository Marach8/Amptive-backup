import 'package:flutter/material.dart';

class AmptiveHorizSliderAnimationWidget extends StatefulWidget {
  final Widget child;
  final double duration;

  const AmptiveHorizSliderAnimationWidget({
    super.key,
    required this.child,
    required this.duration
  });

  @override
  State<AmptiveHorizSliderAnimationWidget> createState() => _SliderAnimationState();
}

class _SliderAnimationState extends State<AmptiveHorizSliderAnimationWidget>
with SingleTickerProviderStateMixin {
  late AnimationController sliderController;
  late Animation<Offset> sliderAnimation;

  @override
  void initState() {
    super.initState();
    sliderController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration.toInt()),
    )..repeat();

    sliderAnimation = Tween<Offset>(
      begin: const Offset(2 , 0),
      end: const Offset(-1.5, 0),
    ).animate(CurvedAnimation(
      parent: sliderController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    sliderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: sliderAnimation,
      child: widget.child,
    );
  }
}
