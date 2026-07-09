import 'dart:ui' show ImageFilter;

import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dominant_color_extractor.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/shared/markdown_text.dart';
import 'package:amptive/src/shared/mesh_gradient_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Future<String?> enterDescriptionModal({
  required BuildContext context,
  String? initialDesc,
  String title = 'Description',
  String hintText = 'Start typing...',
  String? coverImage,
  Uint8List? coverBytes,
}) async {
  return await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    // The modal paints its own mesh background (below), so it needs no sheet
    // tint or dim behind it.
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    constraints: BoxConstraints.expand(height: context.screenHeight),
    elevation: 0,
    builder: (_) => _DescriptionWidget(
      intialDesc: initialDesc,
      title: title,
      hintText: hintText,
      coverImage: coverImage,
      coverBytes: coverBytes,
    ),
  );
}

class _DescriptionWidget extends StatefulWidget {
  const _DescriptionWidget({
    this.intialDesc,
    required this.title,
    required this.hintText,
    this.coverImage,
    this.coverBytes,
  });
  final String? intialDesc;
  final String title;
  final String hintText;
  final String? coverImage;
  final Uint8List? coverBytes;

  @override
  State<_DescriptionWidget> createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<_DescriptionWidget> {
  late final TextEditingController _textCntrl;
  final FocusNode _focusNode = FocusNode();
  final DominantColorCubit _colorCubit = DominantColorCubit();

  @override
  void initState() {
    super.initState();
    _textCntrl = _MarkdownEditingController(text: widget.intialDesc);
    // Tint the mesh from the same cover the form uses. The palette is cached,
    // so this is instant when the cover was already seen.
    if (widget.coverBytes != null) {
      _colorCubit.extractColorFromBytes(widget.coverBytes!);
    } else if (widget.coverImage != null) {
      _colorCubit.extractColor(widget.coverImage!);
    }
    // Open ready to write, like a notes app.
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _colorCubit.close();
    _focusNode.dispose();
    _textCntrl.dispose();
    super.dispose();
  }

  /// Inserts [prefix] at the start of the line the cursor is on
  /// (H1/H2/lists/quote behave this way in every markdown editor).
  void _insertLinePrefix(String prefix) {
    final TextSelection selection = _textCntrl.selection;
    final String text = _textCntrl.text;
    final int cursor = selection.isValid ? selection.start : text.length;
    final int lineStart = text.lastIndexOf('\n', cursor - 1 < 0 ? 0 : cursor - 1) + 1;

    _textCntrl.value = TextEditingValue(
      text: text.replaceRange(lineStart, lineStart, prefix),
      selection: TextSelection.collapsed(offset: cursor + prefix.length),
    );
    _focusNode.requestFocus();
  }

  /// Wraps the current selection with [marker] (bold/italic), or inserts an
  /// empty pair and parks the cursor in the middle.
  void _wrapSelection(String marker) {
    final TextSelection selection = _textCntrl.selection;
    final String text = _textCntrl.text;
    final int start = selection.isValid ? selection.start : text.length;
    final int end = selection.isValid ? selection.end : text.length;
    final String selected = text.substring(start, end);

    _textCntrl.value = TextEditingValue(
      text: text.replaceRange(start, end, '$marker$selected$marker'),
      selection: TextSelection.collapsed(
          offset: selected.isEmpty
              ? start + marker.length
              : end + marker.length * 2),
    );
    _focusNode.requestFocus();
  }

  Future<void> _insertLink() async {
    final (String, String)? linkData = await addLinkModal(context: context);
    if (linkData == null || !mounted) return;
    final TextSelection selection = _textCntrl.selection;
    final String text = _textCntrl.text;
    final int cursor = selection.isValid ? selection.start : text.length;
    final String snippet = '[${linkData.$1}](${linkData.$2})';

    _textCntrl.value = TextEditingValue(
      text: text.replaceRange(cursor, cursor, snippet),
      selection: TextSelection.collapsed(offset: cursor + snippet.length),
    );
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    // Read the status-bar inset straight from the device: bottom sheets
    // strip the MediaQuery paddings, but this sheet is full-screen.
    final view = View.of(context);
    final double topPadding = view.viewPadding.top / view.devicePixelRatio;

    // The modal paints its own continuous mesh — same treatment and cover
    // tint as the form — so the surface is one seamless colorful sheet with
    // no header/body boundary showing through from the page behind.
    return BlocBuilder<DominantColorCubit, DominantColorState>(
      bloc: _colorCubit,
      builder: (_, DominantColorState colorState) {
        return ATMeshGradientBackground(
          state: colorState,
          child: Stack(
            children: <Widget>[
              // Text fills the whole sheet and scrolls *under* the frosted
              // header bar, so lines dissolve behind it instead of
              // Text fills the whole sheet and scrolls *under* the frosted
              // header bar, so lines dissolve behind it instead of hard-clipping.
              Positioned.fill(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    final double trayBottom = (bottomInset > 0 ? bottomInset : 24) + 12;
                    final double trayTop = trayBottom + 56;
                    
                    // Start fading out near the top of the tray and end exactly at the bottom of the tray.
                    // This way it's visible behind the frosted glass but completely vanishes below it.
                    final double fadeStart = bounds.height - (trayTop - 10);
                    final double fadeEnd = bounds.height - trayBottom;
                    
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: const <Color>[Colors.white, Colors.white, Colors.transparent],
                      stops: <double>[
                        0.0,
                        (fadeStart / bounds.height).clamp(0.0, 1.0),
                        (fadeEnd / bounds.height).clamp(0.0, 1.0),
                      ],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: SingleChildScrollView(
                    child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _focusNode.requestFocus(),
                    child: Container(
                      constraints: BoxConstraints(minHeight: context.screenHeight),
                      padding: EdgeInsets.fromLTRB(
                          16, topPadding + 84 + 24, 16, bottomInset + 96),
                      child: TextField(
                        maxLines: null,
                        controller: _textCntrl,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.multiline,
                        maxLength: 4000,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        // Hide the built-in "0/4000" counter under the field.
                        buildCounter: (BuildContext context,
                                {required int currentLength,
                                required bool isFocused,
                                int? maxLength}) =>
                            null,
                        inputFormatters: <TextInputFormatter>[
                          _ListContinuationFormatter(),
                        ],
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: ATColors.white,
                        style: context.textTheme.bodySmall?.copyWith(
                          fontSize: 17,
                          height: 1.45,
                          // Regular weight reads better for long-form body text
                          // than the theme's medium (500) default for UI labels.
                          fontWeight: FontWeight.w400,
                          color: ATColors.white.withValues(alpha: 0.9),
                          overflow: TextOverflow.visible,
                        ),
                        decoration: InputDecoration(
                          filled: false,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: widget.hintText,
                          hintStyle: context.textTheme.bodySmall?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: ATColors.white.withValues(alpha: 0.35),
                          ),
                          // Content padding is zero because the outer Container handles the scrolling padding.
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ),
                ), // Close ShaderMask
              ),
              // Frosted header bar: content scrolls behind it and blurs away.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, topPadding + 12, 16, 24),
                      color: ATColors.black.withValues(alpha: 0.12),
                      child: Row(
                        children: <Widget>[
                          _CircleButton(
                            icon: CupertinoIcons.chevron_back,
                            semanticLabel: 'Cancel',
                            onTap: () => context.pop(),
                          ),
                          Expanded(
                            child: Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyMedium,
                            ),
                          ),
                          _CircleButton(
                            icon: Icons.check,
                            semanticLabel: 'Save description',
                            onTap: () => context.pop(_textCntrl.text.trim()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            left: 16,
            right: 16,
            bottom: (bottomInset > 0 ? bottomInset : 24) + 12,
            child: Row(
              children: <Widget>[
                Expanded(
                  // Frosted pill: text scrolling behind it blurs away instead
                  // of reading through the translucent bar.
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: ATColors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: ATColors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _ToolbarAction(
                          label: 'Heading 1',
                          child: const _HeadingGlyph(level: '1'),
                          onTap: () => _insertLinePrefix('# '),
                        ),
                        _ToolbarAction(
                          label: 'Heading 2',
                          child: const _HeadingGlyph(level: '2'),
                          onTap: () => _insertLinePrefix('## '),
                        ),
                        _ToolbarAction(
                          label: 'Bold',
                          child: const Icon(Icons.format_bold, size: 24),
                          onTap: () => _wrapSelection('**'),
                        ),
                        _ToolbarAction(
                          label: 'Italic',
                          child: const Icon(Icons.format_italic, size: 24),
                          onTap: () => _wrapSelection('_'),
                        ),
                        _ToolbarAction(
                          label: 'Add link',
                          onTap: _insertLink,
                          child: const Icon(CupertinoIcons.link, size: 21),
                        ),
                        _ToolbarAction(
                          label: 'Bulleted list',
                          child:
                              const Icon(Icons.format_list_bulleted, size: 22),
                          onTap: () => _insertLinePrefix('• '),
                        ),
                        _ToolbarAction(
                          label: 'Numbered list',
                          child:
                              const Icon(Icons.format_list_numbered, size: 22),
                          onTap: () => _insertLinePrefix('1. '),
                        ),
                        _ToolbarAction(
                          label: 'Quote',
                          child: const Icon(Icons.format_quote_rounded, size: 24),
                          onTap: () => _insertLinePrefix('▎ '),
                        ),
                      ],
                    ),
                      ),
                    ),
                  ),
                ),
                // Only meaningful while the keyboard is up — hide it once the
                // keyboard is dismissed.
                if (bottomInset > 0) ...<Widget>[
                  const SizedBox(width: 10),
                  _CircleButton(
                    icon: Icons.keyboard_hide_outlined,
                    semanticLabel: 'Hide keyboard',
                    size: 56,
                    onTap: () => FocusScope.of(context).unfocus(),
                  ),
                ],
              ],
            ),
          ),
            ],
          ),
        );
      },
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
    this.size = 48,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ATColors.black.withValues(alpha: 0.35),
            border: Border.all(
              color: ATColors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Icon(icon, size: size * 0.42, color: ATColors.white),
        ),
      ),
    );
  }
}

class _ToolbarAction extends StatelessWidget {
  const _ToolbarAction({
    required this.child,
    required this.onTap,
    required this.label,
  });

  final Widget child;
  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    // Flex so the 8 actions always share the pill width evenly and never
    // overflow on narrower screens.
    return Expanded(
      child: Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: 56,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

/// "H1"/"H2" drawn as text — Material has no heading icons that match the
/// reference design.
class _HeadingGlyph extends StatelessWidget {
  const _HeadingGlyph({required this.level});
  final String level;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'H',
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        children: <InlineSpan>[
          TextSpan(
            text: level,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// Continues bullet/numbered lists on Enter, like the iPhone Notes app:
/// pressing Return inside a list item starts the next item automatically,
/// and pressing Return on an empty item ends the list.
class _ListContinuationFormatter extends TextInputFormatter {
  static final RegExp _numbered = RegExp(r'^(\d+)\. ');
  static const List<String> _bullets = <String>['• ', '- ', '* '];

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Only react to a single freshly-typed newline (not paste/delete).
    final int off = newValue.selection.baseOffset;
    final bool isSingleNewlineInsert =
        newValue.text.length == oldValue.text.length + 1 &&
            newValue.selection.isCollapsed &&
            off >= 1 &&
            off <= newValue.text.length &&
            newValue.text[off - 1] == '\n';
    if (!isSingleNewlineInsert) return newValue;

    final String text = newValue.text;
    final int lineStart = text.lastIndexOf('\n', off - 2) + 1;
    final String prevLine = text.substring(lineStart, off - 1);

    // Bullet items.
    for (final String bullet in _bullets) {
      if (prevLine.startsWith(bullet)) {
        final String content = prevLine.substring(bullet.length);
        if (content.trim().isEmpty) {
          return _endList(text, lineStart, off);
        }
        return _insertMarker(text, off, bullet);
      }
    }

    // Numbered items.
    final RegExpMatch? m = _numbered.firstMatch(prevLine);
    if (m != null) {
      final String content = prevLine.substring(m.end);
      if (content.trim().isEmpty) {
        return _endList(text, lineStart, off);
      }
      final int next = (int.tryParse(m.group(1) ?? '1') ?? 1) + 1;
      return _insertMarker(text, off, '$next. ');
    }

    return newValue;
  }

  TextEditingValue _insertMarker(String text, int off, String marker) {
    final String updated = text.substring(0, off) + marker + text.substring(off);
    return TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: off + marker.length),
    );
  }

  /// Removes the empty marker and the trailing newline, dropping the caret
  /// back onto a plain line.
  TextEditingValue _endList(String text, int lineStart, int off) {
    final String updated = text.substring(0, lineStart) + text.substring(off);
    return TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: lineStart),
    );
  }
}

/// Renders markdown formatting live while keeping the raw markdown as the
/// stored text. Markers are kept (so cursor offsets stay valid) but made
/// invisible, so the writer sees clean formatting — not `#`, `*`, `>`.
class _MarkdownEditingController extends TextEditingController {
  _MarkdownEditingController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final TextStyle base = style ?? const TextStyle();
    return TextSpan(
      style: base,
      children: buildMarkdownSpans(text: text, base: base, editable: true),
    );
  }
}
