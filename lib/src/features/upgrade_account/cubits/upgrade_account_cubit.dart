import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/profile/data/models/request/upgrade_account_data.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo_impl.dart';
import 'package:amptive/src/features/upgrade_account/presentation/screens/select_acct_type_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum UpgradeAccountStage {
  categorySelected(ATStrings.categorySelected),
  //Creator
  subscriptionFeeSetup(ATStrings.subFeeSetUp),
  coHostFeeSetup(ATStrings.cohostFeeSetup),
  //Business
  settingUpAccount(ATStrings.settingUpAcct),
  almostThere(ATStrings.almostThere);

  const UpgradeAccountStage(this.value);

  final String value;
}

class UpgradeAccountCubit extends Cubit<ATAppState<UpgradeAccountStage>> {
  UpgradeAccountCubit({ProfileRepo? mockProfileRepo})
      : profileRepo = mockProfileRepo ?? ProfileRepoImpl(),
        super(const InitialState<UpgradeAccountStage>());

  final ProfileRepo profileRepo;
  bool _cancelStagesFuture = false;

  Future<void> upgradeAccount({
    required UpgradeProfileData param,
  }) async {
    _cancelStagesFuture = false;

    try {
      await Future.wait<void>(
        <Future<void>>[
          _runUpgradeStages(
            param.accountType ?? AccountType.creator),
          _performUpgrade(param),
        ],
        eagerError: true,
      );

      emit(const SuccessState<UpgradeAccountStage>());
    } catch (e) {
      _cancelStagesFuture = true;
      emit(FailureState<UpgradeAccountStage>(e.toString()));
    }
  }

  Future<void> _runUpgradeStages(AccountType acctType) async {
    final List<UpgradeAccountStage> stages = <UpgradeAccountStage>[
          UpgradeAccountStage.categorySelected,

          if (acctType == AccountType.creator) ...<UpgradeAccountStage>[
            UpgradeAccountStage.subscriptionFeeSetup,
            UpgradeAccountStage.coHostFeeSetup,
          ] else ...<UpgradeAccountStage>[
            UpgradeAccountStage.settingUpAccount,
            UpgradeAccountStage.almostThere,
          ],

          UpgradeAccountStage.categorySelected,
        ];

    for (int i = 0; i < stages.length; i++) {
      if (_cancelStagesFuture) return;

      emit(
        LoadingState<UpgradeAccountStage>(
          currentData: stages[i],
        ),
      );

      if (i < stages.length - 1) {
        await Future<void>.delayed(
          const Duration(seconds: 3),
        );
      }
    }
  }

  Future<void> _performUpgrade(UpgradeProfileData param) async {
    final ApiResponse<dynamic> response =
        await profileRepo.upgradeAccount(param: param);

    await response.when<Future<void>>(
      successful: (Successful<dynamic> data) async {
        if (data.data == null) return;
      },
      unSuccessful: (Unsuccessful<dynamic> error) async {
        throw error.error.message;
      },
    );
  }
}
