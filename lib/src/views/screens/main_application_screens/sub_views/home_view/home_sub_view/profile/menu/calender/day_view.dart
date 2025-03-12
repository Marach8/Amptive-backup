import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/calender_events_bloc.dart';
import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/calender_views_bloc.dart';
import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/selected_calender_date_bloc.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/home_sub_view/profile/menu/calender/month_view.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/home_sub_view/profile/menu/calender/scheduled.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


class ATCalenderScreen extends StatelessWidget {
  const ATCalenderScreen({super.key});

  @override
  Widget build(context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, kToolbarHeight, 0, kBottomNavigationBarHeight),
          child: BlocBuilder<CalenderViewsBloc, int>(
            builder: (_, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0,15, 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: const Icon(Icons.keyboard_arrow_left, size: 30),
                        ),
                        Text(
                          state == 1 ? '2025' : 'February 2025',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: ATFontSizes.size23
                          ),
                        ),
                        const Spacer(),
                        CalenderDropDown(currIndex: state),
                      ],
                    ),
                  ),
              
                  Expanded(
                    child: IndexedStack(
                      index: state,
                      children: const [
                        CalenderDayView(),
                        CalenderMonthView(),
                        ScheduledCalenderEvents()
                      ],
                    ),
                  ),
                ],
              );
            }
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
  Widget build(context) {
    return const Column(
      children: [
        SizedBox(height: 70, child: DateAndWeekDays()),

        Expanded(child: HoursListWithDivider())
      ],
    );
  }
}


class DateAndWeekDays extends StatelessWidget {
  const DateAndWeekDays({super.key});

  @override
  Widget build(context) {
    final weeks = AmptiveHelperFunctions.getWeeksInAMonth(
      year: DateTime.now().year, month: DateTime.now().month
    );

    return PageView.builder(
      padEnds: false,
      physics: const BouncingScrollPhysics(),
      itemCount: weeks.length,
      itemBuilder: (_, pageIndex) {
        return Table(
          children: [
            TableRow(
              children: weeks[pageIndex].map(
                (day) => Text(
                  DateFormat.E().format(day),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall
                )
              ).toList(),
            ),
            TableRow(
              children: weeks[pageIndex].map(
                (day) {
                  final isToday = day.day == DateTime.now().day;
                  return BlocBuilder<SelectedCalenderDateBloc, DateTime?>(
                    builder: (_, state) {
                      final isSelected = state == day;
                      return ATContainer(
                        onTap: () {
                          context.read<SelectedCalenderDateBloc>().pickADate(day);
                          context.read<CalenderProgramBloc>().add(
                            LoadProgramsEvent(programDate: day)
                          );
                          debugPrint("Selected: ${DateFormat.yMMMd().format(day)}");
                        },
                        duration: 0,
                        margin: const EdgeInsets.only(top: 5),
                        height: 35, width: 35,
                        boxShape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? ATColors.white : ATColors.trsprtColor,
                        ),
                        color: isToday? ATColors.hex307FE2 : ATColors.trsprtColor,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${day.day}',
                            style: Theme.of(context).textTheme.labelSmall
                          ),
                        ),
                      );
                    }
                  );
                }
              ).toList(),
            ),
          ],
        );
      },
    );
  }
}





class HoursListWithDivider extends StatelessWidget {
  const HoursListWithDivider({super.key});
  @override
  Widget build(context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 15),
      itemCount: 24,
      itemBuilder: (context, index) {
        DateTime time = DateTime(2025, 3, 12, index); 
        String formattedTime = DateFormat('hh:00 a').format(time);

        return Column(
          children: [
            Row(
              children: [
                Text(
                  formattedTime.toLowerCase(), 
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: ATFontSizes.size11,
                    color: ATColors.hexC2C2C2
                  )
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Divider(color: ATColors.white.withValues(alpha: 0.2))
                ),
              ],
            ),
            BlocBuilder<CalenderProgramBloc, ProgramsState>(
              builder: (_, state) {
                final isLoading = state is ProgramsLoadingState;
                final hasError = state is ProgramsErrorState;
                final initialState = state is NoProgramsState;

                if(initialState) return const SizedBox(height: 30);
                if(isLoading) return const CircularProgressIndicator();
                if(hasError) return const Text('Error occured');

                final programs = state as ProgramsDataState;
                final listOfProgs = programs.programs[formattedTime];

                if(listOfProgs == null) return const SizedBox(height: 30);
                final anItem = listOfProgs.first;
                final title = anItem.name;
                final isEvent = anItem.isEvent;                

                return ATContainer(
                  color: isEvent ? ATColors.hex27E8DB.withValues(alpha: 0.2) 
                    : ATColors.hexF79E1E.withValues(alpha: 0.2),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ATImgLoader(
                            imgPath: ATImgStrings.sIcon,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            title,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: ATFontSizes.size13,
                              color: isEvent ? ATColors.hex27E8DB : ATColors.hexF79E1E
                            )
                          )
                        ],
                      )
                    ],
                  ),
                );
              }
            ),
          ],
        );
      },
    );
  }
}



class CalenderDropDown extends StatelessWidget {
  final int currIndex;
  const CalenderDropDown({
    super.key,
    required this.currIndex
  });

  @override
  Widget build(context) {  
    return PopupMenuButton<String>(
      offset: const Offset(0, 35),
      padding: EdgeInsets.zero,
      onSelected: (item){},
      color: ATColors.containerGradientColorB,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      child: currIndex == 0 ? 
        const Icon(Icons.calendar_view_day_outlined)
        : currIndex == 1 ? const Icon(Icons.calendar_view_month_outlined)
        : const Icon(Icons.schedule_outlined),
      
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          height: 40,
          onTap: () => context.read<CalenderViewsBloc>().selectView(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ATStrings.DAY_VIEW,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: ATFontSizes.size15
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
            children: [
              Text(
                ATStrings.MONTH_VIEW,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: ATFontSizes.size15
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
            children: [
              Text(
                ATStrings.SCHEDULED,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: ATFontSizes.size15
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