import 'package:flutter/material.dart';

class ATAnimOpacity extends StatefulWidget {

  const ATAnimOpacity({
    super.key,
    required this.child
  });

  final Widget child;

  @override
  State<ATAnimOpacity> createState() => _SizeAnimationState();
}

class _SizeAnimationState extends State<ATAnimOpacity> with 
SingleTickerProviderStateMixin{

  late AnimationController opacityController;
  late Animation<double> opacityAnimation;

  @override 
  void initState(){
    super.initState();
    opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    opacityAnimation = Tween<double> (
      begin: 0,
      end: 2
    ).animate(
      CurvedAnimation(
        parent: opacityController,
        curve: Curves.ease
      )
    );
  }

  @override 
  void dispose(){
    opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(_) => AnimatedBuilder(
    animation: opacityAnimation,
    builder: (_, __) => FadeTransition(
      opacity: opacityAnimation,
      child: widget.child,
    )
  );
}