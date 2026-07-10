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

  static const double _pixelsPerSecond = 30;

  @override
  void initState() {
    super.initState();
    _childrenKeys = List<GlobalKey>.generate(
        widget.slidingChildren.length, (_) => GlobalKey());
    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        // Pause at the end of the scroll for 2 seconds
        Future<void>.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _controller.reset();
            // Pause at the beginning for 1.5 seconds before scrolling again
            Future<void>.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) _controller.forward();
            });
          }
        });
      }
    });
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

    final double availableWidth = widget.width * 0.5;

    setState(() {
      _widthOfItems = compoundedWidth;
    });

    if (compoundedWidth > availableWidth) {
      final double overflow = compoundedWidth - availableWidth;
      final double durationSeconds = overflow / _pixelsPerSecond;
      _controller.duration = Duration(milliseconds: (durationSeconds * 1000).round());

      // Start initial delay before first scroll
      Future<void>.delayed(const Duration(seconds: 2), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double availableWidth = widget.width * 0.5;
    final bool overflows = _widthOfItems > availableWidth;

    return SizedBox(
      height: widget.height,
      width: availableWidth,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            final double overflow = _widthOfItems - availableWidth;
            // Only translate if it overflows the available width
            final double offset = overflows ? -(_controller.value * overflow) : 0;
            return Transform.translate(
              offset: Offset(offset, 0),
              child: child,
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: widget.slidingChildren.indexed.map(
              ((int, Widget) entry) => SizedBox(
                key: _childrenKeys[entry.$1],
                child: entry.$2,
              ),
            ).toList(),
          ),
        ),
      ),
    );
  }
}
