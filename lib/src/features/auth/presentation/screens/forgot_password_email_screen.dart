import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/password_reset_otp_cubit.dart';
import 'package:amptive/src/features/auth/presentation/screens/create_new_password_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/reset_password_otp_screen.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/app_bar_widget.dart';

class ATForgotPasswordEmailScreen extends StatefulWidget {
  const ATForgotPasswordEmailScreen({super.key, this.title});
  final String? title;

  @override
  State<ATForgotPasswordEmailScreen> createState() =>
      _ATForgotPasswordEmailScreenState();
}

class _ATForgotPasswordEmailScreenState extends State<ATForgotPasswordEmailScreen> with ATValidators {
  final TextEditingController _emailCntrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _btnNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _emailCntrl.addListener(() {
      final bool isValid = validateEmail(_emailCntrl.text) == null;
      _btnNotifier.value = isValid;
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
  Widget build(BuildContext context) {
    return BlocProvider<PasswordResetOtpCubit>(
      create: (_) => PasswordResetOtpCubit(),
      child: Builder(
        builder: (BuildContext context) {
          return ATAnnotatedRegion(
            child: Scaffold(
              appBar: ATAppBar(
                leading: const ATBackBtn(),
                titleText: widget.title ?? ATStrings.forgotPassword
              ),
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ATStrings.whatIsYourEmail,
                        style: context.textTheme.headlineMedium
                      ),
                      const SizedBox(height: 10),
                      ATTextFormField(
                        controller: _emailCntrl,
                        maxLines: 1,
                        hintText: ATStrings.enterYourEmail,
                        fillColor: ATColors.hex9E9E9E.withValues(alpha: 0.3),
                        prefixIcon: const SizedBox(width: 10,),
                        keyboardType: TextInputType.emailAddress,
                        autoValidateMode: AutovalidateMode.disabled,
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 6,),
                    ],
                  ),
                ),
              ),
              bottomSheet: Builder(
                builder: (BuildContext context) {
                  final double bottom = MediaQuery.viewInsetsOf(context).bottom;
                  final double bottomPad = bottom > 0 ? 10 : 50;
                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, bottomPad),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _btnNotifier,
                      builder: (_, bool isValid, __) {
                        return BlocConsumer<PasswordResetOtpCubit, ATAppState<String>>(
                          listener: (_, ATAppState<String> state)  async{
                            if (state is SuccessState<String>) {
                              final bool? didVerifyOTP = await 
                              context.pushNamed(
                                ATRoutes.PASSWORD_RESET_OTP_SCREEN,
                                extra: VerifyPasswordResetOTPScreenParams(
                                  identifier: _emailCntrl.text.trim(),
                                  title: ATStrings.forgotPassword,
                                  verificationType: OTPVerificationType.email,
                                  otp: state.newData,
                                  
                                ),
                              );

                              if(context.mounted && didVerifyOTP == true){
                                context.pushNamed(ATRoutes.createNewPAsswordScreen,
                                extra: CreateNewPasswordScreenParams(email: _emailCntrl.text.trim(),
                                title: ATStrings.forgotPassword));
                              }
                            } else if (state is FailureState<String>) {
                              showAppNotification2(
                                context: context,
                                text: state.message,
                                type: NotificationType.failure,
                              );
                            }
                          },
                          builder: (BuildContext context, ATAppState<String> state) {
                            return ATPlainElevatedBtn(
                              isLoading: state is LoadingState<String>,
                              onPressed: isValid
                                  ? () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        context.read<PasswordResetOtpCubit>()
                                          .resetPasswordOtp(param: <String, dynamic>{'email': _emailCntrl.text.trim()});
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
                }
              ),
            ),
          );
        }
      ),
    );
  }
}
