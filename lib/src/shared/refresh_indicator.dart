import 'package:amptive/src/config/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class ATRefreshIndicator extends StatelessWidget {
  const ATRefreshIndicator({
    super.key,
    required this.child,
    this.onRefresh,
    this.indicatorTopOffset,
  });

  final Widget child;
  final Future<void> Function()? onRefresh;

  /// When set, the spinner appears at this fixed offset from the top
  /// (e.g. just below a pinned search box) and the content is left to
  /// bounce naturally instead of being pushed down from the very top.
  final double? indicatorTopOffset;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      offsetToArmed: 60,
      onRefresh: onRefresh ??
          () async {
            await Future.delayed(const Duration(seconds: 5));
          },
      builder: (BuildContext context, Widget child, IndicatorController controller) {
        final bool isSpinning = controller.isLoading || controller.isFinalizing;
        final Widget spinner = isSpinning
            ? CupertinoActivityIndicator(
                radius: 14,
                color: ATColors.white,
              )
            : CupertinoActivityIndicator.partiallyRevealed(
                progress: controller.value.clamp(0.0, 1.0),
                radius: 14,
                color: ATColors.white,
              );

        if (indicatorTopOffset != null) {
          return Stack(
            children: <Widget>[
              child,
              if (!controller.isIdle)
                Positioned(
                  top: indicatorTopOffset,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: controller.value.clamp(0.0, 1.0),
                    child: Center(child: spinner),
                  ),
                ),
            ],
          );
        }

        return Stack(
          children: <Widget>[
            if (!controller.isIdle)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 60.0 * controller.value,
                child: Center(child: spinner),
              ),
            Transform.translate(
              offset: Offset(0, 60.0 * controller.value),
              child: child,
            ),
          ],
        );
      },
      child: child,
    );
  }
}
