import 'package:amptive/src/bloc/main_app/go_live_bloc/audience_view/following_bloc.dart';
import 'package:amptive/src/bloc/main_app/go_live_bloc/audience_view/subscription_bloc.dart';
import 'package:amptive/src/bloc/preference/bloc.dart';
import 'package:amptive/src/services/auth/auth_field_service.dart';
import 'package:amptive/src/services/auth/otp_service.dart';
import 'package:amptive/src/services/authentication_service.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/services/go_live_service/go_live_service.dart' hide getHostList;
import 'package:amptive/src/services/preference_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/single_child_widget.dart';
import 'bloc/authentication/email/email_auth_bloc.dart';
import 'bloc/authentication/general/auth_bloc.dart';
import 'bloc/authentication/otp/otp_auth_bloc.dart';
import 'bloc/authentication/password/password_auth_bloc.dart';
import 'bloc/main_app/go_live_bloc/host_view/available_cohosts_bloc.dart';
import 'bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import 'bloc/main_app/go_live_bloc/host_view/host_end_show_bloc.dart';
import 'bloc/main_app/go_live_bloc/host_view/notifications_bloc.dart';
import 'bloc/main_app/nav_bar_bloc.dart';
import 'bloc/onboarding_bloc/onboarding_bloc.dart';

void setup() {
  // setup: register services
  GetIt.I.registerSingleton<OtpService>(OtpService());
  GetIt.I.registerSingleton<AuthFieldService>(AuthFieldService());
  GetIt.I.registerSingleton<AuthenticationService>(AuthenticationService());
  GetIt.I.registerSingleton<PreferenceService>(PreferenceService());
  GetIt.I.registerSingleton<CreateShowService>(CreateShowService());
  GetIt.I.registerSingleton<GoLiveService>(GoLiveService());
}

List<SingleChildWidget> providers() {
  return [
    BlocProvider(create: (_) => AmptiveOnboardingBloc()),
    BlocProvider(create: (_) => AmptiveAuthBloc()),
    BlocProvider(create: (_) => AmptiveEmailAuthBloc()),
    BlocProvider(create: (_) => AmptiveOTPAuthBloc()),
    BlocProvider(create: (_) => AmptivePasswordAuthBloc()),
    BlocProvider(create: (_) => AmptivePreferenceBloc()),
    BlocProvider(create: (_) => AmptiveNavBarBloc()),
    BlocProvider(create: (_) => AmptiveGoLiveSelectCoHostBloc()),
    BlocProvider(create: (_) => AmptiveGoLiveAvailableCoHostsBloc(hostList: getHostList())),
    BlocProvider(create: (_) => AmptiveGoLiveNotificationBloc()),
    BlocProvider(create: (_) => AmptiveFollowingBloc()),
    BlocProvider(create: (_) => AmptiveSubscriptionBloc()),
    BlocProvider(create: (_) => AmptiveEndShowBloc()),
  ];
}
