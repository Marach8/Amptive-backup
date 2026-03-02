import 'package:amptive/src/features/calender/cubits/calender_programs_bloc.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/services/go_live_service/go_live_service.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/overlapping_widgets.dart';
import 'package:amptive/src/shared/show_event_nd_paid_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../calender_export.dart';
import '../widgets/calender_program_display.dart';


class ScheduledEventsView extends StatelessWidget {
  const ScheduledEventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(
          color: ATColors.white.withValues(alpha: 0.2),
          height: 0, thickness: 0.3,
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(15, 5, 10, 0),
            itemCount: _map.entries.length,
            itemBuilder: (_, int listIndex){
              final MapEntry<DateTime, List<CalenderProgram>> programs = _map.entries.elementAt(listIndex);
              final String day = _formatDay(programs.key);  
          
              return StickyHeaderBuilder(
                builder: (_, __){
                  return Material(
                    color: ATColors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                      (CalenderProgram program){
                        return _CalenderProgramDisplay(program: program);
                      }
                    ).toList(),
                  ),
                ),
              );
            }
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}


String _formatDay(DateTime date){
  final String dayName = DateFormat.E().format(date);
  final int dayNumber = date.day;
  return '$dayName - $dayNumber';
}



final Map<DateTime, List<CalenderProgram>> _map = <DateTime, List<CalenderProgram>>{
  DateTime(2025, 3, 20) : <CalenderProgram>[
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
  DateTime(2025, 3, 21) : <CalenderProgram>[
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
  DateTime(2025, 3, 26) : <CalenderProgram>[
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
  DateTime(2025, 3, 26) : <CalenderProgram>[
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
  const _CalenderProgramDisplay({
    required this.program
  });
  final CalenderProgram program;

  @override
  Widget build(BuildContext context) {
    final String title = program.name;
    final bool isEvent = program.isEvent;
    final bool isPaid = program.isPaid;
    final String type = program.eventType;
    final Iterable<String> hostsImgs = program.hosts.map((ObjectWithNotifier host) => (host.obj as Host).profilePicture ?? '');

    return ATContainer(
      radius: 5, clipBehavior: Clip.hardEdge,
      child: CustomPaint(
        painter: LeftBorderPainter(
          color: isEvent ? ATColors.hex27E8DB : ATColors.hexF79E1E,
          width: 5,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(7, 0, 0, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 5),
              Row(
                children: <Widget>[
                  isEvent ? const EventIcon() : const ATShowIcon(),
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
                children: <Widget>[
                  if(isPaid) const ATPaidIndicatorIcon(),
                  if(isPaid) const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      '$type • 17:00',
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