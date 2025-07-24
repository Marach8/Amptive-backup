
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';

class ButtonWithBgBlur extends StatelessWidget {
  const ButtonWithBgBlur({
    super.key,
    required this.onPressed,
    this.btnTitle,
    this.child,
    this.bgColor,
    this.fgColor,
  });

  final VoidCallback? onPressed;
  final String? btnTitle;
  final Widget? child;
  final Color? bgColor, fgColor;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      height: 70,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          ATColors.hex0D0D0D.withValues(alpha: 0.1),
          ATColors.hex0D0D0D
        ]
      ),
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: ATPlainElevatedBtn(
        bgColor: bgColor ?? ATColors.white,
        fgColor: fgColor ?? ATColors.hex0D0D0D,
        btnTitle: btnTitle,
        onPressed: onPressed,
      ),
    );
  }
}