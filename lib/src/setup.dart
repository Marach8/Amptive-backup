import 'package:amptive/src/services/auth/auth_field_service.dart';
import 'package:amptive/src/services/auth/otp_service.dart';
import 'package:amptive/src/services/authentication_service.dart';
import 'package:amptive/src/services/preference_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/single_child_widget.dart';

import 'bloc/authentication/email/email_auth_bloc.dart';
import 'bloc/authentication/general/auth_bloc.dart';
import 'bloc/authentication/otp/otp_auth_bloc.dart';
import 'bloc/authentication/password/password_auth_bloc.dart';
import 'bloc/onboarding_bloc/onboarding_bloc.dart';

void setup() {
  // setup: register services
  GetIt.I.registerSingleton<OtpService>(OtpService());
  GetIt.I.registerSingleton<AuthFieldService>(AuthFieldService());
  GetIt.I.registerSingleton<AuthenticationService>(AuthenticationService());
  GetIt.I.registerSingleton<PreferenceService>(PreferenceService());

}

List<SingleChildWidget> providers() {
  return [
    BlocProvider(create: (_) => AmptiveOnboardingBloc()),
    BlocProvider(create: (_) => AmptiveAuthBloc()),
    BlocProvider(create: (_) => AmptiveEmailAuthBloc()),
    BlocProvider(create: (_) => AmptiveOTPAuthBloc()),
    BlocProvider(create: (_) => AmptivePasswordAuthBloc()),
  ];
}
