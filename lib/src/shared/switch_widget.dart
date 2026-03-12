import 'package:amptive/src/config/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ATSwitch extends StatelessWidget {
  const ATSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final void Function(bool p1) onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ATColors.transparent,
      child: Transform.scale(
        scale: 0.6,
        child: CupertinoSwitch(
            value: value,
            thumbColor: ATColors.white,
            trackOutlineColor: WidgetStatePropertyAll<Color>(
                ATColors.white.withValues(alpha: 0.1)),
            activeTrackColor: ATColors.activeSwitch,
            inactiveTrackColor: ATColors.white.withValues(alpha: 0.2),
            onChanged: onChanged),
      ),
    );
  }
}
