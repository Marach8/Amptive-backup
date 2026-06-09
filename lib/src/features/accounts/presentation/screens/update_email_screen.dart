import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/send_otp_cubit.dart';
import 'package:amptive/src/features/auth/data/models/response/user_profile_response_model.dart';
import 'package:amptive/src/features/auth/presentation/screens/otp_screen.dart' hide OTPVerificationType;
import 'package:amptive/src/features/profile/cubits/remote_user_data_cubit.dart';
import 'package:amptive/src/features/profile/cubits/update_email_and_phone_number_cubit.dart';
import 'package:amptive/src/features/profile/presentation/screens/update_email_and_phone_no_otp_screen.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'dart:async';

class UpdateEmailScreen extends StatefulWidget {
  const UpdateEmailScreen({super.key, required this.title});
  final String title;

  @override
  State<UpdateEmailScreen> createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen>
    with ATValidators {
  final TextEditingController _controller = TextEditingController();
  final StreamController<bool> _activateButtonCntrl = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      ATHelperFuncs.callDebouncer(
          500,
          () => _activateButtonCntrl.add(
                validateEmail(_controller.text) == null,
              ));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _activateButtonCntrl.close();
    ATHelperFuncs.disposeDebouncer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isChangingEmail = widget.title == ATStrings.CHANGING_EMAIL;

    return BlocProvider<UpdateEmailAndPhoneNumberCubit>(
      create: (_) => UpdateEmailAndPhoneNumberCubit(),
      child: Builder(
        builder: (BuildContext context) {
          return ATAnnotatedRegion(
            child: Scaffold(
              appBar: ATAppBar(
                leadingWidth: 30,
                padding: const EdgeInsets.only(left: 7),
                leading: const ATRoundedBackBtn(),
                titleText: widget.title,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ATTextFormField(
                      controller: _controller,
                      hintText: isChangingEmail
                          ? 'Enter new email address'
                          : 'Enter email address',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const SizedBox(width: 10),
                    ),
                    Text(
                      maxLines: 2,
                      ' You will receive a verification code on this email address.',
                      style: context.textTheme.titleSmall?.copyWith(
                        height: 1.5,
                        fontSize: ATSizes.size11,
                      ),
                    ),
                  ],
                ),
              ),
              bottomSheet: Builder(
                builder: (BuildContext context) {
                  final double bottom = MediaQuery.viewInsetsOf(context).bottom;
                  final double bottomPadding = bottom == 0 ? 60 : 15;

                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, bottomPadding),
                    child: StreamBuilder<bool>(
                      stream: _activateButtonCntrl.stream,
                      builder: (_, AsyncSnapshot<bool> snapshot) {
                        final bool isActive =
                            snapshot.hasData && snapshot.data == true;

                        return BlocConsumer<UpdateEmailAndPhoneNumberCubit, ATAppState<String>>(
                          listener: (BuildContext context, ATAppState<String> state) async {
                            if (state is SuccessState<String>) {
                              final bool? didVerifyOTP = await context.pushNamed(
                                ATRoutes.enterEmailAndPhoneNoOtpScreen,
                                extra: EmailAndPhoneNoOTPScreenParams(
                                  verificationType: OTPVerificationType.email,
                                  identifier: _controller.text.trim(),
                                  title: widget.title,
                                  otp: state.newData,  // OTP from response
                                ),
                              );

                              if (context.mounted && didVerifyOTP == true) {
                                context.pop(_controller.text.trim());
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
                              onPressed: isActive
                                  ? () {
                                      context.read<UpdateEmailAndPhoneNumberCubit>().sendEmailAndPhoneOtp(
                                        param: <String, dynamic>{
                                          'email': _controller.text.trim(),
                                        },
                                        );
                                        }
                                      
                                  
                                  : null,
                              btnTitle: ATStrings.verifyEmail,
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
