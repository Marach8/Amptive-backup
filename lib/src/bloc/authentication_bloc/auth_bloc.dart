import 'package:amptive/src/bloc/authentication_bloc/auth_events.dart';
import 'package:amptive/src/bloc/authentication_bloc/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmptiveAuthBloc extends Bloc<AmptiveAuthEvent, AmptiveAuthState>{
  AmptiveAuthBloc(): super(
    MainAuthState()
    //InitialAuthState()
  ){

    on<GetTheCurrentTextOnTheEmailFieldAuthEvent>(
      (event, emit){
        final currentTextEntered = event.currentTextOnTheEmailField;

        emit(MainAuthState(userEmail: currentTextEntered));
      }
    );

    on<ResendOTPCountDownTimerAuthEvent>(
      (event, emit){
        final countDownTime = event.countDownTime;

        emit(MainAuthState(resendOTPCountDown: countDownTime));
      }
    );

    on<OTPFieldIsCompletedAuthEvent>(
      (event, emit){
        final userOTPInput = event.otpInputFromUser;
        final currentState = state as MainAuthState;

        emit(currentState.copyWith(otpInputFromUser: userOTPInput));
      }
    );

    on<HideOrShowPasswordAuthEvent>(
      (_, emit){
        final hideOrShow = state.hidePassword ?? false;
        final currentState = state as MainAuthState;

        emit(currentState.copyWith(hidePassword: !hideOrShow));
      }
    );

    on<GetTheCurrentTextOnThePaaswordFieldAuthEvent>(
      (event, emit){
        final currentState = state as MainAuthState;
        final currentUserPasswordInput = event.currentTextOnThePasswordField;

        emit(currentState.copyWith(userPassword: currentUserPasswordInput));
      }
    );
  }
}