import 'dart:async';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:flutter/material.dart';

class RotatingCTAText extends StatefulWidget {
  const RotatingCTAText({super.key, required this.isLive});
  final bool isLive;

  @override
  State<RotatingCTAText> createState() => _RotatingCTATextState();
}

class _RotatingCTATextState extends State<RotatingCTAText> {
  int _currentIndex = 0;
  Timer? _timer;

  late final List<String> _liveSentences;
  late final List<String> _scheduledSentences;

  @override
  void initState() {
    super.initState();
    _liveSentences = [
      'Be the First to Join!',
      'Grab your spot now!',
      'Tap to jump in!'
    ];
    _scheduledSentences = [
      'Be the First to RSVP!',
      'Secure your spot now!',
      'Set your reminder!'
    ];

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _liveSentences.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sentences = widget.isLive ? _liveSentences : _scheduledSentences;
    final currentText = sentences[_currentIndex];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: Text(
        currentText,
        key: ValueKey<String>(currentText),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: ATSizes.size14,
              fontWeight: ATFontWeights.w500,
            ),
      ),
    );
  }
}
