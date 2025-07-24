import 'package:amptive/src/config/utils/colors.dart';
import 'package:flutter/material.dart';

class AmptiveSwitch extends StatelessWidget {
  const AmptiveSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final void Function(bool p1) onChanged;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.6,
      child: Switch.adaptive(
        value: value,
        applyCupertinoTheme: true,
        thumbColor: WidgetStatePropertyAll(ATColors.white),
        activeTrackColor: ATColors.activeSwitch,
        inactiveTrackColor: ATColors.white.withOpacity(0.2),
        onChanged: onChanged
      ),
    );
  }
}
