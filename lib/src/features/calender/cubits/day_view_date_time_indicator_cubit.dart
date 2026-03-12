import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DayViewDateTimeIndicatorCubit
    extends Cubit<DayViewDateTimeIndicatorState> {
  DayViewDateTimeIndicatorCubit({
    required DateTime initialTime,
  }) : super(
          DayViewDateTimeIndicatorState(
            activeHour: DateFormat('hh:00 a')
                .format(
                  DateTime(
                    initialTime.year,
                    initialTime.month,
                    initialTime.day,
                    initialTime.hour,
                  ),
                )
                .toLowerCase(),
            currentTime:
                DateFormat('hh:mm a').format(initialTime).toLowerCase(),
            indicatorOffset: initialTime.minute * _pixelsPerMinute,
            currentDateTime: initialTime,
          ),
        ) {
    _startTimer();
  }

  Timer? _timer;
  static const double _timePartitionHeight = 54;
  static const double _pixelsPerMinute = _timePartitionHeight / 60;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _tick();
    });
  }

  void _tick() {
    final DateTime nextTime =
        state.currentDateTime.add(const Duration(minutes: 1));

    final DateTime normalizedHour = DateTime(
      nextTime.year,
      nextTime.month,
      nextTime.day,
      nextTime.hour,
    );

    final String nextHour =
        DateFormat('hh:00 a').format(normalizedHour).toLowerCase();

    final String nextTimeLabel =
        DateFormat('hh:mm a').format(nextTime).toLowerCase();

    final double nextOffset = nextTime.minute * _pixelsPerMinute;

    emit(
      state.copyWith(
        activeHour: nextHour,
        currentTime: nextTimeLabel,
        indicatorOffset: nextOffset,
        currentDateTime: nextTime,
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

class DayViewDateTimeIndicatorState extends Equatable {
  const DayViewDateTimeIndicatorState({
    required this.activeHour,
    required this.currentTime,
    required this.indicatorOffset,
    required this.currentDateTime,
  });

  final String activeHour, currentTime;
  final double indicatorOffset;
  final DateTime currentDateTime;

  DayViewDateTimeIndicatorState copyWith({
    String? activeHour,
    String? currentTime,
    double? indicatorOffset,
    DateTime? currentDateTime,
  }) =>
      DayViewDateTimeIndicatorState(
        activeHour: activeHour ?? this.activeHour,
        currentTime: currentTime ?? this.currentTime,
        indicatorOffset: indicatorOffset ?? this.indicatorOffset,
        currentDateTime: currentDateTime ?? this.currentDateTime,
      );

  @override
  List<Object?> get props => <Object?>[
        activeHour,
        currentTime,
        indicatorOffset,
        currentDateTime,
      ];
}
