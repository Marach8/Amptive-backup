import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/calender/v_model/calender_views_bloc.dart';
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
        : const _ScheduledIcon(),
      
      itemBuilder: (_) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          height: 40,
          onTap: () => context.read<CalenderViewsBloc>().selectView(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                ATStrings.DAY_VIEW,
                style: context.textTheme.bodySmall?.copyWith(
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
                style: context.textTheme.bodySmall?.copyWith(
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
                ATStrings.scheduled,
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: ATSizes.size15
                ),
              ),
              const _ScheduledIcon(),
            ],
          )
        )
      ]
    );
  }
}


class _ScheduledIcon extends StatelessWidget {
  const _ScheduledIcon();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 2,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 8, width: 20,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: ATColors.transparent,
            border: Border.all(color: ATColors.white, width: 2),
          ),
        ),
        Container(
          height: 8, width: 20,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            border: Border.all(color: ATColors.white, width: 2),
            color: ATColors.transparent,
          ),
        ),
      ],
    );
  }
}