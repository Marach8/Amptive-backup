import 'package:amptive/src/bloc/main_app/go_live_bloc/audience_view/following_bloc.dart';
import 'package:amptive/src/bloc/main_app/go_live_bloc/audience_view/subscription_bloc.dart';
import 'package:amptive/src/features/calender/cubits/calender_month_view_bloc.dart';
import 'package:amptive/src/features/calender/cubits/calender_visibile_bloc.dart';
import 'package:amptive/src/features/calender/cubits/calender_views_bloc.dart';
import 'package:amptive/src/features/calender/cubits/day_view_bloc.dart';
import 'package:amptive/src/bloc/preference/bloc.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/services/auth/auth_field_service.dart';
import 'package:amptive/src/services/auth/otp_service.dart';
import 'package:amptive/src/services/authentication_service.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/services/go_live_service/go_live_service.dart' hide getHostList;
import 'package:amptive/src/services/preference_service.dart';
import 'package:amptive/src/features/profile/bloc/profile_bloc_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/single_child_widget.dart';
import '../bloc/authentication/email/email_auth_bloc.dart';
import '../bloc/authentication/general/auth_bloc.dart';
import '../bloc/authentication/otp/otp_auth_bloc.dart';
import '../bloc/authentication/password/password_auth_bloc.dart';
import '../bloc/main_app/go_live_bloc/audience_view/host_moderation_control_bloc.dart';
import '../bloc/main_app/go_live_bloc/host_view/available_cohosts_bloc.dart';
import '../bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import '../bloc/main_app/go_live_bloc/host_view/host_end_show_bloc.dart';
import '../bloc/main_app/go_live_bloc/host_view/notifications_bloc.dart';
import '../bloc/main_app/profile/private_account_bloc.dart';
import '../bloc/main_app/profile/profile_followers_bloc.dart';
import '../features/calender/cubits/calender_programs_bloc.dart';
import '../features/auth/cubits/register_user_cubit.dart';
import '../features/calender/cubits/selected_calender_date_bloc.dart';
import '../bloc/main_app/profile/profile_menu/language_bloc.dart';
import '../bloc/onboarding_bloc/onboarding_bloc.dart';

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
  return <SingleChildWidget>[
    BlocProvider(create: (_) => AmptiveOnboardingBloc()),
    BlocProvider(create: (_) => AmptiveAuthBloc()),
    BlocProvider(create: (_) => ATEmailAuthBloc()),
    BlocProvider(create: (_) => AmptiveOTPAuthBloc()),
    BlocProvider(create: (_) => AmptivePasswordAuthBloc()),
    BlocProvider(create: (_) => AmptivePreferenceBloc()),
    BlocProvider(create: (_) => ATNavBarBloc()),
    BlocProvider(create: (_) => AmptiveGoLiveSelectCoHostBloc()),
    BlocProvider(create: (_) => AmptiveGoLiveAvailableCoHostsBloc(hostList: getHostList())),
    BlocProvider(create: (_) => AmptiveGoLiveNotificationBloc()),
    BlocProvider(create: (_) => AmptiveFollowingBloc()),
    BlocProvider(create: (_) => AmptiveSubscriptionBloc()),
    BlocProvider(create: (_) => AmptiveEndShowBloc()),
    BlocProvider(create: (_) => AmptiveGoLiveHostModerationToolsBloc()),
    BlocProvider(create: (_) => AmptiveProfileFollowersBloc()),
    BlocProvider(create: (_) => CalenderVisibleBloc()),
    BlocProvider(create: (_) => AmptiveLanguageBloc()),
    BlocProvider(create: (_) => PrivateAccountBloc()),
    BlocProvider(create: (_) => CalenderViewsBloc()),
    BlocProvider(create: (_) => SelectedCalenderDateBloc()),
    BlocProvider(create: (_) => CalenderProgramBloc()),
    BlocProvider(create: (_) => CalenderMonthViewBloc()),
    BlocProvider(create: (_) => DayViewHeadingBloc()),
    BlocProvider(create: (_) => HoursInADayBloc()),
    BlocProvider(create: (_) => AcctTypeLandingAnimBloc()),
    BlocProvider(create: (_) => SwitchAcctSuccessAnimBloc()),
    BlocProvider(create: (_) => SubPlanSetupBloc()),
    BlocProvider(create: (_) => CohostFeeSetupBloc()),
    BlocProvider(create: (_) => AccountTypeBloc()),
    BlocProvider(create: (_) => CohostServiceBloc()),
    BlocProvider(create: (_) => HashtagServiceBloc()),
    BlocProvider(create: (_) => RegisterUserCubit())
  ];
}
