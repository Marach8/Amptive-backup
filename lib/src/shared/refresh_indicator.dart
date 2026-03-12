import 'package:amptive/src/config/utils/colors.dart';
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
