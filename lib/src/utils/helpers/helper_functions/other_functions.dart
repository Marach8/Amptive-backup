import 'dart:async';
import 'package:flutter/material.dart';


class ATHelperFuncs{
  const ATHelperFuncs._();

  static double getScreenWidth(BuildContext context)
    => MediaQuery.sizeOf(context).width;

  static double getScreenHeight(BuildContext context)
    => MediaQuery.sizeOf(context).height;


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
}