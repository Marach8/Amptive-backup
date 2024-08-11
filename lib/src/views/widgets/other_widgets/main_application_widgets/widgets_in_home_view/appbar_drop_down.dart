import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class AmptiveAppBarDropDownWidget extends StatelessWidget {
  const AmptiveAppBarDropDownWidget({super.key});

  @override
  Widget build(BuildContext context) {  

    return PopupMenuButton<String>(
      offset: const Offset(-80, 35),
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.bounceInOut,
        duration: const Duration(seconds: 1),
        reverseCurve: Curves.easeInCubic
      ),
      padding: EdgeInsets.zero,
      onSelected: (selectedSearchChoice){},
      color: AmptiveColors.containerGradientColorB,
      elevation: 0,
      child: const Icon(Icons.keyboard_arrow_down_outlined, size: 25,),
      // child: AnimatedCrossFade(
      //   firstChild: const Icon(Icons.keyboard_arrow_down_outlined, size: 25),
      //   secondChild: const Icon(Icons.keyboard_arrow_up_outlined, size: 25),
      //   crossFadeState: emmanuel ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      //   firstCurve: Curves.decelerate,
      //   secondCurve: Curves.decelerate,
      //   sizeCurve: Curves.decelerate,
      //   duration: const Duration(seconds: 2),
      // ),
      
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          height: 40.h,
          onTap: (){},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AmptiveOtherStrings.scheduled,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Icon(Icons.calendar_today, size: 22,)
            ],
          )
        ),
        PopupMenuItem<String>(
          height: 40.h,
          onTap: (){},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AmptiveOtherStrings.subscribed,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Icon(Icons.favorite_border_outlined)
            ],
          )
        ),
        PopupMenuItem<String>(
          height: 40.h,
          onTap: (){},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AmptiveOtherStrings.following,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Icon(Iconsax.user_tick4)
            ],
          )
        )
      ]
    );
  }
}