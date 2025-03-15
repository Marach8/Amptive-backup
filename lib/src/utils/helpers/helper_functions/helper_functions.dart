import 'dart:async';
import 'package:flutter/material.dart';


class ATHelperFuncs{
  const ATHelperFuncs._();

  static double getScreenWidth(BuildContext context)
    => MediaQuery.sizeOf(context).width;

  static double getScreenHeight(BuildContext context)
    => MediaQuery.sizeOf(context).height;

  static String enter4DigitSentFrom(String location) {
    return "Enter the 4 digit code we just sent to your $location";
  }

  static String codeHasBeenSentResendIn(int time) {
    return "Code has been sent. You can send another in $time";
  }


  static void hideAnyMountedSnackbar(BuildContext context)
    => ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();


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



  static List<List<DateTime>> getWeeksInAMonth({required int year, required int month}) {
    List<DateTime> allDays = [];
    int daysInMonth = DateTime(year, month + 1, 0).day;

    for (int i = 1; i <= daysInMonth; i++) {
      allDays.add(DateTime(year, month, i));
    }

    List<List<DateTime>> weekChunks = [];
    for (var i = 0; i < allDays.length; i += 7) {
      weekChunks.add(
        allDays.sublist(i, (i + 7) > allDays.length ? allDays.length : i + 7)
      );
    }

    return weekChunks;
  }
}