import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/config_export.dart';
import '../../cubits/day_view_date_time_indicator_cubit.dart';


class CurrentTimeIndicator extends StatelessWidget {
  const CurrentTimeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      DayViewDateTimeIndicatorCubit,
      DayViewDateTimeIndicatorState,
      ({double indicatorOffset, String currentTime})
    >(
      selector: (DayViewDateTimeIndicatorState state) => (
        indicatorOffset: state.indicatorOffset,
        currentTime: state.currentTime,
      ),
      builder: (_, ({String currentTime, double indicatorOffset}) state) {
        return Positioned(
          left: 0, right: 0,
          top: state.indicatorOffset - 8,
          child: Row(
            spacing: 1,
            children: <Widget>[
              Text(
                state.currentTime,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: ATColors.hex307FE2,
                  fontSize: ATSizes.size10,
                  height: 1.2, letterSpacing: 0.12
                ),
              ),
              const Expanded(child: _HorizontalIndicator())
            ],
          ),
        );
      }
    );
  }
}

class _HorizontalIndicator extends StatelessWidget {
  const _HorizontalIndicator();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          left: 5,
          child: Container(
            height: 10, width: 10,
            decoration: BoxDecoration(
              color: ATColors.hex307FE2,
              shape: BoxShape.circle,
              border: Border.all(
                color: ATColors.white, width: 0.5
              ),
            ),
          ),
        ),
        Divider(color: ATColors.hex307FE2,),
      ],
    );
  }
}