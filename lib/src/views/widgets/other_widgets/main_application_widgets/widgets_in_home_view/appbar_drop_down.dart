import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AmptiveAppBarDropDownWidget extends StatelessWidget {
  final Widget child;
  final Offset? offset;
  const AmptiveAppBarDropDownWidget({
    super.key,
    required this.child,
    this.offset
  });

  @override
  Widget build(context) {  
    return PopupMenuButton<String>(
      offset: offset ?? const Offset(-80, 35),
      padding: EdgeInsets.zero,
      onSelected: (selectedSearchChoice){},
      color: AmptiveColors.containerGradientColorB,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      child: child,
      
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          height: 40.h,
          onTap: (){
            context.pushNamed(AmptiveRoutes.SCHEDULED_EVENTS_OR_SHOWS_SCREEN);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AmptiveOtherStrings.scheduled,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: AmptiveFontSizes.size15
                ),
              ),
              const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.CALEND_ICON)
            ],
          )
        ),
        PopupMenuItem<String>(
          height: 40.h,
          onTap: (){
            context.pushNamed(AmptiveRoutes.SUBSCRIBED_EVENTS_OR_SHOWS_SCREEN);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AmptiveOtherStrings.SUBSCRIBED,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: AmptiveFontSizes.size15
                ),
              ),
              const Icon(Icons.favorite_border_outlined)
            ],
          )
        ),
        PopupMenuItem<String>(
          height: 40.h,
          onTap: (){
            context.pushNamed(AmptiveRoutes.FOLLOWING_EVENTS_OR_SHOWS_SCREEN);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AmptiveOtherStrings.FOLLOWING,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: AmptiveFontSizes.size15
                ),
              ),
              const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.PERSON_CHECKED)
            ],
          )
        )
      ]
    );
  }
}