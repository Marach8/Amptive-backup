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

class _SliderAnimationStat extends State<GoLiveProgramTitle> with SingleTickerProviderStateMixin {
  late final List<GlobalKey> _childrenKeys;
  late final AnimationController _controller;
  double _widthOfItems = 0;

  static const double _pixelsPerSecond = 18; // Reduced from 30 for a slower, more readable scroll
  static const double _spacing = 15; // Reduced from 40 to close the gap between loops

  @override
  void initState() {
    super.initState();
    _childrenKeys = List<GlobalKey>.generate(
        widget.slidingChildren.length, (_) => GlobalKey());
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      if (context == null) continue;

      final RenderBox box = context.findRenderObject() as RenderBox;
      compoundedWidth += box.size.width;
    }

    if (!mounted) return;

    final double availableWidth = widget.width;

    setState(() {
      _widthOfItems = compoundedWidth;
    });

    if (compoundedWidth > availableWidth) {
      final double totalScrollDistance = compoundedWidth + _spacing;
      final double durationSeconds = totalScrollDistance / _pixelsPerSecond;
      _controller.duration = Duration(milliseconds: (durationSeconds * 1000).round());

      // Start the infinite loop!
      _controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double availableWidth = widget.width;
    final bool overflows = _widthOfItems > availableWidth;

    final double startPadding = 12.0; // Keeps paused text outside the 4% left fade zone

    List<Widget> buildCopy(bool useKeys) {
      return <Widget>[
        SizedBox(width: startPadding),
        ...widget.slidingChildren.indexed.map(
          ((int, Widget) entry) => SizedBox(
            key: useKeys ? _childrenKeys[entry.$1] : null,
            child: entry.$2,
          ),
        ),
      ];
    }

    Widget marqueeContent = ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          final double totalScrollDistance = _widthOfItems + startPadding + _spacing;
          // Translate all the way left until the second copy is exactly where the first one started
          final double offset = overflows ? -(_controller.value * totalScrollDistance) : 0;
          return Transform.translate(
            offset: Offset(offset, 0),
            child: child,
          );
        },
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ...buildCopy(true),
              if (overflows) ...<Widget>[
                const SizedBox(width: _spacing),
                ...buildCopy(false), // Second identical copy to create seamless loop
              ],
            ],
          ),
        ),
      ),
    );

    if (overflows) {
      marqueeContent = ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              Colors.transparent,
              Colors.white,
              Colors.white,
              Colors.transparent,
            ],
            stops: <double>[0.0, 0.04, 0.96, 1.0], // 4% fade on both edges
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: marqueeContent,
      );
    }

    return SizedBox(
      height: widget.height,
      width: availableWidth,
      child: marqueeContent,
    );
  }
}
