import 'package:flutter/material.dart';

class AmptiveHorizSliderAnimationWidget extends StatefulWidget {

  const AmptiveHorizSliderAnimationWidget({
    super.key,
    required this.child,
    required this.duration
  });
  final Widget child;
  final double duration;

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
      begin: const Offset(0.72, 0),
      end: const Offset(-1.0, 0),
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
      child: Container(
        color: Colors.blue,
        child: widget.child
      ),
    );
  }
}

