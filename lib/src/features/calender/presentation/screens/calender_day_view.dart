import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/calender/cubits/calender_programs_bloc.dart';
import 'package:amptive/src/features/calender/cubits/day_view_date_time_indicator_cubit.dart';
import 'package:amptive/src/features/calender/presentation/widgets/calender_program_display.dart';
import 'package:amptive/src/features/calender/presentation/widgets/current_time_indicator.dart';
import 'package:amptive/src/features/calender/presentation/widgets/date_and_weekdays.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalenderDayView extends StatelessWidget {
  const CalenderDayView({super.key});
  static final List<String> hoursInADay =
      ATHelperFuncs.generateHoursInADay(null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 70, child: DateAndWeekDays()),
        Expanded(
          child: _HoursAndProgramsList(hoursInADay: hoursInADay),
        )
      ],
    );
  }
}

class _HoursAndProgramsList extends StatelessWidget {
  const _HoursAndProgramsList({required this.hoursInADay});
  final List<String> hoursInADay;

  @override
  Widget build(BuildContext context) {
    const double itemHeight = 45;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 15, top: 20),
      itemCount: hoursInADay.length,
      itemBuilder: (_, int topIndex) {
        final String formattedActiveHour = hoursInADay[topIndex];

        return Padding(
          padding: EdgeInsets.only(
            bottom: topIndex == hoursInADay.length - 1 ? 120 : 0,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: <Widget>[
              Row(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(formattedActiveHour,
                      style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: ATSizes.size11,
                          color: ATColors.hexC2C2C2,
                          height: 0.01)),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Divider(
                          color: ATColors.white.withValues(alpha: 0.2),
                          height: 0,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        BlocBuilder<CalenderProgramBloc, ProgramsState>(
                            builder: (_, ProgramsState state) {
                          final bool isLoading = state is ProgramsLoadingState;
                          final bool hasError = state is ProgramsErrorState;
                          final bool initialState = state is NoProgramsState;

                          if (initialState) {
                            return const SizedBox(height: itemHeight);
                          }
                          if (isLoading) return const ATShimmer();
                          if (hasError) return const Text('Error occured');

                          final ProgramsDataState programs =
                              state as ProgramsDataState;
                          final List<CalenderProgram>? listOfProgs =
                              programs.programs[formattedActiveHour];

                          if (listOfProgs == null) {
                            return const SizedBox(height: itemHeight);
                          }

                          return SizedBox(
                            height: itemHeight,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listOfProgs.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (_, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: index == listOfProgs.length - 1
                                        ? 50
                                        : 5,
                                  ),
                                  child: CalenderProgramDisplay(
                                    program: listOfProgs[index],
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              BlocSelector<DayViewDateTimeIndicatorCubit,
                      DayViewDateTimeIndicatorState, String>(
                  selector: (DayViewDateTimeIndicatorState state) =>
                      state.activeHour,
                  builder: (_, String activeHour) {
                    if (activeHour == formattedActiveHour) {
                      return const CurrentTimeIndicator();
                    }
                    return const SizedBox.shrink();
                  })
            ],
          ),
        );
      },
    );
  }
}

