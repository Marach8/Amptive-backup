import 'package:amptive/src/utils/constants/colors.dart';
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
  Widget build(context) {
    return Transform.scale(
      scale: 0.6,
      child: Switch.adaptive(
        value: value,
        applyCupertinoTheme: true,
        thumbColor: WidgetStatePropertyAll(AmptiveColors.whiteColor),
        activeTrackColor: AmptiveColors.activeSwitch,
        inactiveTrackColor: AmptiveColors.whiteColor.withOpacity(0.2),
        onChanged: onChanged
      ),
    );
  }
}
