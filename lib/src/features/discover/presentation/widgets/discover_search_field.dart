import 'dart:async';

import 'package:amptive/src/features/discover/presentation/views/discover_landing_screen.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../config/utils/font_weights.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import '../../../../shared/textformfield_widget.dart';

class ATDiscoverSearchField extends StatefulWidget {
  const ATDiscoverSearchField({super.key});

  @override
  State<ATDiscoverSearchField> createState() => _ATDiscoverSearchFieldState();
}

class _ATDiscoverSearchFieldState extends State<ATDiscoverSearchField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  bool _hasFocus = false;
  bool _hasInput = false;
  Timer? _debounceTimer;

  // Armed by a tap on the field. Focus that arrives without it is the
  // framework restoring focus after a covering route (event/show detail
  // modal) pops — we bounce that so the search box doesn't self-activate.
  bool _userInitiatedFocus = false;


  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocus);
    _controller = TextEditingController()..addListener(_handleTextInput);
  }

  void _handleFocus() {
    if (_focusNode.hasFocus) {
      if (!_userInitiatedFocus) {
        _focusNode.unfocus();
        return;
      }
      _userInitiatedFocus = false;
      setState(() => _hasFocus = true);
      if (mounted && _controller.text.trim().isEmpty) {
        context.read<DiscoverTrnstnBlc>().showRecentSearches();
      }
    } else {
      _userInitiatedFocus = false;
      setState(() => _hasFocus = false);
      // Losing focus only hides the keyboard. The current view (recents or
      // results) stays until the user taps Cancel or opens something, so
      // scrolling a list can't kick the user back to the main page.
    }
  }

  void _handleTextInput() {
    if (_controller.text.isNotEmpty) {
      setState(() => _hasInput = true);
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        if (mounted) {
          // Live search: a flat results list appears as the user types.
          // The full tabbed page only opens on keyboard submit.
          context
              .read<DiscoverTrnstnBlc>()
              .updateSearchQuery(_controller.text.trim());
          context.read<DiscoverTrnstnBlc>().showSearchSuggestions();
        }
      });
    } else {
      setState(() => _hasInput = false);
      _debounceTimer?.cancel();
      if (mounted) {
        context.read<DiscoverTrnstnBlc>().showRecentSearches();
      }
    }
  }

  void _cancelSearch() {
    _debounceTimer?.cancel();
    _controller.clear();
    _focusNode.unfocus();
    context.read<DiscoverTrnstnBlc>().reset();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocus);
    _focusNode.dispose();
    _debounceTimer?.cancel();
    _controller.removeListener(_handleTextInput);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    // Cancel stays visible for the whole search session — the keyboard may
    // be dismissed (scrolling unfocuses) while recents/results still show.
    final bool searchUiActive = _hasFocus ||
        context.watch<DiscoverTrnstnBlc>().state.$1 !=
            DiscoverPageState.showMainPage;
    return ATContainer(
      color: ATColors.black,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ClipSmoothRect(
                radius: SmoothBorderRadius(
                  cornerRadius: 14,
                  cornerSmoothing: 0.8,
                ),
                child: ATTextFormField(
                  focusNode: _focusNode,
                  controller: _controller,
                  onTap: () => _userInitiatedFocus = true,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (String value) {
                    final String query = value.trim();
                    if (query.isEmpty) return;
                    _debounceTimer?.cancel();
                    // Submitting opens the full tabbed results page.
                    context.read<DiscoverTrnstnBlc>().updateSearchQuery(query);
                    context.read<DiscoverTrnstnBlc>().showSearchResults();
                  },
                  disableBlueBorder: true,
                  isDense: true,
                  fillColor: ATColors.white.withValues(alpha: 0.2),
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
                  cursorHeight: 20,
                  maxLines: 1,
                  cursorColor: ATColors.white.withValues(alpha: 0.6),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  hintText: ATStrings.SEARCH_FOR_EVENTS_ND_SHOWS,
                  prefixConstraints: const BoxConstraints.tightFor(
                    width: 33,
                    height: 44,
                  ),
                  suffixConstraints: const BoxConstraints.tightFor(
                    width: 44,
                    height: 44,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 1),
                    child: Center(
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          ATColors.white.withValues(alpha: 0.6),
                          BlendMode.srcATop,
                        ),
                        child: const ATImgLoader(
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
                      duration: disableAnimations ? 0 : 200,
                      fadeCurve: Curves.easeOutCubic,
                      sizeCurve: Curves.easeOutCubic,
                      secondChild: const SizedBox.shrink(),
                      firstChild: Semantics(
                        button: true,
                        label: 'Clear search',
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _controller.clear,
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
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ATAnimatedXFade(
              condition: searchUiActive,
              duration: disableAnimations ? 0 : 200,
              fadeCurve: Curves.easeOutCubic,
              sizeCurve: Curves.easeOutCubic,
              secondChild: const SizedBox.shrink(),
              firstChild: Semantics(
                button: true,
                label: 'Cancel search',
                child: InkWell(
                  onTap: _cancelSearch,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                    ),
                    child: Center(
                      child: Text(
                        ATStrings.cancel,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
