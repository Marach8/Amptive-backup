import 'package:native_liquid_glass/native_liquid_glass.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';

import '../../../../config/utils/extensions/context_extensions.dart';

class ATHomeDropDown extends StatefulWidget {
  const ATHomeDropDown({super.key, required this.child, this.offset});
  final Widget child;
  final Offset? offset;

  @override
  State<ATHomeDropDown> createState() => _ATHomeDropDownState();
}

class _ATHomeDropDownState extends State<ATHomeDropDown>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleOverlay,
      child: widget.child,
    );
  }

  void _toggleOverlay() {
    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }

    final RenderBox box = context.findRenderObject()! as RenderBox;
    final Offset origin = box.localToGlobal(Offset.zero);
    final Size screenSize = MediaQuery.sizeOf(context);
    final Offset menuOffset = widget.offset ?? const Offset(0, 50);

    final double left = (origin.dx + menuOffset.dx)
        .clamp(10.0, screenSize.width - GlassFilterDropdown.width - 10);
    final double top = origin.dy + menuOffset.dy;

    _overlayEntry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _removeOverlay,
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (_, Widget? child) {
                  // Map scale 0.0->1.0 to a visually appealing 0.5->1.0 pop range
                  final double visualScale =
                      0.5 + (_scaleAnimation.value * 0.5);
                  return Opacity(
                    opacity: _scaleAnimation.value.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: visualScale,
                      alignment: Alignment.topCenter,
                      child: child,
                    ),
                  );
                },
                child: GlassFilterDropdown(
                  onFollowingTap: () {
                    _removeOverlay();
                    context
                        .pushNamed(ATRoutes.FOLLOWING_EVENTS_OR_SHOWS_SCREEN);
                  },
                  onSubscribersTap: () {
                    _removeOverlay();
                    context
                        .pushNamed(ATRoutes.SUBSCRIBED_EVENTS_OR_SHOWS_SCREEN);
                  },
                  onScheduledTap: () {
                    _removeOverlay();
                    context
                        .pushNamed(ATRoutes.SCHEDULED_EVENTS_OR_SHOWS_SCREEN);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animController.forward(from: 0.0);
  }

  Future<void> _removeOverlay() async {
    if (_overlayEntry == null || _isClosing) return;
    _isClosing = true;
    await _animController.reverse();
    if (mounted) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isClosing = false;
    }
  }
}

class GlassFilterDropdown extends StatelessWidget {
  const GlassFilterDropdown({
    super.key,
    required this.onFollowingTap,
    required this.onSubscribersTap,
    required this.onScheduledTap,
  });

  static const double width = 175;
  static const double height = 154; // Increased to fit 3 items
  static const double borderRadius = 28;
  static const double frost =
      35.0; // Increased significantly for heavy distortion/blur
  static const double depth = 42.46;

  final VoidCallback onFollowingTap;
  final VoidCallback onSubscribersTap;
  final VoidCallback onScheduledTap;

  @override
  Widget build(BuildContext context) {
    final Widget menuContent = Stack(
      children: <Widget>[
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF202024).withValues(alpha: 0.34),
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[
                  Colors.white.withValues(alpha: 0.16),
                  Colors.white.withValues(alpha: 0.07),
                  Colors.black.withValues(alpha: 0.18),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _FrostTexturePainter(),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _GlassStrokePainter(),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _GlassFilterDropdownRow(
                    title: 'Scheduled',
                    iconWidget: const Icon(CupertinoIcons.calendar,
                        size: 20, color: Colors.white),
                    onTap: onScheduledTap,
                  ),
                ),
                Expanded(
                  child: _GlassFilterDropdownRow(
                    title: 'Following',
                    iconWidget: const Icon(
                        CupertinoIcons.person_crop_circle_badge_checkmark,
                        size: 20,
                        color: Colors.white),
                    onTap: onFollowingTap,
                  ),
                ),
                Expanded(
                  child: _GlassFilterDropdownRow(
                    title: 'Subscribers',
                    iconWidget: const Icon(CupertinoIcons.heart,
                        size: 20, color: Colors.white),
                    onTap: onSubscribersTap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: depth,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(-8, -8),
              ),
            ],
          ),
          child: Theme.of(context).platform == TargetPlatform.iOS
              ? LiquidGlassContainer(
                  config: const LiquidGlassConfig(
                    shape: LiquidGlassEffectShape.rect,
                    cornerRadius: borderRadius,
                    effect: LiquidGlassEffect.regular,
                    tint: Colors.black87,
                  ),
                  child: menuContent,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: ColoredBox(
                    color: const Color(
                        0xFF1C1C1E), // Solid opaque dark grey for Android
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: _GlassFilterDropdownRow(
                              title: 'Scheduled',
                              iconWidget: const Icon(CupertinoIcons.calendar,
                                  size: 20, color: Colors.white),
                              onTap: onScheduledTap,
                            ),
                          ),
                          Expanded(
                            child: _GlassFilterDropdownRow(
                              title: 'Following',
                              iconWidget: const Icon(
                                  CupertinoIcons
                                      .person_crop_circle_badge_checkmark,
                                  size: 20,
                                  color: Colors.white),
                              onTap: onFollowingTap,
                            ),
                          ),
                          Expanded(
                            child: _GlassFilterDropdownRow(
                              title: 'Subscribers',
                              iconWidget: const Icon(CupertinoIcons.heart,
                                  size: 20, color: Colors.white),
                              onTap: onSubscribersTap,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _GlassStrokePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final RRect outer = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(GlassFilterDropdown.borderRadius),
    );
    final Paint topLight = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: <Color>[
          Colors.white.withValues(alpha: 0.36),
          Colors.white.withValues(alpha: 0.12),
          Colors.transparent,
        ],
        stops: const <double>[0.0, 0.38, 1.0],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(outer.deflate(0.5), topLight);

    final Paint lowerShade = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: <Color>[
          Colors.black.withValues(alpha: 0.18),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(outer.deflate(1.0), lowerShade);
  }

  @override
  bool shouldRepaint(covariant _GlassStrokePainter oldDelegate) => false;
}

class _GlassFilterDropdownRow extends StatefulWidget {
  const _GlassFilterDropdownRow({
    required this.title,
    required this.iconWidget,
    required this.onTap,
  });

  final String title;
  final Widget iconWidget;
  final VoidCallback onTap;

  @override
  State<_GlassFilterDropdownRow> createState() =>
      _GlassFilterDropdownRowState();
}

class _GlassFilterDropdownRowState extends State<_GlassFilterDropdownRow> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(
            horizontal: 6), // iOS style slight inset for the highlight
        padding: const EdgeInsets.symmetric(
            horizontal: 10), // Internal padding for text/icon
        decoration: BoxDecoration(
          color: _isPressed
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.96),
                      fontSize: 15, // iOS Context Menu standard
                      fontWeight: FontWeight.w400,
                      letterSpacing:
                          -0.24, // iOS San Francisco default tracking
                    ),
              ),
            ),
            const SizedBox(width: 10),
            widget.iconWidget,
          ],
        ),
      ),
    );
  }
}

class _FrostTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.025)
      ..strokeWidth = 0.6;

    for (int i = 0; i < 34; i++) {
      final double x = ((i * 37) % size.width).toDouble();
      final double y = ((i * 19) % size.height).toDouble();
      canvas.drawCircle(Offset(x, y), 0.45, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FrostTexturePainter oldDelegate) => false;
}

class ATStringsDropDown extends StatelessWidget {
  const ATStringsDropDown({
    super.key,
    this.child,
    required this.items,
    required this.onSelected,
    this.width,
    this.selectedItem,
    this.offset,
  });

  final Widget? child;
  final List<String> items;
  final void Function(String) onSelected;
  final double? width;
  final String? selectedItem;
  final Offset? offset;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: offset ?? const Offset(0, 50),
      onSelected: onSelected,
      constraints: width != null ? BoxConstraints.tightFor(width: width) : null,
      color: ATColors.containerGradientColorB,
      elevation: 0,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ATColors.hex2D2D2D, width: 0.5),
      ),
      padding: EdgeInsets.zero,
      child: child,
      itemBuilder: (_) => items
          .map(
            (String item) => PopupMenuItem<String>(
              height: 30,
              value: item,
              child: Text(item, style: context.textTheme.bodySmall),
            ),
          )
          .toList(),
    );
  }
}
