import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ATModalDismisser extends StatelessWidget {
  const ATModalDismisser({super.key});

  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: Alignment.center,
      child: ATContainer(
        onTap: () => context.pop(),
        margin: const EdgeInsets.symmetric(vertical: 10),
        radius: 5, height: 4, width: 30,
        color: ATColors.white.withValues(alpha: 0.6),
        child: const SizedBox.shrink(),
      ),
    );
  }
}
