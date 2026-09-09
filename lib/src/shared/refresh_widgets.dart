import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';

class ATRefreshIndicator extends StatelessWidget {
  const ATRefreshIndicator({super.key, required this.child, this.onRefresh});
  final Widget child;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: ATColors.white,
      onRefresh: onRefresh ??
          () async {
            await Future.delayed(const Duration(seconds: 5));
          },
      child: child,
    );
  }
}


class RetryWidget extends StatelessWidget {
  const RetryWidget({
    super.key,
    required this.onRetry,
    this.height = 30, 
    this.width = 30,
  });

  final VoidCallback onRetry;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRetry,
      child: ATImgLoader(
        imgPath: ATImgStrings.retryImage,
        height: height, width: width,
      ),
    );
  }
}
