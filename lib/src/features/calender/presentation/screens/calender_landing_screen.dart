import 'package:amptive/src/features/calender/cubits/calender_views_bloc.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/calender/presentation/screens/calender_day_view.dart';
import 'package:amptive/src/features/calender/presentation/widgets/calender_drop_down.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import '../../../../shared/app_bar_widget.dart';
import '../../../../shared/back_button.dart';
import '../../cubits/day_view_date_time_indicator_cubit.dart';
import 'calender_views_export.dart';

// leadingWidth: 200,
//                 leading: Padding(
//                   padding: const EdgeInsets.only(left: 20),
//                   child: ATBackBtn(
//                     alignment: Alignment.centerLeft,
//                     leadingText: ATStrings.scheduled,
//                     leadingStyle: context.textTheme.bodyMedium?.copyWith(
//                       fontSize: ATSizes.size23
//                     ),
//                   )
//                 ),

class ATCalenderLandingScreen extends StatelessWidget {
  const ATCalenderLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<DayViewDateTimeIndicatorCubit>(
          create: (_) => DayViewDateTimeIndicatorCubit(
            initialTime: DateTime.now(),
          ),
        ),
      ],
      child: ATAnnotatedRegion(
        child: Scaffold(
            appBar: ATAppBar(
              leadingWidth: 200,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              leading: ATBackBtn(
                alignment: Alignment.centerLeft,
                leadingWidget:
                    BlocSelector<CalenderViewsBloc, CalenderViewsState, String>(
                        selector: (CalenderViewsState curr) => curr.$2,
                        builder: (_, String state) {
                          return Text(
                            state,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontSize: ATSizes.size23),
                          );
                        }),
              ),
              actions: <Widget>[
                BlocSelector<CalenderViewsBloc, CalenderViewsState, int>(
                    selector: (CalenderViewsState curr) => curr.$1,
                    builder: (_, int state) {
                      return CalenderDropDown(currIndex: state);
                    }),
              ],
            ),
            body: BlocConsumer<CalenderViewsBloc, CalenderViewsState>(
                listener: (_, CalenderViewsState state) {
                  if (state.$1 == 1) {
                    context.read<CalenderViewsBloc>().showOnlyYear();
                  } else {
                    context.read<CalenderViewsBloc>().showMonthAndYear();
                  }
                },
                buildWhen: (CalenderViewsState prev, CalenderViewsState curr) =>
                    prev.$1 != curr.$1,
                listenWhen:
                    (CalenderViewsState prev, CalenderViewsState curr) =>
                        prev.$1 != curr.$1,
                builder: (_, CalenderViewsState state) {
                  return IndexedStack(
                    index: state.$1,
                    children: const <Widget>[
                      CalenderDayView(),
                      CalenderMonthView(),
                      ScheduledEventsView()
                    ],
                  );
                }),
            bottomSheet: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 60),
              child: ATPlainElevatedBtn(
                  onPressed: () {},
                  btnTitle: ATStrings.createSchedule,
                  bgColor: ATColors.white,
                  fgColor: ATColors.hex0D0D0D),
            )),
      ),
    );
  }
}
