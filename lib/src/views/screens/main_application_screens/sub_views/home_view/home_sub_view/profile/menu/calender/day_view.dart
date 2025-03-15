import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/calender_events_bloc.dart';
import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/calender_views_bloc.dart';
import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/selected_calender_date_bloc.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/home_sub_view/profile/menu/calender/month_view.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/home_sub_view/profile/menu/calender/scheduled.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/shimmer.dart';
import 'package:amptive/src/views/widgets/common_widgets/show_event_nd_paid_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../widgets/common_widgets/overlapping_images.dart';



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

        Expanded(child: HoursAndProgramsList())
      ],
    );
  }
}


class DateAndWeekDays extends StatefulWidget {
  const DateAndWeekDays({super.key});

  @override
  State<DateAndWeekDays> createState() => _DateAndWeekDaysState();
}

class _DateAndWeekDaysState extends State<DateAndWeekDays> {
  late PageController _pageController;
  late List<List<DateTime>> weeks;
  int initialPage = 0;

  @override
  void initState() {
    super.initState();
    
    final now = DateTime.now();
    weeks = ATHelperFuncs.getWeeksInAMonth(
      year: now.year, month: now.month
    );

    // Find the index of the week that contains today's date
    for (int i = 0; i < weeks.length; i++) {
      if (weeks[i].any((day) => day.day == now.day)) {
        initialPage = i;
        break;
      }
    }

    _pageController = PageController(initialPage: initialPage);

    // Scroll to today's page after the first frame
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _pageController.animateToPage(
        initialPage,
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate
      )
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    ATHelperFuncs.disposeDebouncer();
    super.dispose();
  }

  @override
  Widget build(context) {
    return PageView.builder(
      controller: _pageController,
      padEnds: false,
      allowImplicitScrolling: true,
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
                  style: Theme.of(context).textTheme.titleSmall,
                ),
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
                          ATHelperFuncs.callDebouncer(
                            1000,
                            () => context.read<CalenderProgramBloc>().add(
                              LoadProgramsEvent(programDate: day),
                            )
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
                        color: isToday ? ATColors.hex307FE2 : ATColors.trsprtColor,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${day.day}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            ),
          ],
        );
      },
    );
  }
}





class HoursAndProgramsList extends StatelessWidget {
  const HoursAndProgramsList({super.key});
  @override
  Widget build(context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 15),
      itemCount: 24,
      itemBuilder: (context, index) {
        DateTime time = DateTime(2025, 3, 12, index); 
        String formattedTime = DateFormat('hh:00 a').format(time).toLowerCase();

        return Column(
          children: [
            Row(
              children: [
                Text(
                  formattedTime, 
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
                if(isLoading) return const ShimmerWidget(margin: EdgeInsets.only(left: 58));
                if(hasError) return const Text('Error occured');

                final programs = state as ProgramsDataState;
                final listOfProgs = programs.programs[formattedTime];

                if(listOfProgs == null) return const SizedBox(height: 30);
                
                final anItem = listOfProgs.first;
                final title = anItem.name;
                final isEvent = anItem.isEvent;
                final isPaid = anItem.isPaid;
                final type = anItem.eventType;
                final hostsImgs = anItem.hosts.map((host) => (host.obj as Host).profilePicture ?? '');
                
                return ATContainer(
                  margin: const EdgeInsets.only(left: 55),
                  radius: 5, clipBehavior: Clip.hardEdge,
                  color: isEvent ? ATColors.hex27E8DB.withValues(alpha: 0.2) 
                    : ATColors.hexF79E1E.withValues(alpha: 0.2),
                  child: CustomPaint(
                    painter:LeftBorderPainter(
                      color: isEvent ? ATColors.hex27E8DB : ATColors.hexF79E1E,
                      width: 5,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(7, 2, 0, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              isEvent ? const EventIcon() : const ShowIcon(),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  title,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: ATFontSizes.size13,
                                    color: isEvent ? ATColors.hex27E8DB : ATColors.hexF79E1E
                                  )
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                                child: ATOverlappingImages(imgPaths: hostsImgs.toList()),
                              )
                            ],
                          ),
                                          
                          Row(
                            children: [
                              if(isPaid) const PaidIndicatorIcon(),
                              if(isPaid) const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  type,
                                  style: Theme.of(context).textTheme.titleSmall
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
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


class LeftBorderPainter extends CustomPainter {
  final Color color;
  final double width;

  LeftBorderPainter({required this.color, this.width = 3.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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