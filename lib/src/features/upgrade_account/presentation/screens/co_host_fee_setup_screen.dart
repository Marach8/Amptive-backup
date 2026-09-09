import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/profile/data/models/profile_data.dart' show ProfileData;
import 'package:amptive/src/features/profile/data/models/request/upgrade_account_data.dart';
import 'package:amptive/src/features/upgrade_account/cubits/upgrade_account_cubit.dart';
import 'package:amptive/src/features/upgrade_account/presentation/widgets/cohost_fee_desc_info.dart';
import 'package:amptive/src/features/upgrade_account/presentation/widgets/row_of_custom_fees.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/progress_stage_loading_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class CoHostFeeSetupScreen extends StatefulWidget {
  const CoHostFeeSetupScreen({super.key});

  @override
  State<CoHostFeeSetupScreen> createState() => _CoHostFeeSetupScreenState();
}

class _CoHostFeeSetupScreenState extends State<CoHostFeeSetupScreen> {
  late final TextEditingController _cntrl = TextEditingController(text: '0');
  bool showInfo = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Future<void>.delayed(const Duration(milliseconds:800), () {
          setState(() => showInfo = true);
        });
      },
    );
  }

  @override
  void dispose() {
    _cntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: BlocConsumer<UpgradeAccountCubit, ATAppState<UpgradeAccountStage>>(
        listener: (_, ATAppState<UpgradeAccountStage> state) {
          if (state is FailureState<UpgradeAccountStage>) {
            showAppNotification2(
                context: context,
                text: state.message,
                type: NotificationType.failure);
          }
      
          if (state is SuccessState<UpgradeAccountStage>) {
            final LocalUserDataCubit localUserCubit = 
              context.read<LocalUserDataCubit>();
            final ProfileData currentData = localUserCubit
              .currentUserData ?? const ProfileData();
            localUserCubit.updateUserDataLocally(
              currentData.copyWith(
                accountType: UpgradeProfileData().accountType)
            );
            
            context.pushNamed(
              ATRoutes.accountUpgradeSuccessScreen,
              extra: UpgradeProfileData().accountType
            );
          }
        },
        builder: (_, ATAppState<UpgradeAccountStage> state) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final Animation<Offset> inAnimation = Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation);
                
                return SlideTransition(position: inAnimation, child: child);
              },
              child: switch (state) {
                LoadingState<UpgradeAccountStage>(
                  :final UpgradeAccountStage? currentData
                ) =>
                  ProgressStageLoadingWidget(
                    key: const ValueKey<String>('LoadingWidget'),
                    stageText: currentData?.value ?? '',
                  ),
                InitialState<UpgradeAccountStage>() ||
                FailureState<UpgradeAccountStage>() ||
                SuccessState<UpgradeAccountStage>() =>
                  Scaffold(
                    key: const ValueKey<String>('coHostFeeSetupScreen'),
                    appBar: const ATAppBar(
                      leadingWidth: 30,
                      leading: ATRoundedBackBtn(),
                      titleText: ATStrings.cohostFeeSetup,
                      padding: EdgeInsets.only(left: 7),
                    ),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            switchInCurve: Curves.easeIn,
                            transitionBuilder: (
                              Widget child,
                              Animation<double> animation,
                            ) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, -0.3),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: showInfo
                                ? CohostFeeDescInfo(
                                    onClose: () =>
                                        setState(() => showInfo = false),
                                    key: const ValueKey<String>('child'),
                                  )
                                : const SizedBox.shrink(
                                    key: ValueKey<String>('empty')),
                          ),
                          ATTextFormField(
                            controller: _cntrl,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            disableBlueBorder: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                ATStrings.nairaText,
                                style: context.textTheme.headlineMedium,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          RowOfCustomFees(
                            onFeeTap: (int tappedFee) {
                              _cntrl.text = tappedFee.toString();
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            ATStrings.freeCohosting,
                            maxLines: 2,
                            style: context.textTheme.titleSmall
                                ?.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    bottomNavigationBar: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 60),
                      child: _BottomSheetContent(cntrl: _cntrl),
                    ),
                  )
              });
        },
      ),
    );
  }
}

class _BottomSheetContent extends StatelessWidget {
  const _BottomSheetContent({required this.cntrl});

  final TextEditingController cntrl;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpgradeAccountCubit, ATAppState<UpgradeAccountStage>>(
      builder: (_, ATAppState<UpgradeAccountStage> state) {
        final bool isLoading = state is LoadingState<UpgradeAccountStage>;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Amptive charges 0% fee on payment from creators',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: context.textTheme.labelSmall?.copyWith(
                color: ATColors.white.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder<TextEditingValue>(
                valueListenable: cntrl,
                builder: (_, TextEditingValue value, __) {
                  final bool shouldActivate =
                      value.text.isNotEmpty && value.text != '0';
                  return ATPlainElevatedBtn(
                      isLoading: isLoading,
                      onPressed: shouldActivate
                        ? () {
                          final int feeValue = int.tryParse(value.text) ?? 0;
                          UpgradeProfileData().copyWith(
                            coHostFee: feeValue,
                          );
                          context.read<UpgradeAccountCubit>()
                            .upgradeAccount(param: UpgradeProfileData());
                        } : null,
                      btnTitle: ATStrings.cContinue);
                }),
            const SizedBox(height: 15),
            InkWell(
              onTap: isLoading ? null : () {
                context.read<UpgradeAccountCubit>()
                  .upgradeAccount(param: UpgradeProfileData());
              },
              radius: 5,
              child: Text(
                ATStrings.setupLater,
                style: context.textTheme.bodyLarge,
              ),
            ),
          ],
        );
      },
    );
  }
}
