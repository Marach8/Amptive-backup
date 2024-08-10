import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:flutter/material.dart';

class AmptiveBottomAppBarItem extends StatelessWidget {
  const AmptiveBottomAppBarItem({
    super.key,
    required this.icon,
    required this.itemIdentityIndex,
    required this.pageIndexNotifier,
    required this.pageController
  });

  final IconData icon;
  final int itemIdentityIndex;
  final ValueNotifier<int> pageIndexNotifier;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: pageIndexNotifier,
      builder: (_, value, __) {
        final isSelected = itemIdentityIndex == value;
        return GestureDetector(
          onTap: (){
            AmptiveHelperFunctions.hideAnyMountedSnackbar(context);
            //if the user taps on a nav bar item, update the index of the controller
            //to be the index of the tapped item.
            pageIndexNotifier.value = itemIdentityIndex;
            pageController.animateToPage(
              itemIdentityIndex,
              duration: const Duration(milliseconds: 1),
              curve: Curves.easeIn
            );
          },
          child: AnimatedCrossFade(
            firstChild: Icon(icon, color: AmptiveColors.whiteColor),
            secondChild: Icon(icon, color: AmptiveColors.fillGreyColor.withOpacity(0.3),),
            crossFadeState: isSelected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    );
  }
}
