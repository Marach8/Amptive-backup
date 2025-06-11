import 'dart:async';

import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/calender_views_bloc.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../widgets/calender_widgets_export.dart';
import 'calender_views_export.dart';



class ATCalenderScreen extends StatelessWidget {
  const ATCalenderScreen({super.key});

  @override
  Widget build(context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, kToolbarHeight, 0, kBottomNavigationBarHeight),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0,15, 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.keyboard_arrow_left, size: 30),
                    ),
                    BlocSelector<CalenderViewsBloc, CalenderViewsState, String>(
                      selector: (curr) => curr.$2,
                      builder: (_, state) {
                        return Text(
                          state,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: ATFontSizes.size23
                          ),
                        );
                      }
                    ),
                    const Spacer(),
                    BlocSelector<CalenderViewsBloc, CalenderViewsState, int>(
                      selector: (curr) => curr.$1,
                      builder: (_, state) {
                        return CalenderDropDown(currIndex: state);
                      }
                    ),
                  ],
                ),
              ),
          
              Expanded(
                child: BlocConsumer<CalenderViewsBloc, CalenderViewsState>(
                  listener: (_, state){
                    if(state.$1 == 1){
                      context.read<CalenderViewsBloc>().showOnlyYear();
                    }
                    else{
                      context.read<CalenderViewsBloc>().showMonthAndYear();
                    }
                  },
                  buildWhen: (prev, curr) => prev.$1 != curr.$1,
                  listenWhen: (prev, curr) => prev.$1 != curr.$1,
                  builder: (_, state) {
                    return IndexedStack(
                      index: state.$1,
                      children: const [
                        CalenderDayView(),
                        CalenderMonthView(),
                        ScheduledEventsView()
                      ],
                    );
                  }
                ),
              ),
            ],
          ),
        ),

        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: ATPlainElevatedBtn(
            onPressed: (){},
            btnTitle: ATStrings.CREATE_SCHEDULE,
            bgColor: ATColors.white,
            fgColor: ATColors.brandBlack
          ),
        )
      ),
    );
  }
}




class CalenderDayView extends StatelessWidget {
  const CalenderDayView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 70, child: DateAndWeekDays()),

        Expanded(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              HoursAndProgramsList(),
              CurrentTimeIndicator()
            ],
          )
        )
      ],
    );
  }
}




class CurrentTimeIndicator extends StatefulWidget {
  const CurrentTimeIndicator({super.key});

  @override
  State<CurrentTimeIndicator> createState() => _CurrentTimeIndicatorState();
}

class _CurrentTimeIndicatorState extends State<CurrentTimeIndicator> {
  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => setState(() => _currentTime = DateTime.now())
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate position based on current time
    final totalMinutes = _currentTime.hour * 60 + _currentTime.minute;
    final position = (totalMinutes / 1440) * (60 * 24); // 60px per hour * 24 hours

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 2,
        color: Colors.green,
        child: Row(
          children: [
            Text(
              DateFormat.jm().format(_currentTime),
              style: const TextStyle(color: Colors.green),
            ),
            const Expanded(
              child: Divider(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
