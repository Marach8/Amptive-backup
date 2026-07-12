import 'package:flutter/gestures.dart';
import 'package:amptive/src/features/auth/presentation/screens/auth_options_screen.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/check_identity_availability_cubit.dart';
import 'package:amptive/src/features/auth/cubits/send_otp_cubit.dart';
import 'package:amptive/src/features/auth/data/models/request/registration_data.dart';
import 'package:amptive/src/features/auth/presentation/screens/otp_screen.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import '../../../../shared/app_bar_widget.dart';

class ATEmailSignUpScreen extends StatefulWidget {
  const ATEmailSignUpScreen({super.key, this.title});
  final String? title;

  @override
  State<ATEmailSignUpScreen> createState() => _ATEmailSignUpScreenState();
}

class _ATEmailSignUpScreenState extends State<ATEmailSignUpScreen>
    with ATValidators {
  final TextEditingController _emailCntrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCntrl.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(_) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<CheckIdentityAvailabilityCubit>(
          create: (_) => CheckIdentityAvailabilityCubit(),
        ),
        BlocProvider<SendOtpCubit>(create: (_) => SendOtpCubit()),
      ],
      child: Builder(builder: (BuildContext context) {
        return ATAnnotatedRegion(
          child: Scaffold(
            appBar: ATAppBar(
                leading: const ATBackBtn(), titleText: widget.title ?? 'Sign Up'),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(ATStrings.whatIsYourEmail,
                        style: context.textTheme.headlineMedium),
                    const SizedBox(height: 10),
                    ATTextFormField(
                        controller: _emailCntrl,
                        maxLines: 1,
                        hintText: ATStrings.enterYourEmail,
                        fillColor: ATColors.hex9E9E9E.withValues(alpha: 0.3),
                        prefixIcon: const SizedBox(
                          width: 10,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autoValidateMode: AutovalidateMode.disabled,
                        validator: validateEmail,
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
                                    SuccessState<bool>() => const ATImgLoader(
                                        imgPath: 'assets/images/svg_images/success_check.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                    FailureState<bool>() => Icon(
                                        Icons.close,
                                        color: ATColors.textRedColor,
                                      )
                                  }),
                        ),
                        onChanged: (String text) {
                          // Only hit the backend if the email looks structurally valid
                          final bool looksValid = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          ).hasMatch(text.trim());

                          if (looksValid) {
                            ATHelperFuncs.callDebouncer(
                                1500,
                                () => context
                                    .read<CheckIdentityAvailabilityCubit>()
                                    .checkIdentityAvailability(
                                        param: <String, dynamic>{'email': text}));
                          } else {
                            // Reset the suffix icon while the user is still typing
                            context.read<CheckIdentityAvailabilityCubit>().reset();
                          }
                        }),
                    const SizedBox(
                      height: 6,
                    ),
                    BlocBuilder<CheckIdentityAvailabilityCubit,
                        ATAppState<bool>>(
                      builder: (_, ATAppState<bool> state) {
                        if (state is FailureState<bool>) {
                          return RichText(
                            text: TextSpan(
                              style: context.textTheme.titleSmall?.copyWith(
                                color: Colors.white,
                              ),
                              children: <InlineSpan>[
                                const TextSpan(text: 'Email address already exists, try '),
                                TextSpan(
                                  text: 'signing in',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Pop back and navigate to the sign-in screen
                                      context.pop();
                                      context.pushNamed(
                                        ATRoutes.authOptionsScreen,
                                        extra: AuthType.signIn,
                                      );
                                    },
                                ),
                              ],
                            ),
                          );
                        }
                        return Text(
                          'This email will be verified in the next step.',
                          style: context.textTheme.titleSmall,
                        );
                      },
                    ),
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
                  return BlocConsumer<SendOtpCubit, ATAppState<String>>(
                    listener: (_, ATAppState<String> sendOtpState) async {
                      if (sendOtpState is SuccessState<String>) {
                        final bool? didVerifyOTP = await context.pushNamed(
                            ATRoutes.enterOtpScreen,
                            extra: VerifyOTPScreenParams(
                                verificationType: OTPVerificationType.email,
                                dataToVerify: _emailCntrl.text.trim(),
                                appbarTitle: widget.title
                            )) as bool?;

                        if (context.mounted && didVerifyOTP == true) {
                          RegistrationData()
                              .copyWith(email: _emailCntrl.text.trim());
                          context.pushNamed(ATRoutes.createPasswordScreen);
                        }
                      } else if (sendOtpState is FailureState<String>) {
                        showAppNotification2(
                          context: context,
                          text: sendOtpState.message,
                          type: NotificationType.failure,
                        );
                      }
                    },
                    builder: (BuildContext context,
                        ATAppState<String> sendOtpState) {
                      return ATPlainElevatedBtn(
                        isLoading: sendOtpState is LoadingState<String>,
                        onPressed: shouldEnableBtn
                            ? () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  context.read<SendOtpCubit>().sendOtp(
                                      param: <String, dynamic>{
                                        'email': _emailCntrl.text.trim()
                                      });
                                }
                              }
                            : null,
                        btnTitle: ATStrings.verifyEmail,
                        bgColor: Colors.white,
                        fgColor: Colors.black,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      );
                    },
                  );
                }),
              );
            }),
          ),
        );
      }),
    );
  }
}

