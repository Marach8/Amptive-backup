import 'dart:async';
import 'package:flutter/material.dart';


class AmptiveHelperFunctions{
  const AmptiveHelperFunctions._();

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


  static T? safeGetElementFromList<T>(List<T> list, int index) {
    if (index >= 0 && index < list.length) {
      return list[index];
    }
    return null;
  }
}