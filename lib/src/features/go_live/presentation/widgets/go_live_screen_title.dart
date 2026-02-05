import 'package:flutter/material.dart';

class GoLiveProgramTitle extends StatefulWidget {
  const GoLiveProgramTitle({
    super.key,
    required this.slidingChildren,
    required this.width,
    this.height = 25,
  });

  final List<Widget> slidingChildren;
  final double width, height;

  @override
  State<GoLiveProgramTitle> createState() => _SliderAnimationStat();
}

class _SliderAnimationStat extends State<GoLiveProgramTitle> {
  late final List<GlobalKey> _childrenKeys;
  double _widthOfItems = 0;
  bool shouldAnimate = false;
  Duration _animationDuration = const Duration(seconds: 10);

  static const double _pixelsPerSecond = 50;

  @override
  void initState() {
    super.initState();
    _childrenKeys = List<GlobalKey>.generate(widget.slidingChildren.length, (_) => GlobalKey());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeContent());
  }

  void _initializeContent() {
    double compoundedWidth = 0;
    for (GlobalKey childKey in _childrenKeys) {
      final BuildContext? context = childKey.currentContext;
      if (context == null) return;

      final RenderBox box = context.findRenderObject() as RenderBox;
      compoundedWidth += box.size.width;
    }

    if (!mounted) return;

    final double totalDistance = compoundedWidth + widget.width;
    final double durationSeconds = totalDistance / _pixelsPerSecond;

    setState(() {
      _widthOfItems = compoundedWidth;
      _animationDuration = Duration(milliseconds: (durationSeconds * 1000).round());
    });
  }

  @override
  Widget build(BuildContext context) {
    final double halfWidthOfSpace = widget.width * 0.5;
    return SizedBox(
      height: widget.height,
      width: halfWidthOfSpace,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AnimatedPositioned(
            duration: _animationDuration,
            onEnd: () => setState(() => shouldAnimate = !shouldAnimate),
            right: shouldAnimate ? halfWidthOfSpace : -(_widthOfItems - halfWidthOfSpace),
            child: Row(
              children: widget.slidingChildren.indexed.map(
                ((int, Widget) entry) => SizedBox(
                  key: _childrenKeys[entry.$1],
                  child: entry.$2,
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
