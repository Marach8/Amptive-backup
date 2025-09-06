import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/calender_views_bloc.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalenderDropDown extends StatelessWidget {
  const CalenderDropDown({
    super.key,
    required this.currIndex
  });
  final int currIndex;

  @override
  Widget build(BuildContext context) {  
    return PopupMenuButton<String>(
      offset: const Offset(0, 35),
      padding: EdgeInsets.zero,
      onSelected: (String item){},
      color: ATColors.containerGradientColorB,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      child: currIndex == 0 ? 
        const Icon(Icons.calendar_view_day_outlined)
        : currIndex == 1 ? const Icon(Icons.calendar_view_month_outlined)
        : const Icon(Icons.schedule_outlined),
      
      itemBuilder: (_) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          height: 40,
          onTap: () => context.read<CalenderViewsBloc>().selectView(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                ATStrings.DAY_VIEW,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: ATSizes.size15
                ),
              ),
              const Icon(Icons.calendar_view_day_outlined)
            ],
          )
        ),
        PopupMenuItem<String>(
          height: 40,
          onTap: () => context.read<CalenderViewsBloc>().selectView(1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                ATStrings.MONTH_VIEW,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: ATSizes.size15
                ),
              ),
              const Icon(Icons.calendar_view_month_outlined)
            ],
          )
        ),
        PopupMenuItem<String>(
          height: 40,
          onTap: () => context.read<CalenderViewsBloc>().selectView(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                ATStrings.SCHEDULED,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: ATSizes.size15
                ),
              ),
              const Icon(Icons.schedule_outlined)
            ],
          )
        )
      ]
    );
  }
}