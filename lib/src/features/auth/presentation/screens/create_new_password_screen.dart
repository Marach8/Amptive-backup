import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/login_cubit.dart';
import 'package:amptive/src/features/auth/cubits/reset_password_cubit.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/app_bar_widget.dart';

class CreateNewPasswordScreenParams {
  CreateNewPasswordScreenParams({required this.email,  this.title});

  final String? email, title;
}

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key, required this.params});
  
  final CreateNewPasswordScreenParams params;

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen>
    with ATValidators {
  final TextEditingController _pswrdCntrl = TextEditingController();
  final TextEditingController _confirmpswrdCntrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<(bool, bool)> _btnNotifier =
      ValueNotifier<(bool, bool)>((false, false));
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _pswrdCntrl.addListener(() {
      if (_pswrdCntrl.text.length >= 8) {
        _btnNotifier.value = (true, _btnNotifier.value.$2);
      } else {
        _btnNotifier.value = (false, _btnNotifier.value.$2);
      }
    });

    _confirmpswrdCntrl.addListener(() {
      if (_confirmpswrdCntrl.text.length >= 8) {
        _btnNotifier.value = (_btnNotifier.value.$1, true);
      } else {
        _btnNotifier.value = (_btnNotifier.value.$1, false);
      }
    });
  }

  @override
  void dispose() {
    _pswrdCntrl.dispose();
    _confirmpswrdCntrl.dispose();
    _btnNotifier.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResetPasswordCubit>(
      create: (_) => ResetPasswordCubit(),
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar: ATAppBar(
            leading: const ATBackBtn(),
            titleText: widget.params.title ?? '',
          ),
          body: BlocConsumer<ResetPasswordCubit, ATAppState<String>>(
            listener: (BuildContext context, ATAppState<dynamic> state) {
              if (state is SuccessState<String>) {
                context.goNamed(ATRoutes.temporaryLoginScreen);
              } else if (state is FailureState) {
                showAppNotification2(context: context, text: state.message);
              }
            },
            builder: (BuildContext context, ATAppState<dynamic> state) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          ATStrings.createNewPassword,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        ATTextFormField(
                            controller: _pswrdCntrl,
                            //hintText: ATStrings.enterYourEmailOrUsername,
                            validator: validatePassword,
                            obscureText: _passwordVisible,
                            maxLines: 1,
                            prefixIcon: const SizedBox(width: 10),
                            suffixIcon: IconButton(
                                icon: Padding(
                                  padding: EdgeInsets.only(right: 16.0.w),
                                  child: Icon(
                                    _passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: ATColors.white,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                })),
                        const SizedBox(height: 30),
                        Text(
                          ATStrings.confirmPassword,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        ATTextFormField(
                            controller: _confirmpswrdCntrl,
                            //hintText: ATStrings.enterYourPassword,
                            validator: (String? value) {
                              if (value != _pswrdCntrl.text) {
                                return ATStrings.passwordsDoNotMatch;
                              }
                              return null;
                            },
                            prefixIcon: const SizedBox(width: 10),
                            obscureText: _passwordVisible,
                            maxLines: 1,
                            suffixIcon: IconButton(
                                icon: Padding(
                                  padding: EdgeInsets.only(right: 16.0.w),
                                  child: Icon(
                                    _passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: ATColors.white,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                })),
                      ]),
                ),
              );
            },
          ),
          bottomSheet: Builder(
            builder: (BuildContext context) {
              final double bottom = MediaQuery.viewInsetsOf(context).bottom;
              final double bottomPadding = bottom == 0 ? 50 : 10;
              final ATAppState<String> cubitState =
                  context.watch<ResetPasswordCubit>().state;
              final bool isLoading = cubitState is LoadingState<String>;

              return Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, bottomPadding),
                child: ValueListenableBuilder<(bool, bool)>(
                  valueListenable: _btnNotifier,
                  builder: (_, (bool, bool) value, __) {
                    final bool enable = value.$1 && value.$2 && !isLoading;
                    return ATPlainElevatedBtn(
                      isLoading: isLoading,
                      onPressed: enable
                          ? () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context
                                    .read<ResetPasswordCubit>()
                                    .resetPassword(
                                  param: <String, dynamic>{
                                    'email': widget.params.email,
                                    'new_password': _pswrdCntrl.text.trim(),
                                    'confirm_new_password':
                                        _confirmpswrdCntrl.text.trim(),
                                  },
                                );
                              }
                            }
                          : null,
                      btnTitle: ATStrings.finish,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
