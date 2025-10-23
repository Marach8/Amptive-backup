import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/day_view_bloc.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calender_widgets_export.dart';




class DateAndWeekDays extends StatefulWidget {
  const DateAndWeekDays({super.key});

  @override
  State<DateAndWeekDays> createState() => DateAndWeekDaysState();
}

class DateAndWeekDaysState extends State<DateAndWeekDays> {
  late PageController _pageController;

  @override
  void initState(){
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback(
      (_){
        context.read<DayViewHeadingBloc>().add(InitializeDayViewHeadingEvent());
        context.read<HoursInADayBloc>().generateHoursInADay();
      }
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    ATHelperFuncs.disposeDebouncer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DayViewHeadingBloc, DayViewHeadingState>(
      listener: (_, DayViewHeadingState curr){
        if(curr is DayViewHeadingData){
          ATHelperFuncs.callDebouncer(
            500,
            () => _pageController.animateToPage(
              curr.initialPage,
              duration: const Duration(seconds: 1),
              curve: Curves.decelerate
            )
          );
        }
      },
      builder: (_, DayViewHeadingState state) {
        if(state is DayViewHeadingLoading){
          return const SizedBox(
            height: 70,
            child: ATShimmer(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
            ),
          );
        }

        if(state is DayViewHeadingInitial){
          return const SizedBox.shrink();
        }

        if(state is DateAndWeekDaysError){
          return Text(state.error);
        }

        final List<List<DateTime?>> weeks = (state as DayViewHeadingData).weeks;

        return PageView.builder(
          controller: _pageController,
          padEnds: false,
          allowImplicitScrolling: true,
          physics: const BouncingScrollPhysics(),
          itemCount: weeks.length,
          itemBuilder: (_, int pageIndex) {
            final List<DateTime?>? eachWeek = weeks.elementAtOrNull(pageIndex);
            return RenderEachWeekHeading(eachWeek: eachWeek, key: ValueKey(pageIndex));
          },
        );
      }
    );
  }
}