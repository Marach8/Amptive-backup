import 'package:amptive/src/features/calender/cubits/calender_programs_bloc.dart';
import 'package:amptive/src/features/calender/cubits/selected_calender_date_bloc.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class RenderEachWeekHeading extends StatelessWidget {
  const RenderEachWeekHeading({
    super.key,
    required this.eachWeek,
  });

  final List<DateTime?>? eachWeek;

  @override
  Widget build(BuildContext context) {
    const List<String> weekDays = <String>['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: (eachWeek ?? <DateTime?>[]).asMap().entries.map(
          (MapEntry<int, DateTime?> day){
            final String? dayHeading = weekDays.elementAtOrNull(day.key);
            final DateTime now = DateTime.now();
            final bool isToday = (day.value?.year == now.year) &&
              (day.value?.month == now.month) && (day.value?.day == now.day);
      
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  dayHeading ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
            
                if(day.value != null) BlocBuilder<SelectedCalenderDateBloc, DateTime?>(
                  builder: (_, DateTime? state) {
                    final bool isSelected = state == day.value;
                    return ATContainer(
                      onTap: () {
                        context.read<SelectedCalenderDateBloc>().pickADate(day.value);
                        ATHelperFuncs.callDebouncer(
                          1000,
                          () => context.read<CalenderProgramBloc>().add(
                            LoadProgramsEvent(programDate: day.value),
                          )
                        );
                        //debugPrint("Selected: ${DateFormat.yMMMd().format(day.value.day)}");
                      },
                      duration: 0,
                      margin: const EdgeInsets.only(top: 5),
                      height: 35, width: 35,
                      boxShape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? ATColors.white : ATColors.transparent,
                      ),
                      color: isToday ? ATColors.hex307FE2 : ATColors.transparent,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${day.value?.day}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: ATSizes.size18
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          }
        ).toList()
      ),
    );
  }
}
