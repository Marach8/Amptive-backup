import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/profile/presentation/screens/profile_views_export.dart';
import 'package:amptive/src/features/profile/presentation/widgets/creator_profile_view.dart';
import 'package:amptive/src/features/upgrade_account/presentation/screens/select_acct_type_screen.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleIconsColor extends Cubit<bool> {
  ToggleIconsColor() : super(false);

  void changeIconColor(bool shouldChange) 
    => emit(shouldChange);
}

class MainProfileScreen extends StatelessWidget {
  const MainProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ToggleIconsColor>(
      create: (_) => ToggleIconsColor(),
      child: ATAnnotatedRegion(
        statusBarColor: ATColors.transparent,
        child: Scaffold(
          body: BlocSelector<LocalUserDataCubit,
            ATAppState<ProfileData>, AccountType?>(
            selector: (ATAppState<ProfileData> state) 
              => context.read<LocalUserDataCubit>()
                .currentUserData?.accountType,
            builder: (_, AccountType? accountType) {
              return switch(accountType){
                AccountType.creator ||
                AccountType.business 
                  => const CreatorProfileView(),
                AccountType.regular || null
                  => const UserProfileView(),
              };
            }
          ),
        ),
      ),
    );
  }
}
