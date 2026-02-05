import 'package:amptive/src/config/config_export.dart';
import 'package:flutter/material.dart';


//Any scrollable widget that will be a child of this ATScrollBar should set its "primary" to true
class ATScrollBar extends StatefulWidget {
  const ATScrollBar({
    super.key,
    required this.child,
    this.orientation,
    this.xAxisMargin = 0.0,
    this.thickness = 10.0,
    this.mainAxisMargin = 0.0,
    this.extScrollCntrl,
  });

  final Widget child;
  final ScrollbarOrientation? orientation;
  final double thickness;
  final double mainAxisMargin;
  final double xAxisMargin;
  final ScrollController? extScrollCntrl;

  @override
  State<ATScrollBar> createState() => _ATScrollBarState();
}

class _ATScrollBarState extends State<ATScrollBar> {
  late final ScrollController _mainScrollCntrl;
  final ValueNotifier<bool> _paddNotifier = ValueNotifier<bool>(false);
  bool _shouldDisposeCntrl = false;

  @override
  void initState() {
    super.initState();
    _shouldDisposeCntrl = widget.extScrollCntrl == null;
    _mainScrollCntrl = widget.extScrollCntrl ?? ScrollController();
    _mainScrollCntrl.addListener(_updatePadding);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //Manually call here for initial padding update
    WidgetsBinding.instance.addPostFrameCallback((_)  => _updatePadding());
  }

  void _updatePadding() {
    final ScrollPosition position = _mainScrollCntrl.position;
    final bool shouldPadd = position.maxScrollExtent > 0;

    if (_paddNotifier.value != shouldPadd) {
      _paddNotifier.value = shouldPadd;
    }
  }

  @override
  void dispose() {
    if (_shouldDisposeCntrl) {
      _mainScrollCntrl.dispose();
    }
    _paddNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    //This call to screenHeight is necessary for the didChangeDependencies to be called.
    ctx.screenHeight;

    return RawScrollbar(
      scrollbarOrientation: widget.orientation,
      mainAxisMargin: widget.mainAxisMargin,
      crossAxisMargin: widget.xAxisMargin,
      thumbColor: ctx.textTheme.headlineMedium?.color?.withValues(alpha:0.5),
      controller: _mainScrollCntrl, thumbVisibility: true,
      trackBorderColor: ctx.textTheme.headlineMedium?.color,
      thickness: widget.thickness,
      radius: Radius.circular(widget.thickness),
      child: PrimaryScrollController(
        controller: _mainScrollCntrl,
        child: ValueListenableBuilder<bool>(
          valueListenable: _paddNotifier,
          child: widget.child,
          builder: (_, bool shouldPad, Widget? child) {
            return Padding(
              padding: EdgeInsets.only(right: shouldPad ? (widget.thickness + 5) : 0),
              child: child,
            );
          },
        ),
      ),
    );
  }
}
