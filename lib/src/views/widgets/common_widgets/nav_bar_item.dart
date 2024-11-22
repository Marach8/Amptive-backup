import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';

class AmptiveBottomAppBarItem extends StatelessWidget {
  const AmptiveBottomAppBarItem({
    super.key,
    required this.selected,
    required this.unselected,
    required this.itemIdentityIndex,
    required this.pageIndexNotifier,
  });

  final String selected, unselected;
  final int itemIdentityIndex;
  final ValueNotifier<int> pageIndexNotifier;


  @override
  Widget build(context) {
    return AmptiveRebuilderWidget(
      notifier: pageIndexNotifier,
      builder: (_, value, __) {
        final isSelected = itemIdentityIndex == value;
        return GestureDetector(
          onTap: () => pageIndexNotifier.value = itemIdentityIndex,
          child: AmptiveAnimatedCrossFadeWidget(
            condition: isSelected,
            firstChild: AmptiveImageLoaderWidget(imagePath: selected),
            secondChild: AmptiveImageLoaderWidget(imagePath: unselected)
          ),
        );
      }
    );
  }
}
