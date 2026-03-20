import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';

class HorizontalRefreshIndicator extends StatelessWidget {
  const HorizontalRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.indicatorOverlayWidth = 100,
    this.indicatorOverlayHeight = 100,
    this.indicatorColor,
    this.indicatorSize,
    this.indicatorStrokeWidth,
    this.indicatorOverlayColor,
  });

  final Widget child;
  final RefreshCallback onRefresh;
  final Color? indicatorOverlayColor, indicatorColor;
  final double? indicatorOverlayWidth,
  indicatorOverlayHeight, indicatorSize, indicatorStrokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      trigger: IndicatorTrigger.leadingEdge,
      builder: (_, Widget child, IndicatorController controller) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            child,
            if (controller.value > 0)
              Positioned(
                left: 10,
                child: Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: (indicatorOverlayColor ?? ATColors.black)
                          .withValues(alpha: 0.7),
                        blurRadius: 50,
                        spreadRadius: 5,
                      )
                    ]
                  ),
                  child: ATLoadingIndicator(
                    color: indicatorColor ?? ATColors.white,
                    strokeWidth: indicatorStrokeWidth ?? 2,
                    size: indicatorSize ?? 24,
                  )
                ),
              ),
          ],
        );
      },
      child: child,
    );
  }
}
