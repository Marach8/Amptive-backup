import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/calender_programs_bloc.dart';
import 'package:amptive/src/services/go_live_service/go_live_service.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/home_sub_view/profile/menu/calender/day_view.dart';
import 'package:amptive/src/views/widgets/common_widgets/overlapping_images.dart';
import 'package:amptive/src/views/widgets/common_widgets/show_event_nd_paid_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'dart:developer' as marach show log;
import '../../../../../../../../../models/host.dart';
import '../../../../../../../../widgets/common_widgets/custom_container_widget.dart';

class ScheduledEventsView extends StatelessWidget {
  const ScheduledEventsView({super.key});

  @override
  Widget build(context) {
    return Column(
      children: [
        Divider(
          color: ATColors.white.withValues(alpha: 0.2),
          height: 0, thickness: 0.3,
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(15, 5, 10, kBottomNavigationBarHeight),
            itemCount: _map.entries.length,
            itemBuilder: (_, listIndex){
              final programs = _map.entries.elementAt(listIndex);
              final day = _formatDay(programs.key);  
          
              return StickyHeaderBuilder(
                builder: (_, __){
                  return Material(
                    color: ATColors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 2),
                        Divider(
                          color: ATColors.white.withValues(alpha: 0.2),
                          height: 0, thickness: 0.3,
                        ),
                      ],
                    ),
                  );
                },
                content: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 15,
                    children: programs.value.map(
                      (program){
                        return _CalenderProgramDisplay(program: program);
                      }
                    ).toList(),
                  ),
                ),
              );
            }
          ),
        ),
      ],
    );
  }
}


String _formatDay(DateTime date){
  final dayName = DateFormat.E().format(date);
  final dayNumber = date.day;
  return '$dayName - $dayNumber';
}



final _map = <DateTime, List<CalenderProgram>>{
  DateTime(2025, 3, 20) : [
    CalenderProgram(
      name: 'Former CIA Agent On Trump Assasination Has Repented',
      id: 1, isEvent: true,
      isPaid: true, dateTime: DateTime(2025),
      eventType: 'News',
      hosts: getHostList().take(1).toList()
    ),
    CalenderProgram(
      name: 'Blue Hawaii with Minty Boi',
      id: 2, isEvent: true,
      isPaid: false, dateTime: DateTime(2025),
      eventType: 'Comedy',
      hosts: getHostList().take(2).toList()
    ),
  ],
  DateTime(2025, 3, 21) : [
    CalenderProgram(
      name: 'Sporting Defect of Manchester',
      id: 3, isEvent: true,
      isPaid: true, dateTime: DateTime(2025),
      eventType: 'Comedy',
      hosts: getHostList().take(4).toList()
    ),
    CalenderProgram(
      name: 'Blue Hawaii with Minty Boi',
      id: 2, isEvent: true,
      isPaid: true, dateTime: DateTime(2025),
      eventType: 'News',
      hosts: getHostList().take(1).toList()
    ),
  ],
  DateTime(2025, 3, 26) : [
    CalenderProgram(
      name: 'Config 2025',
      id: 3, isEvent: false,
      isPaid: true, dateTime: DateTime(2025),
      eventType: 'Comedy',
      hosts: getHostList().take(4).toList()
    ),
    CalenderProgram(
      name: 'Blue Hawaii with Minty Boi',
      id: 2, isEvent: true,
      isPaid: true, dateTime: DateTime(2025),
      eventType: 'News',
      hosts: getHostList().take(1).toList()
    ),
    CalenderProgram(
      name: 'Config',
      id: 2, isEvent: false,
      isPaid: true, dateTime: DateTime(2025),
      eventType: 'News',
      hosts: getHostList().take(5).toList()
    ),
  ],
  DateTime(2025, 3, 26) : [
    CalenderProgram(
      name: 'Config 2025',
      id: 3, isEvent: false,
      isPaid: true, dateTime: DateTime(2025),
      eventType: 'Comedy',
      hosts: getHostList().take(4).toList()
    ),
    CalenderProgram(
      name: 'Blue Hawaii with Minty Boi',
      id: 2, isEvent: true,
      isPaid: true, dateTime: DateTime(2025),
      eventType: 'News',
      hosts: getHostList().take(1).toList()
    ),
    CalenderProgram(
      name: 'Config',
      id: 2, isEvent: false,
      isPaid: true, dateTime: DateTime(2025),
      eventType: 'News',
      hosts: getHostList().take(5).toList()
    ),
    CalenderProgram(
      name: 'Blue Hawaii with Minty Boi',
      id: 2, isEvent: true,
      isPaid: true, dateTime: DateTime(2025),
      eventType: 'News',
      hosts: getHostList().take(1).toList()
    ),
    CalenderProgram(
      name: 'Config',
      id: 2, isEvent: false,
      isPaid: true, dateTime: DateTime(2025),
      eventType: 'News',
      hosts: getHostList().take(5).toList()
    ),
  ],
};





class _CalenderProgramDisplay extends StatelessWidget {
  final CalenderProgram program;
  const _CalenderProgramDisplay({
    super.key,
    required this.program
  });

  @override
  Widget build(context) {
    final title = program.name;
    final isEvent = program.isEvent;
    final isPaid = program.isPaid;
    final type = program.eventType;
    final hostsImgs = program.hosts.map((host) => (host.obj as Host).profilePicture ?? '');

    return ATContainer(
      radius: 5, clipBehavior: Clip.hardEdge,
      child: CustomPaint(
        painter:LeftBorderPainter(
          color: isEvent ? ATColors.hex27E8DB : ATColors.hexF79E1E,
          width: 5,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(7, 0, 0, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              Row(
                children: [
                  isEvent ? const EventIcon() : const ShowIcon(),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall,
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
}