import 'package:amptive/src/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveAppBarDropDownWidget extends StatelessWidget {
  const AmptiveAppBarDropDownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //final popupController = ref.watch(popupControllerProvider);    

    return PopupMenuButton<String>(
      //enabled: popupController != 2,
      // onOpened: () => ref.read(popupControllerProvider.notifier).state = 1,
      // onCanceled: () => ref.read(popupControllerProvider.notifier).state = 0,
      offset: const Offset(-80, 35),
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.bounceInOut,
        duration: const Duration(seconds: 1),
        reverseCurve: Curves.easeInCubic
      ),
      padding: EdgeInsets.zero,
      onSelected: (selectedSearchChoice){
        // ref.read(hintTextProvider.notifier).state = AgroMallTaskStrings.search + selectedSearchChoice;
        // ref.read(popupControllerProvider.notifier).state = 0;
      },
      icon: const Icon(Icons.keyboard_arrow_down_outlined, size: 25,),
      // icon: AnimatedCrossFade(
      //   firstChild: const Icon(Icons.keyboard_arrow_down_outlined, size: 25),
      //   secondChild: const Icon(Icons.keyboard_arrow_up_outlined, size: 25),
      //   crossFadeState: emmanuel ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      //   firstCurve: Curves.decelerate,
      //   secondCurve: Curves.decelerate,
      //   sizeCurve: Curves.decelerate,
      //   duration: const Duration(seconds: 2),
      // ),
      
      itemBuilder: (_) => AmptiveHomeScreenPages.values.map(
        (searchChoice) => PopupMenuItem<String>(
          height: 40.h,
          value: searchChoice.name,
          child: Text(
            searchChoice.name,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        )
      ).toList()
    );
  }
}