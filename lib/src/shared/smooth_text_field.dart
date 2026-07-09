import 'dart:async';

import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

/// The standard single-line input for the create/edit form screens:
/// squircle-smoothed corners, a hard stop at [maxLength] (no overflow, no
/// error styling), every word capitalized as the user types, a fill that
/// gently brightens on focus, and — when [hintSuggestions] are provided —
/// an empty-state hint that cycles through example titles to spark ideas.
class ATSmoothTextField extends StatefulWidget {
  const ATSmoothTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.hintSuggestions,
    this.maxLength = 140,
  });

  final TextEditingController controller;
  final String hintText;
  final List<String>? hintSuggestions;
  final int maxLength;

  @override
  State<ATSmoothTextField> createState() => _ATSmoothTextFieldState();
}

class _ATSmoothTextFieldState extends State<ATSmoothTextField> {
  final FocusNode _focusNode = FocusNode();
  Timer? _hintTimer;
  int _hintIndex = 0;

  bool get _cyclesHints => (widget.hintSuggestions?.length ?? 0) > 1;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onChanged);
    widget.controller.addListener(_onChanged);
    if (_cyclesHints) {
      _hintTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (!mounted || widget.controller.text.isNotEmpty) return;
        setState(() {
          _hintIndex = (_hintIndex + 1) % widget.hintSuggestions!.length;
        });
      });
    }
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _focusNode.removeListener(_onChanged);
    widget.controller.removeListener(_onChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final bool focused = _focusNode.hasFocus;
    // Mirrors the field's own input style (ATTextFormField's default) so the
    // hint sits exactly where typed text will appear — same size, same spot.
    final TextStyle hintStyle = TextStyle(
      fontWeight: ATFontWeights.w400,
      fontSize: ATSizes.size16,
      color: ATColors.white.withValues(alpha: 0.4),
    );

    return ClipSmoothRect(
      radius: SmoothBorderRadius(cornerRadius: 14, cornerSmoothing: 0.8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        color: ATColors.white.withValues(alpha: focused ? 0.16 : 0.1),
        child: ATTextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          maxLines: 1,
          cursorHeight: 20,
          maxLength: widget.maxLength,
          textCapitalization: TextCapitalization.words,
          disableBlueBorder: true,
          decoration: InputDecoration(
            // A widget hint renders at the exact spot typed text starts —
            // pixel-aligned with the cursor — while still allowing the
            // rotating conveyor animation a plain hintText can't do.
            hint: _cyclesHints
                ? _ConveyorHint(
                    text: widget.hintSuggestions![_hintIndex],
                    style: hintStyle,
                  )
                : null,
            hintText: _cyclesHints ? null : widget.hintText,
            // Hides the framework's built-in "0/140" under-field counter;
            // the form shows its own count next to the label instead.
            counterText: '',
            filled: false,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintStyle: hintStyle,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: ATColors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: ATColors.transparent),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ticker-style hint swap: whenever [text] changes, the old hint lifts up
/// and fades away while the new one rises into place from below — both
/// driven by the same clock so the motion reads as one continuous conveyor.
class _ConveyorHint extends StatefulWidget {
  const _ConveyorHint({required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  State<_ConveyorHint> createState() => _ConveyorHintState();
}

class _ConveyorHintState extends State<_ConveyorHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
    value: 1,
  );

  String? _outgoingText;

  @override
  void didUpdateWidget(covariant _ConveyorHint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _outgoingText = oldWidget.text;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    Widget hintText(String text) => Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: widget.style,
        );

    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        if (_outgoingText != null)
          FadeTransition(
            opacity: ReverseAnimation(curved),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(0, -0.8),
              ).animate(curved),
              child: hintText(_outgoingText!),
            ),
          ),
        FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.8),
              end: Offset.zero,
            ).animate(curved),
            child: hintText(widget.text),
          ),
        ),
      ],
    );
  }
}
