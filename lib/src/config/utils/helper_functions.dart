import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:amptive/src/features/calender/cubits/calender_programs_bloc.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';


class ATHelperFuncs{
  const ATHelperFuncs._();

  static double getScreenWidth(BuildContext context)
    => MediaQuery.sizeOf(context).width;

  static double getScreenHeight(BuildContext context)
    => MediaQuery.sizeOf(context).height;

  static bool platformIsAndroid() => Platform.isAndroid;

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

  static void startTimer({
    required Timer timer,
    required BuildContext context
  }){
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
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
    final List<String> timeList = <String>[];

    for (int index = 0; index < 24; index++) {
      DateTime time = DateTime(2025, 3, 12, index);

      String formattedTime = DateFormat('hh:00 a').format(time).toLowerCase();

      timeList.add(formattedTime);
    }

    return timeList;
  }



  static List<List<DateTime?>> getWeeksInAMonth(List<int> args) {
    final int year = args[0];
    final int month = args[1];

    final DateTime firstDayOfMonth = DateTime(year, month, 1);

    final int firstWeekday = firstDayOfMonth.weekday % 7;

    final int daysInMonth = DateTime(year, month + 1, 0).day;

    final List<DateTime> allDays = List<DateTime>.generate(
      daysInMonth,
      (int index) => DateTime(year, month, index + 1),
    );

    final List<List<DateTime?>> weeks = <List<DateTime?>>[];

    if (firstWeekday != 0) {
      final List<DateTime?> firstWeek = List<DateTime?>.filled(7, null);
      for (int i = firstWeekday; i < 7; i++) {
        if (allDays.isNotEmpty) {
          firstWeek[i] = allDays.removeAt(0);
        }
      }
      weeks.add(firstWeek);
    }

    while (allDays.isNotEmpty) {
      final List<DateTime?> week = List<DateTime?>.filled(7, null);
      for (int i = 0; i < 7; i++) {
        if (allDays.isNotEmpty) {
          week[i] = allDays.removeAt(0);
        }
      }
      weeks.add(week);
    }

    return weeks;
  }


  static String formatDate(String isoString) {
    final DateTime parsed = DateTime.parse(isoString);
    final DateFormat formatter = DateFormat('d MMMM yyyy');
    return formatter.format(parsed);
  }


  static Map<String, List<List<DateTime?>>> generateCalendarData(List<int> args) {
    final int year = args[0];
    final int month = args[1];

    int getDaysInMonth(int year, int month) {
      return DateTime(year, month + 1, 0).day;
    }

    int getFirstWeekday(int year, int month) {
      return DateTime(year, month, 1).weekday % 7;
    }

    List<List<DateTime?>> generateCalendarDays(int year, int month) {
      final int daysInMonth = getDaysInMonth(year, month);
      final int firstWeekday = getFirstWeekday(year, month);

      List<List<DateTime?>> calendarWeeks = <List<DateTime?>>[];
      List<DateTime?> currentWeek = <DateTime?>[];

      for (int i = 0; i < firstWeekday; i++) {
        currentWeek.add(null);
      }

      for (int day = 1; day <= daysInMonth; day++) {
        currentWeek.add(DateTime(year, month, day));

        if (currentWeek.length == 7) {
          calendarWeeks.add(currentWeek);
          currentWeek = <DateTime?>[];
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
      final DateTime date = DateTime(year, month);
      return DateFormat('MMMM').format(date);
    }

    final String monthName = getMonthName(year, month);
    final List<List<DateTime?>> calendarDays = generateCalendarDays(year, month);

    return <String, List<List<DateTime?>>>{monthName: calendarDays};
  }


  static Future<XFile?> pickImage(ImageSource? imageSource) async{
    if(imageSource == null) return null;

    Permission? permission;

    if(imageSource == ImageSource.camera){
      permission = Permission.camera;
    }
    else{
      if (Platform.isAndroid) {
        final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          permission = Permission.storage;
        }
        else{
          permission = Permission.photos;
        }
      }
      else{
        permission = Permission.photos;
      } 
    }

    final PermissionStatus permStatus = await permission.request();
    if(permStatus == PermissionStatus.permanentlyDenied){
      openAppSettings();
      return null;
    }
    else if (!permStatus.isGranted){
      return null;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: imageSource);

    // if (pickedFile != null) {
    //   final file = File(pickedFile.path);
    //   final sizeInBytes = await file.length();
    //   final sizeInKB = sizeInBytes / 1024;
    //   final sizeInMB = sizeInKB / 1024;
    //   log(sizeInMB.toString());
    // }

    return pickedFile;
  }


  static Future<PermissionStatus> requestUserPermission(Permission permType) async {
    PermissionStatus status = await permType.status;

    if (status.isGranted || status.isPermanentlyDenied || status.isRestricted) {
      return status;
    }

    return await permType.request();
  }


  static Future<File?> getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  static Future<File?> getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }



  static Map<String, List<List<Map<DateTime?, List<CalenderProgram>>>>>
    transformDateTimes2Programs(List<dynamic> args) {

    final Map<String, List<List<DateTime?>>> date = args[0] as Map<String, List<List<DateTime?>>>;
    final String name = args[1] as String;
    final bool isEvent = args[2] as bool;
    final Random random = Random();

    return date.map((String key, List<List<DateTime?>> value) {
      final List<List<Map<DateTime?, List<CalenderProgram>>>> transformedValue = value.map((List<DateTime?> week) {
        return week.map((DateTime? dateTime) {
          final List<CalenderProgram> programs = List.generate(
            random.nextInt(3),
            (_) => CalenderProgram(
              name: name, id: 1, isEvent: isEvent,
              isPaid: false, eventType: 'Comedy',
              hosts: getHostList().take(3).toList(),
              dateTime: dateTime,
            ),
          );

          return <DateTime?, List<CalenderProgram>>{dateTime: programs};
        }).toList();
      }).toList();

      return MapEntry(key, transformedValue);
    });
  }
}
