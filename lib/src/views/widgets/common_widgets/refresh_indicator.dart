import 'package:amptive/src/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AmptiveRefreshIndicatorWidget extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;
  const AmptiveRefreshIndicatorWidget({
    super.key,
    required this.child,
    this.onRefresh
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: ATColors.white,
      onRefresh: onRefresh ?? ()async{
        await Future.delayed(const Duration(seconds: 5));
      },
      child: child,
    );
  }
}