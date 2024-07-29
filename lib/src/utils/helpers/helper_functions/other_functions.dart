import 'dart:async';

import 'package:amptive/src/bloc/authentication_bloc/auth_bloc.dart';
import 'package:amptive/src/bloc/authentication_bloc/auth_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmptiveHelperFunctions{
  const AmptiveHelperFunctions._();

  static double getScreenWidth(BuildContext context)
    => MediaQuery.of(context).size.width;

  static double getScreenHeight(BuildContext context)
    => MediaQuery.of(context).size.height;

  static startTimer({
    required Timer timer,
    required BuildContext context
  }){
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if(timer.tick == 61){timer.cancel();}
        else{
          context.read<AmptiveAuthBloc>().add(
            ResendOTPCountDownTimerAuthEvent(countDownTime: timer.tick)
          );
        }
        
      }
    );
  }
}