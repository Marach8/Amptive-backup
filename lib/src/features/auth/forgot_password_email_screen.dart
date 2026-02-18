import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/login_cubit.dart';
import 'package:amptive/src/features/auth/cubits/password_reset_otp_cubit.dart';
import 'package:amptive/src/features/auth/cubits/send_otp_cubit.dart';
import 'package:amptive/src/features/auth/reset_password_otp_screen.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../views/widgets/common_widgets/app_bar_widget.dart';

class ATForgotPasswordEmailScreen extends StatefulWidget {
  const ATForgotPasswordEmailScreen({super.key, this.title});
  final String? title;

  @override
  State<ATForgotPasswordEmailScreen> createState() =>
      _ATForgotPasswordEmailScreenState();
}

class _ATForgotPasswordEmailScreenState
    extends State<ATForgotPasswordEmailScreen> with ATValidators {
  final TextEditingController _emailCntrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<(bool, bool)> _btnNotifier =
      ValueNotifier<(bool, bool)>((false, false));

  @override
  void initState() {
    super.initState();
   _emailCntrl.addListener(() {
  final String text = _emailCntrl.text;
  final bool isValid = validateEmail(text) == null;
  _btnNotifier.value = (isValid, isValid);
});

  }

  @override
  void dispose() {
    _emailCntrl.dispose();
    _btnNotifier.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PasswordResetOtpCubit>(
      create: (_) => PasswordResetOtpCubit(),
      child: Builder(
        builder: (BuildContext context) {
          return ATAnnotatedRegion(
            child: Scaffold(
              appBar: const ATAppBar(
                leading: ATBackBtn(),
                titleText: ATStrings.forgotPassword,
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ATStrings.whatIsYourEmail,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      ATTextFormField(
                        controller: _emailCntrl,
                        hintText: ATStrings.enterYourEmail,
                        validator: validateEmail,
                        prefixIcon: const SizedBox(width: 10),
                      ),
                    ],
                  ),
                ),
              ),
              bottomSheet: Builder(
                builder: (BuildContext context) {
                  final double bottom = MediaQuery.viewInsetsOf(context).bottom;
                  final double bottomPadding = bottom == 0 ? 50 : 10;

                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, bottomPadding),
                    child: ValueListenableBuilder<(bool, bool)>(
                      valueListenable: _btnNotifier,
                      builder: (_, (bool, bool) value, __) {
                        final bool enable = value.$1 && value.$2;
                        return BlocConsumer<PasswordResetOtpCubit, ATAppState<String>>(
                          listener: (_, ATAppState<String> sendOtpState) {
                            if (sendOtpState is SuccessState<String>) {
                              context.pushNamed(
                                ATRoutes.PASSWORD_RESET_OTP_SCREEN,
                                extra: VerifyPasswordResetOTPScreenParams(
                                  identifier: _emailCntrl.text.trim(),
                                  title: ATStrings.forgotPassword,
                                  verificationType: OTPVerificationType.email,
                                ),
                              );
                            } else if (sendOtpState is FailureState<String>) {
                              showAppNotification2(
                                context: context,
                                text: sendOtpState.message,
                                type: NotificationType.failure,
                              );
                            }
                          },
                          builder: (BuildContext context, ATAppState<String> sendOtpState) {
                            return ATPlainElevatedBtn(
                              isLoading: sendOtpState is LoadingState<String>,
                              onPressed: enable
                                  ? () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        context.read<PasswordResetOtpCubit>().resetPasswordOtp(
                                          param: <String, dynamic>{'email': _emailCntrl.text.trim()});
                                      }
                                    }
                                  : null,
                              btnTitle: ATStrings.sendCode,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
