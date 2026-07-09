import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';

class ATModalDismisser extends StatelessWidget {
  const ATModalDismisser({super.key, this.onDismissOverride});
  final VoidCallback? onDismissOverride;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ATContainer(
        onTap: onDismissOverride ?? () => Navigator.pop(context),
        margin: const EdgeInsets.symmetric(vertical: 8),
        radius: 100, // Fully rounded pill shape
        height: 5,
        width: 38,
        color: ATColors.white.withValues(alpha: 0.45), // Softer, premium opacity
        child: const SizedBox.shrink(),
      ),
    );
  }
}
