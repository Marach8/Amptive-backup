import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../config/utils/font_weights.dart';
import '../../../../views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import '../../../../shared/textformfield_widget.dart';

class SearchFieldWithXSuffix extends StatefulWidget {
  const SearchFieldWithXSuffix({
    super.key,
    required this.onChanged,
    required this.hintText,
    this.onClear,
    this.fillColor,
  });

  final void Function(String) onChanged;
  final VoidCallback? onClear;
  final String hintText;
  final Color? fillColor;

  @override
  State<SearchFieldWithXSuffix> createState() => _SearchFieldWithXSuffixState();
}

class _SearchFieldWithXSuffixState extends State<SearchFieldWithXSuffix> {
  late TextEditingController _controller;
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_handleTextInput);
  }

  void _handleTextInput() {
    if (_controller.text.isNotEmpty && !_hasInput) {
      setState(() => _hasInput = true);
    } else if (_controller.text.isEmpty && _hasInput) {
      setState(() => _hasInput = false);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextInput);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Styled to match the discover-page search box (minus the Cancel button).
    return ClipSmoothRect(
      radius: SmoothBorderRadius(cornerRadius: 14, cornerSmoothing: 0.8),
      child: ATTextFormField(
        controller: _controller,
        disableBlueBorder: true,
        isDense: true,
        onChanged: widget.onChanged,
        cursorHeight: 20,
        maxLines: 1,
        cursorColor: ATColors.white.withValues(alpha: 0.6),
        fillColor: widget.fillColor ?? ATColors.white.withValues(alpha: 0.2),
        style: TextStyle(
          color: ATColors.white,
          fontSize: ATSizes.size16,
          fontWeight: ATFontWeights.w400,
        ),
        hintStyle: TextStyle(
          color: const Color(0xFFC2C2C2),
          fontSize: ATSizes.size16,
          fontWeight: ATFontWeights.w400,
          letterSpacing: 0,
        ),
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        prefixConstraints: const BoxConstraints.tightFor(width: 33, height: 44),
        suffixConstraints: const BoxConstraints.tightFor(width: 44, height: 44),
        // Solid white (#FFFFFF) magnifier.
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 12, right: 1),
          child: Center(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              child: ATImgLoader(
                height: 20,
                width: 20,
                imgPath: ATImgStrings.outlinedSearch,
              ),
            ),
          ),
        ),
        suffixIcon: Center(
          child: ATAnimatedXFade(
            condition: _hasInput,
            secondChild: const SizedBox.shrink(),
            firstChild: Semantics(
              button: true,
              label: 'Clear search',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _controller.clear();
                  widget.onClear?.call();
                },
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Center(
                    child: SvgPicture.asset(
                      ATImgStrings.searchClearXIcon,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
