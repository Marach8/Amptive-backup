import 'package:amptive/src/bloc/main_app/nav_bar_bloc.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmptiveBottomAppBarItem extends StatelessWidget {
  const AmptiveBottomAppBarItem({
    super.key,
    required this.selectedImagePath,
    required this.unselectedImagePath,
    required this.itemIdentityIndex,
  });

  final String selectedImagePath, unselectedImagePath;
  final int itemIdentityIndex;


  @override
  Widget build(context) {
    return BlocBuilder<AmptiveNavBarBloc, int>(
      builder: (_, currentNavIndex) {
        final isSelected = itemIdentityIndex == currentNavIndex;
        return GestureDetector(
          onTap: () => context.read<AmptiveNavBarBloc>().goToPage(itemIdentityIndex),
          child: AmptiveAnimatedCrossFadeWidget(
            condition: isSelected,
            firstChild: ATImgLoader(imgPath: selectedImagePath),
            secondChild: ATImgLoader(imgPath: unselectedImagePath)
          ),
        );
      }
    );
  }
}
