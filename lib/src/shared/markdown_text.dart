import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Shared lightweight markdown renderer used by the description editor (where
/// markers are kept but hidden so cursor offsets stay valid) and by the
/// read-only display on show/event/episode pages (where markers are dropped).
///
/// Supports: `# `/`## ` headings, `> ` quotes, `• `/`- `/`* ` bullets,
/// `N. ` numbered lists, `**bold**`, `_italic_`, and `[text](url)` links.
// Calm, low-strain accents: white for links (with an underline), and a soft
// muted white for bullets and the quote bar — no bright colour.
const Color _accent = Colors.white;
final Color _muted = Colors.white.withValues(alpha: 0.5);

final RegExp _inlinePattern = RegExp(
  r'(\*\*(.+?)\*\*)|(_(.+?)_)|(\[(.*?)\]\((.*?)\))',
);

/// Marker chars are made invisible (not removed) in editable mode so the
/// rendered span length still matches the controller text.
TextStyle _hiddenMarker(TextStyle base) =>
    base.copyWith(color: Colors.transparent, fontSize: 0.01, letterSpacing: 0);

/// [linkRecognizerBuilder] lets a caller make links tappable: it receives the
/// URL and returns a recognizer to attach (the caller owns disposal). Only
/// used in display mode.
List<InlineSpan> buildMarkdownSpans({
  required String text,
  required TextStyle base,
  required bool editable,
  GestureRecognizer Function(String url)? linkRecognizerBuilder,
}) {
  final List<InlineSpan> out = <InlineSpan>[];
  final List<String> lines = text.split('\n');
  for (int i = 0; i < lines.length; i++) {
    _addLine(out, lines[i], base, editable, linkRecognizerBuilder);
    if (i < lines.length - 1) {
      out.add(TextSpan(text: '\n', style: base));
    }
  }
  return out;
}

void _marker(List<InlineSpan> out, String s, TextStyle base, bool editable) {
  // Editable: keep the chars but invisible. Display: drop them entirely.
  if (editable) out.add(TextSpan(text: s, style: _hiddenMarker(base)));
}

void _addLine(List<InlineSpan> out, String line, TextStyle base, bool editable,
    GestureRecognizer Function(String url)? linkRecognizerBuilder) {
  if (line.startsWith('# ')) {
    final TextStyle h = base.copyWith(
        fontSize: (base.fontSize ?? 15) + 8,
        fontWeight: FontWeight.w800,
        height: 1.3);
    _marker(out, '# ', base, editable);
    _inline(out, line.substring(2), h, editable, linkRecognizerBuilder);
    return;
  }
  if (line.startsWith('## ')) {
    final TextStyle h = base.copyWith(
        fontSize: (base.fontSize ?? 15) + 4,
        fontWeight: FontWeight.w700,
        height: 1.3);
    _marker(out, '## ', base, editable);
    _inline(out, line.substring(3), h, editable, linkRecognizerBuilder);
    return;
  }
  // Stylish quote: a real accent bar glyph (kept in the text, so it shows in
  // both editor and display) followed by italic, slightly muted content.
  if (line.startsWith('▎ ')) {
    final TextStyle q = base.copyWith(
        fontStyle: FontStyle.italic,
        color: (base.color ?? Colors.white).withValues(alpha: 0.7));
    out.add(TextSpan(
        text: '▎', style: base.copyWith(color: _muted, fontWeight: FontWeight.w700)));
    out.add(TextSpan(text: ' ', style: q));
    _inline(out, line.substring(2), q, editable, linkRecognizerBuilder);
    return;
  }
  // Legacy '> ' quotes (marker hidden in editor, dropped in display).
  if (line.startsWith('> ')) {
    final TextStyle q = base.copyWith(
        fontStyle: FontStyle.italic,
        color: (base.color ?? Colors.white).withValues(alpha: 0.6));
    _marker(out, '> ', base, editable);
    _inline(out, line.substring(2), q, editable, linkRecognizerBuilder);
    return;
  }
  if (line.startsWith('• ') ||
      line.startsWith('- ') ||
      line.startsWith('* ')) {
    // Editable keeps the exact typed marker; display shows a real bullet.
    out.add(TextSpan(
        text: editable ? line.substring(0, 2) : '•  ',
        style: base.copyWith(color: _muted)));
    _inline(out, line.substring(2), base, editable, linkRecognizerBuilder);
    return;
  }
  _inline(out, line, base, editable, linkRecognizerBuilder);
}

void _inline(List<InlineSpan> out, String content, TextStyle style,
    bool editable, GestureRecognizer Function(String url)? linkRecognizerBuilder) {
  int last = 0;
  for (final RegExpMatch m in _inlinePattern.allMatches(content)) {
    if (m.start > last) {
      out.add(TextSpan(text: content.substring(last, m.start), style: style));
    }
    if (m.group(1) != null) {
      _marker(out, '**', style, editable);
      out.add(TextSpan(
          text: m.group(2),
          style: style.copyWith(fontWeight: FontWeight.w800)));
      _marker(out, '**', style, editable);
    } else if (m.group(3) != null) {
      _marker(out, '_', style, editable);
      out.add(TextSpan(
          text: m.group(4),
          style: style.copyWith(fontStyle: FontStyle.italic)));
      _marker(out, '_', style, editable);
    } else {
      _marker(out, '[', style, editable);
      final String url = m.group(7) ?? '';
      out.add(TextSpan(
          text: m.group(6),
          recognizer: (!editable && linkRecognizerBuilder != null)
              ? linkRecognizerBuilder(url)
              : null,
          style: style.copyWith(
            color: _accent,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
            decorationColor: _accent.withValues(alpha: 0.6),
          )));
      _marker(out, '](${m.group(7)})', style, editable);
    }
    last = m.end;
  }
  if (last < content.length) {
    out.add(TextSpan(text: content.substring(last), style: style));
  }
}
