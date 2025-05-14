import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/calender_programs_bloc.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class ATHelperFuncs{
  const ATHelperFuncs._();

  static double getScreenWidth(BuildContext context)
    => MediaQuery.sizeOf(context).width;

  static double getScreenHeight(BuildContext context)
    => MediaQuery.sizeOf(context).height;

  static bool getPlatform() => Platform.isAndroid;

  static String enter4DigitSentFrom(String location) {
    return "Enter the 4 digit code we just sent to your $location";
  }

  static String codeHasBeenSentResendIn(int time) {
    return "Code has been sent. You can send another in $time";
  }


  static void hideAnyMountedSnackbar(BuildContext context)
    => ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();


  static int getRandomNumber(double ceiling){
    final int number = Random().nextInt(ceiling.toInt()) + 1;
    if(number < 100){
      return 100 + number;
    }
    return number;
  }


  static startTimer({
    required Timer timer,
    required BuildContext context
  }){
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if(timer.tick == 61){timer.cancel();}
        else{
          // context.read<AmptiveAuthBloc>().add(
          //   ResendOTPCountDownTimerAuthEvent(countDownTime: timer.tick)
          // );
        }
        
      }
    );
  }


  static Timer? _debounce;
  static void callDebouncer(int duration, Function func, [List<dynamic>? args]) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(
      Duration(milliseconds: duration),
      () {
        if (args != null) {Function.apply(func, args);}
        else {func();}
      }
    );
  }

  static void disposeDebouncer() {
    _debounce?.cancel();
  } 


  static T? safeGetElementFromList<T>(List<T> list, int index) {
    if (index >= 0 && index < list.length) {
      return list[index];
    }
    return null;
  }



static List<String> generateHoursInADay(dynamic _) {
  final List<String> timeList = [];

  for (int index = 0; index < 24; index++) {
    DateTime time = DateTime(2025, 3, 12, index);

    String formattedTime = DateFormat('hh:00 a').format(time).toLowerCase();

    timeList.add(formattedTime);
  }

  return timeList;
}



  static List<List<DateTime?>> getWeeksInAMonth(List<int> args) {
    final year = args[0];
    final month = args[1];

    final firstDayOfMonth = DateTime(year, month, 1);

    final firstWeekday = firstDayOfMonth.weekday % 7;

    final daysInMonth = DateTime(year, month + 1, 0).day;

    final allDays = List<DateTime>.generate(
      daysInMonth,
      (index) => DateTime(year, month, index + 1),
    );

    final List<List<DateTime?>> weeks = [];

    if (firstWeekday != 0) {
      final firstWeek = List<DateTime?>.filled(7, null);
      for (int i = firstWeekday; i < 7; i++) {
        if (allDays.isNotEmpty) {
          firstWeek[i] = allDays.removeAt(0);
        }
      }
      weeks.add(firstWeek);
    }

    while (allDays.isNotEmpty) {
      final week = List<DateTime?>.filled(7, null);
      for (int i = 0; i < 7; i++) {
        if (allDays.isNotEmpty) {
          week[i] = allDays.removeAt(0);
        }
      }
      weeks.add(week);
    }

    return weeks;
  }


  static Map<String, List<List<DateTime?>>> generateCalendarData(List<int> args) {
    final year = args[0];
    final month = args[1];

    int getDaysInMonth(int year, int month) {
      return DateTime(year, month + 1, 0).day;
    }

    int getFirstWeekday(int year, int month) {
      return DateTime(year, month, 1).weekday % 7;
    }

    List<List<DateTime?>> generateCalendarDays(int year, int month) {
      final daysInMonth = getDaysInMonth(year, month);
      final firstWeekday = getFirstWeekday(year, month);

      List<List<DateTime?>> calendarWeeks = [];
      List<DateTime?> currentWeek = [];

      for (int i = 0; i < firstWeekday; i++) {
        currentWeek.add(null);
      }

      for (int day = 1; day <= daysInMonth; day++) {
        currentWeek.add(DateTime(year, month, day));

        if (currentWeek.length == 7) {
          calendarWeeks.add(currentWeek);
          currentWeek = [];
        }
      }

      if (currentWeek.isNotEmpty) {
        while (currentWeek.length < 7) {
          currentWeek.add(null);
        }
        calendarWeeks.add(currentWeek);
      }

      return calendarWeeks;
    }

    String getMonthName(int year, int month) {
      final date = DateTime(year, month);
      return DateFormat('MMMM').format(date);
    }

    final monthName = getMonthName(year, month);
    final calendarDays = generateCalendarDays(year, month);

    return {monthName: calendarDays};
  }

  static Future<File?> getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  static Future<File?> getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }



  static Map<String, List<List<Map<DateTime?, List<CalenderProgram>>>>> transformDateTimes2Programs(List<dynamic> args) {

    final date = args[0] as Map<String, List<List<DateTime?>>>;
    final name = args[1] as String;
    final isEvent = args[2] as bool;
    final Random random = Random();

    return date.map((key, value) {
      final transformedValue = value.map((week) {
        return week.map((dateTime) {
          final programs = List.generate(
            random.nextInt(3),
            (_) => CalenderProgram(
              name: name, id: 1, isEvent: isEvent,
              isPaid: false, eventType: 'Comedy',
              hosts: getHostList().take(3).toList(),
              dateTime: dateTime,
            ),
          );

          return {dateTime: programs};
        }).toList();
      }).toList();

      return MapEntry(key, transformedValue);
    });
  }
}