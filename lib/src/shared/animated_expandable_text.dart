import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/markdown_text.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimatedExpandableText extends StatefulWidget {
  const AnimatedExpandableText({
    super.key,
    required this.text,
    this.trimLines = 3,
    this.baseStyle,
  });

  final String text;
  final int trimLines;
  final TextStyle? baseStyle;

  @override
  State<AnimatedExpandableText> createState() => _AnimatedExpandableTextState();
}

class _AnimatedExpandableTextState extends State<AnimatedExpandableText> {
  bool _isExpanded = false;
  final List<TapGestureRecognizer> _linkRecognizers = <TapGestureRecognizer>[];

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final TapGestureRecognizer r in _linkRecognizers) {
      r.dispose();
    }
    _linkRecognizers.clear();
  }

  Future<void> _openUrl(String url) async {
    String target = url.trim();
    if (target.isEmpty) return;
    if (!target.contains('://')) target = 'https://$target';
    final Uri? uri = Uri.tryParse(target);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle base = widget.baseStyle ??
        TextStyle(
          color: ATColors.white.withValues(alpha: 0.6),
          fontSize: ATSizes.size14,
          fontWeight: ATFontWeights.w500,
        );

    // Rebuild recognizers each build; dispose the previous batch first.
    _disposeRecognizers();

    // Rendered rich markdown (bold/headings/lists/links), markers stripped.
    final List<InlineSpan> spans = buildMarkdownSpans(
      text: widget.text,
      base: base,
      editable: false,
      linkRecognizerBuilder: (String url) {
        final TapGestureRecognizer r = TapGestureRecognizer()
          ..onTap = () => _openUrl(url);
        _linkRecognizers.add(r);
        return r;
      },
    );
    final TextSpan textSpan = TextSpan(style: base, children: spans);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final TextPainter textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final bool isTextOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: Text.rich(
                textSpan,
                maxLines: _isExpanded ? null : widget.trimLines,
                overflow:
                    _isExpanded ? TextOverflow.visible : TextOverflow.fade,
              ),
            ),
            if (isTextOverflowing)
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, right: 24.0),
                  child: Text(
                    _isExpanded ? ATStrings.showLess : ATStrings.showMore,
                    style: TextStyle(
                      color: ATColors.white,
                      fontSize: ATSizes.size14,
                      fontWeight: ATFontWeights.w600,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
