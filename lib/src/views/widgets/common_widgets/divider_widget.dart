import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import 'custom_container_widget.dart';

class AmptiveDividerWidget extends StatelessWidget {
  const AmptiveDividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AmptiveCustomContainer(
      color: AmptiveColors.dimWhiteColor1,
      height: 0.1,
      width: double.infinity,
      child: const SizedBox.shrink(),
    );
  }
}
