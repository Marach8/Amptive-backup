import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/check_identity_availability_cubit.dart';
import 'package:amptive/src/features/auth/data/models/request/registration_data.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddUsernameScreen extends StatefulWidget {
  const AddUsernameScreen({super.key});

  @override
  State<AddUsernameScreen> createState() => _AddUsernameScreenState();
}

class _AddUsernameScreenState extends State<AddUsernameScreen>
    with ATValidators {
  final TextEditingController _userNameCntrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _userNameCntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckIdentityAvailabilityCubit>(
      create: (_) => CheckIdentityAvailabilityCubit(),
      child: Builder(builder: (BuildContext context) {
        return ATAnnotatedRegion(
          child: Scaffold(
            appBar: const ATAppBar(leading: ATBackBtn()),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(ATStrings.whatShouldWeCallYou,
                        style: context.textTheme.headlineMedium),
                    ATTextFormField(
                        controller: _userNameCntrl,
                        maxLines: 1,
                        hintText: ATStrings.userName,
                        fillColor: ATColors.hex9E9E9E.withValues(alpha: 0.3),
                        keyboardType: TextInputType.text,
                        autoValidateMode: AutovalidateMode.disabled,
                        validator: validateField,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 8),
                          child: Text(
                            ATStrings.emailSymbol,
                            style: context.textTheme.headlineMedium,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: BlocConsumer<CheckIdentityAvailabilityCubit,
                                  ATAppState<bool>>(
                              listener: (_, ATAppState<bool> state) {
                                if (state is FailureState<bool>) {
                                  showAppNotification2(
                                    context: context,
                                    text: state.message,
                                    type: NotificationType.failure,
                                  );
                                }
                              },
                              builder: (_, ATAppState<bool> state) =>
                                  switch (state) {
                                    InitialState<bool>() =>
                                      const SizedBox.shrink(),
                                    LoadingState<bool>() =>
                                      const ATLoadingIndicator(
                                        size: 20,
                                      ),
                                    SuccessState<bool>() => Icon(
                                        Icons.check,
                                        color: ATColors.successColor,
                                      ),
                                    FailureState<bool>() => Icon(
                                        Icons.close,
                                        color: ATColors.textRedColor,
                                      )
                                  }),
                        ),
                        onChanged: (String text) {
                          ATHelperFuncs.callDebouncer(
                              1500,
                              () => context
                                      .read<CheckIdentityAvailabilityCubit>()
                                      .checkIdentityAvailability(
                                          param: <String, dynamic>{
                                        'username': text
                                      }));
                        }),
                    BlocBuilder<CheckIdentityAvailabilityCubit,
                        ATAppState<bool>>(builder: (_, ATAppState<bool> state) {
                      if (state is InitialState<bool>) {
                        return const SizedBox.shrink();
                      }
                      final bool isLoading = state is LoadingState<bool>;
                      final bool isSuccess = state is SuccessState<bool>;
                      return Text(
                        isLoading
                            ? ATStrings.checkerLoading
                            : isSuccess
                                ? ATStrings.usernameIsAvailable
                                : 'Username not available!',
                        style: context.textTheme.titleSmall?.copyWith(
                          color: isSuccess
                              ? ATColors.successColor
                              : isLoading
                                  ? ATColors.white
                                  : ATColors.textRedColor,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            bottomSheet: Builder(builder: (BuildContext context) {
              final double bottom = MediaQuery.viewInsetsOf(context).bottom;
              final double bottomPad = bottom > 0 ? 10 : 50;
              return Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, bottomPad),
                child: BlocBuilder<CheckIdentityAvailabilityCubit,
                    ATAppState<bool>>(builder: (_, ATAppState<bool> state) {
                  final bool shouldEnableBtn = state is SuccessState<bool>;
                  return ATPlainElevatedBtn(
                      onPressed: shouldEnableBtn
                          ? () {
                              if (_formKey.currentState?.validate() ?? false) {
                                RegistrationData().copyWith(
                                    username: _userNameCntrl.text.trim());
                                context.pushNamed(ATRoutes.addNameAuthScreen);
                              }
                            }
                          : null,
                      btnTitle: ATStrings.next);
                }),
              );
            }),
          ),
        );
      }),
    );
  }
}
