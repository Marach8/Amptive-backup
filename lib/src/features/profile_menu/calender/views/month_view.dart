import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/calender_month_view_bloc.dart';
import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/calender_programs_bloc.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class CalenderMonthView extends StatefulWidget {

  const CalenderMonthView({super.key});

  @override
  State<CalenderMonthView> createState() => _CalenderMonthViewState();
}

class _CalenderMonthViewState extends State<CalenderMonthView> {

  late ScrollController _scrollController;
  @override 
  void initState(){
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<CalenderMonthViewBloc>().add(LoadInitialCalenderDataEvent())
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<CalenderMonthViewBloc>().add(LoadMoreCalenderDataEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CalenderMonthViewBloc, CalenderMonthViewState>(
      listenWhen: (_, CalenderMonthViewState curr) => (curr is CalenderMonthViewDataState) && curr.errorMsg != null,
      listener: (_, CalenderMonthViewState curr) => showAppNotification(
        context: context,
        icon: const Icon(Icons.warning),
        text: (curr as CalenderMonthViewDataState).errorMsg ?? ''
      ),
      builder: (_, CalenderMonthViewState state) {
        if(state is InitialCalenderMonthViewState){
          return const SizedBox.shrink();
        }
        if(state is CalenderMonthViewLoadingState){
          return const Center(child: ATLoadingIndicator(size: 30));
        }
    
        if(state is CalenderMonthViewErrorState){
          return const Text('Could not load items');
        }
    
        final Map<String, List<List<Map<DateTime?, List<CalenderProgram>>>>> calenderData = (state as CalenderMonthViewDataState).calenderData;
    
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
          controller: _scrollController,
          itemCount: calenderData.length + (state.hasMoreData ? 1 : 0),
          itemBuilder: (_, int index) {
            if(index < calenderData.length){
              final MapEntry<String, List<List<Map<DateTime?, List<CalenderProgram>>>>>? monthData = calenderData.entries.elementAtOrNull(index);
              return EachMonthWidget(monthData: monthData, key: ValueKey(index));
            }
    
            if(state.isLoadingMore){
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: ATLoadingIndicator(size: 30),
                )
              );
            }
            //This should never happpen
            return const SizedBox.shrink();
          }
        );
      }
    );
  }
}



class EachMonthWidget extends StatelessWidget {
  const EachMonthWidget({
    super.key,
    required this.monthData,
  });

  final MapEntry<String, List<List<Map<DateTime?, List<CalenderProgram>>>>>? monthData;

  @override
  Widget build(BuildContext context) {
    return StickyHeaderBuilder(
      builder: (_, __){
        return StickyHeaderWidget(
          key: ValueKey(monthData?.key),
          monthName: monthData?.key ?? '',
        );
      },

      content: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
        child: Column(
          spacing: 20,
          children: (monthData?.value ?? <List<Map<DateTime?, List<CalenderProgram>>>>[]).map(
            (List<Map<DateTime?, List<CalenderProgram>>> week) => EachWeekData(week: week, key: ObjectKey(week)),
          ).toList(),
        ),
      ),
    );
  }
}

class StickyHeaderWidget extends StatelessWidget {
  const StickyHeaderWidget({
    super.key,
    required this.monthName,
  });

  final String monthName;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ATColors.black,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: <Widget>[
                Text(
                  monthName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  backgroundColor: ATColors.hexF91880,
                  radius: 3,
                ),
                const SizedBox(width: 3),
                GestureDetector(
                  onTap: (){},
                  child: Text(
                    ATStrings.MORE_SCHEDULE,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _weekDays.map(
                (String day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


class EachWeekData extends StatelessWidget {
  const EachWeekData({
    super.key,
    required this.week
  });

  final List<Map<DateTime?, List<CalenderProgram>>> week;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: week.map(
        (Map<DateTime?, List<CalenderProgram>> mapOfProg){
          if(mapOfProg.keys.first != null){
            return Expanded(
              key: ValueKey('${week.indexOf(mapOfProg)}A'),
              child: EachDayWidget(mapOfProg: mapOfProg)
            );
          }
          
          return const Expanded(child: SizedBox.shrink());
        }
      ).toList(),
    );
  }
}


class EachDayWidget extends StatelessWidget {
  const EachDayWidget({
    super.key,
    required this.mapOfProg
  });

  final Map<DateTime?, List<CalenderProgram>> mapOfProg;

  @override
  Widget build(BuildContext context) {
    final DateTime? day = mapOfProg.keys.first;
    final DateTime now = DateTime.now();
    final bool isToday = (day?.year == now.year) &&
      (day?.month == now.month) && (day?.day == now.day);

    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: isToday ? ATColors.hex307FE2 : ATColors.transparent,
          child: Text(
            (day?.day.toString()) ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ),
        
        ...mapOfProg.values.first.map(
          (CalenderProgram program){
            return ATContainer(
              radius: 3,
              margin: const EdgeInsets.only(bottom: 2),
              padding: const EdgeInsets.only(left: 5),
              height: 18, width: 35,
              color: (program.isEvent ? ATColors.hexF79E1E : ATColors.hexEA5489).withValues(alpha: 0.2),
              child: Text(
                program.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: (program.isEvent ? ATColors.hexF79E1E : ATColors.hexEA5489), 
                  overflow: TextOverflow.clip
                ),
              )
            );
          }
        ),
        const SizedBox(height: 2),
        if(mapOfProg.values.first.length > 1)CircleAvatar(
          backgroundColor: ATColors.hexF91880,
          radius: 3,
        ),
      ],
    );
  }
}


final List<String> _weekDays = <String>['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];