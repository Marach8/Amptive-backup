import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:flutter/material.dart';

class ReactionTravelItem extends StatefulWidget {
  const ReactionTravelItem({
    super.key,
    required this.reaction,
    required this.animation,
    required this.travelDuration,
    required this.onTravelComplete,
    required this.containerHeight,
  });

  final Reaction reaction;
  final Animation<double> animation;
  final Duration travelDuration;
  final VoidCallback onTravelComplete;
  final double containerHeight;

  @override
  State<ReactionTravelItem> createState() => _ReactionTravelItemState();
}

class _ReactionTravelItemState extends State<ReactionTravelItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _travelController;
  late final Animation<double> _travelAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _travelController = AnimationController(
      vsync: this,
      duration: widget.travelDuration,
    );

    _travelAnimation = Tween<double>(
      begin: 0,
      end: -widget.containerHeight,
    ).animate(CurvedAnimation(
      parent: _travelController,
      curve: Curves.linear,
    ));

    _fadeAnimation = TweenSequence<double>(
      [
        TweenSequenceItem<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0), weight: 10),
        TweenSequenceItem<double>(
            tween: ConstantTween<double>(1.0), weight: 75),
        TweenSequenceItem<double>(
            tween: Tween<double>(begin: 1.0, end: 0.0), weight: 15),
      ],
    ).animate(_travelController);

    _travelController.forward().then((_) {
      if (mounted) widget.onTravelComplete();
    });
  }

  @override
  void dispose() {
    _travelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.animation,
      child: AnimatedBuilder(
        animation: _travelAnimation,
        builder: (_, Widget? child) => Transform.translate(
          offset: Offset(0, _travelAnimation.value),
          child: child,
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 8),
              child: Text(
                widget.reaction.emoji ?? '',
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
