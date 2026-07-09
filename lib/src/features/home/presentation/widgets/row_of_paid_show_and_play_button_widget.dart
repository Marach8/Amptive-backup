import 'dart:math' as math;

import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/features/dashboard.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/extensions/context_extensions.dart';

import '../../../../config/utils/dialogs/added_or_removed_from_calender_dialog.dart';
import 'package:amptive/src/config/utils/other_strings.dart';

class PaidShowAndPlayBtnWidget extends StatefulWidget {
  const PaidShowAndPlayBtnWidget({
    super.key,
    this.icon,
    this.homeFeedItem,
  });
  final IconData? icon;
  final HomeFeedItem? homeFeedItem;

  /// Static set to persist RSVP state across the app.
  /// Accessible from detail screens to sync going state.
  static final Set<String> localRsvpIds = <String>{};

  /// Tracks items explicitly removed, overriding the API's requesterIsGoing.
  static final Set<String> removedRsvpIds = <String>{};

  static final ValueNotifier<int> rsvpRevision = ValueNotifier<int>(0);

  static void updateLocalRsvp({
    required String id,
    required bool isAdded,
  }) {
    if (isAdded) {
      localRsvpIds.add(id);
      removedRsvpIds.remove(id);
    } else {
      localRsvpIds.remove(id);
      removedRsvpIds.add(id);
    }
    rsvpRevision.value++;
  }

  @override
  State<PaidShowAndPlayBtnWidget> createState() =>
      _PaidShowAndPlayBtnWidgetState();
}

class _PaidShowAndPlayBtnWidgetState extends State<PaidShowAndPlayBtnWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _confirmationController;

  @override
  void initState() {
    super.initState();
    _confirmationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    // Rebuild when RSVP state changes from anywhere (e.g. detail modal)
    PaidShowAndPlayBtnWidget.rsvpRevision.addListener(_onRsvpRevisionChanged);
  }

  void _onRsvpRevisionChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    PaidShowAndPlayBtnWidget.rsvpRevision.removeListener(_onRsvpRevisionChanged);
    _confirmationController.dispose();
    super.dispose();
  }

  // A scheduled episode that hasn't begun has no start time and no livestream,
  // so it is never live even if the feed mislabels its status as 'live'.
  bool get _hasStarted =>
      (widget.homeFeedItem?.startedAt?.trim().isNotEmpty ?? false) ||
      (widget.homeFeedItem?.livestreamId?.trim().isNotEmpty ?? false);

  bool get _isLive =>
      widget.homeFeedItem?.status?.toLowerCase() == 'live' && _hasStarted;

  bool get _isAdded2Calender {
    if (widget.homeFeedItem == null) return false;
    final String id =
        widget.homeFeedItem!.id ?? widget.homeFeedItem!.hashCode.toString();
    // Explicit removal takes priority over API value
    if (PaidShowAndPlayBtnWidget.removedRsvpIds.contains(id)) return false;
    return PaidShowAndPlayBtnWidget.localRsvpIds.contains(id) ||
        (widget.homeFeedItem!.requesterIsGoing == true);
  }

  bool get _canGoToDetail {
    if (widget.homeFeedItem == null) return false;
    if (_isLive && widget.homeFeedItem?.livestreamId != null) return true;
    return true;
  }

  String get _showTypeLabel {
    final String? type = widget.homeFeedItem?.showType?.toLowerCase();
    if (type == 'paid') return 'PAID SHOW';
    if (type == 'free') return 'FREE SHOW';
    if (type == 'premium') return 'PREMIUM';
    return '';
  }

  void _onPlayTapped(BuildContext context) async {
    if (widget.homeFeedItem == null) return;

    final String contentType = widget.homeFeedItem!.contentType ?? '';
    final bool isStandalone = contentType == 'standalone';

    LiveProgramData? liveProgramData;

    if (_isLive) {
      if (isStandalone) {
        liveProgramData = await context.pushNamed(
          ATRoutes.liveEventDetailed,
          extra: widget.homeFeedItem,
        ) as LiveProgramData?;
      } else {
        liveProgramData = await context.pushNamed(
          ATRoutes.liveShowDetailed,
          extra: widget.homeFeedItem,
        ) as LiveProgramData?;
      }

      if (liveProgramData == null) return;
      dashboardKey.currentState
          ?.showLiveStreamOverlay(liveProgramData: liveProgramData);
    } else {
      await context.pushNamed(
        ATRoutes.scheduleDetailed,
        extra: widget.homeFeedItem,
      );
      // Rebuild to reflect any RSVP changes made in the detail modal
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final String label = _showTypeLabel;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Container(
              padding: const EdgeInsets.all(8.5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ATColors.hex0D0D0D),
              child: Text(label,
                  style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: ATFontWeights.w500,
                      fontSize: ATSizes.size10)),
            ),
          ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            if (_isLive) {
              if (_canGoToDetail) _onPlayTapped(context);
            } else {
              final bool currentlyAdded = _isAdded2Calender;
              final String id = widget.homeFeedItem?.id ??
                  widget.homeFeedItem.hashCode.toString();

              PaidShowAndPlayBtnWidget.updateLocalRsvp(
                id: id,
                isAdded: !currentlyAdded,
              );
              if (!currentlyAdded) {
                _confirmationController.forward(from: 0);
              }

              showAddedOrRemovedSnackbar(
                  context: context,
                  content: currentlyAdded
                      ? ATStrings.REMOVED_4RM_CAL
                      : ATStrings.ADDED_2_CALL);
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: ValueListenableBuilder<int>(
              valueListenable: PaidShowAndPlayBtnWidget.rsvpRevision,
              builder: (
                BuildContext context,
                int revision,
                Widget? child,
              ) {
                return Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _confirmationController,
                        builder: (BuildContext context, Widget? child) {
                          return CustomPaint(
                            size: const Size(45, 45),
                            painter: _CalendarConfirmationBurstPainter(
                              progress: _confirmationController.value,
                            ),
                          );
                        },
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: _buildActionButton(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    if (_isLive) {
      return Container(
        key: const ValueKey('play_btn'),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ATColors.hexB6B6B6,
        ),
        child: Icon(
          widget.icon ?? Icons.play_arrow_rounded,
          color: ATColors.hex0D0D0D,
          size: 30,
        ),
      );
    }

    final bool isAdded = _isAdded2Calender;
    return Container(
      key: ValueKey('rsvp_btn_$isAdded'),
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isAdded ? ATColors.hexFED601 : ATColors.hexB6B6B6.withOpacity(0.15),
        border: isAdded
            ? null
            : Border.all(
                color: ATColors.hexB6B6B6.withOpacity(0.4), width: 1.5),
      ),
      child: Icon(
        isAdded ? Icons.check_rounded : Icons.add_rounded,
        color: isAdded ? ATColors.hex0D0D0D : ATColors.white,
        size: 28,
      ),
    );
  }
}

class _CalendarConfirmationBurstPainter extends CustomPainter {
  const _CalendarConfirmationBurstPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final Offset center = size.center(Offset.zero);
    final double eased = Curves.easeOutCubic.transform(progress);
    final double fade = 1 - progress;
    final Paint ringPaint = Paint()
      ..color = ATColors.hexFED601.withValues(alpha: fade * 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * fade;

    canvas.drawCircle(center, 22 + (13 * eased), ringPaint);

    for (int index = 0; index < 10; index++) {
      final double angle = (math.pi * 2 * index / 10) - (math.pi / 2);
      final double distance = 22 + (17 * eased);
      final Offset particleCenter = center +
          Offset(
            math.cos(angle) * distance,
            math.sin(angle) * distance,
          );
      final Paint particlePaint = Paint()
        ..color = (index.isEven ? ATColors.hexFED601 : ATColors.white)
            .withValues(alpha: fade);
      canvas.drawCircle(
        particleCenter,
        2.4 * math.sqrt(fade),
        particlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CalendarConfirmationBurstPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
