import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/calender_widgets_export.dart';


class CalenderDayView extends StatelessWidget {
  const CalenderDayView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        SizedBox(height: 70, child: DateAndWeekDays()),

        Expanded(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
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
    final int totalMinutes = _currentTime.hour * 60 + _currentTime.minute;
    final double position = (totalMinutes / 1440) * (60 * 24); // 60px per hour * 24 hours

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 2,
        color: Colors.green,
        child: Row(
          children: <Widget>[
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
