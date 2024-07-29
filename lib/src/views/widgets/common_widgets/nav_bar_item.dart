import 'package:amptive/src/utils/constants/colors.dart';
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
            //if the user taps on a nav bar item, update the index of the controller
            //to be the index of the tapped item.
            pageIndexNotifier.value = itemIdentityIndex;
            pageController.jumpToPage(itemIdentityIndex);
          },
          child: AnimatedCrossFade(
            firstChild: Icon(icon, color: AmptiveColors.whiteColor),
            secondChild: Icon(icon, color: AmptiveColors.textFormFieldFillColor,),
            crossFadeState: isSelected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    );
  }
}
