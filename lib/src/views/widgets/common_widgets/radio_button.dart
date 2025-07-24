import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';

class ATRadioBtn extends StatelessWidget {
  const ATRadioBtn({
    super.key,
    required this.isSelected,
    this.duration
  });

  final bool isSelected;
  final int? duration;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      duration: duration,
      height: 15, width: 15, boxShape: BoxShape.circle,
      padding: const EdgeInsets.all(5),
      color: isSelected ? ATColors.hex307FE2 : ATColors.trsprnt,
      border: Border.all(
        color: isSelected ? ATColors.hex307FE2 : ATColors.white,
        strokeAlign: 5.0
      ),
      child: const SizedBox.shrink()
    );
  }
}