import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/check_identity_availability_cubit.dart';
import 'package:amptive/src/features/auth/cubits/login_cubit.dart';
import 'package:amptive/src/features/auth/data/models/response/auth_success_response_model.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:amptive/src/features/auth/cubits/send_otp_cubit.dart';
import 'package:amptive/src/features/auth/presentation/screens/otp_screen.dart';
import 'package:amptive/src/features/auth/data/models/request/registration_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/app_bar_widget.dart';

class LoginScreenEntryParams {
  const LoginScreenEntryParams({
    this.title,
    this.notification,
  });

  final String? title, notification;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.params,
  });
  final LoginScreenEntryParams? params;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ATValidators {
  final TextEditingController _emailCntrl = TextEditingController();
  final TextEditingController _pswrdCntrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<(bool, bool)> _btnNotifier =
      ValueNotifier<(bool, bool)>((false, false));
  bool _passwordVisible = false;
  bool _isPasswordStep = false;

  @override
  void initState() {
    super.initState();
    _emailCntrl.addListener(() {
      if (_emailCntrl.text.length >= 5) {
        _btnNotifier.value = (true, _btnNotifier.value.$2);
      } else {
        _btnNotifier.value = (false, _btnNotifier.value.$2);
      }
    });

    _pswrdCntrl.addListener(() {
      if (_pswrdCntrl.text.length >= 5) {
        _btnNotifier.value = (_btnNotifier.value.$1, true);
      } else {
        _btnNotifier.value = (_btnNotifier.value.$1, false);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.params?.notification != null) {
        showAppNotification2(
          context: context,
          text: widget.params?.notification ?? '',
          type: NotificationType.failure,
        );
      }
    });
  }

  @override
  void dispose() {
    _emailCntrl.dispose();
    _pswrdCntrl.dispose();
    _btnNotifier.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (_) => LoginCubit()),
        BlocProvider<CheckIdentityAvailabilityCubit>(create: (_) => CheckIdentityAvailabilityCubit()),
        BlocProvider<SendOtpCubit>(create: (_) => SendOtpCubit()),
      ],
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar: ATAppBar(
            leading: const ATBackBtn(),
            titleText: widget.params?.title ?? 'Sign In',
          ),
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                        return Stack(
                          alignment: Alignment.topLeft,
                          children: <Widget>[
                            ...previousChildren,
                            if (currentChild != null) currentChild,
                          ],
                        );
                      },
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        final offsetAnimation = Tween<Offset>(
                          begin: child.key == const ValueKey('password_step') 
                              ? const Offset(1.0, 0.0) 
                              : const Offset(-1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: !_isPasswordStep
                          ? _buildEmailStep()
                          : _buildPasswordStep(),
                    ),
                  ]),
            ),
          ),
          bottomSheet: BlocConsumer<LoginCubit, ATAppState<ATUser>>(
            listener: (BuildContext context, ATAppState<ATUser> state) {
              if (state is SuccessState<ATUser>) {
                context.goNamed(ATRoutes.dashboard);
              } else if (state is FailureState<ATUser>) {
                showAppNotification2(
                  context: context,
                  text: state.message,
                  type: NotificationType.failure,
                );
              }
            },
            builder: (BuildContext context, ATAppState<ATUser> state) {
              final double bottom = MediaQuery.viewInsetsOf(context).bottom;
              final double bottomPadding = bottom == 0 ? 50 : 10;
              final ATAppState<ATUser> cubitState =
                  context.watch<LoginCubit>().state;
              final bool isLoginLoading = cubitState is LoadingState<ATUser>;

              return BlocConsumer<CheckIdentityAvailabilityCubit, ATAppState<bool>>(
                listener: (context, availabilityState) {
                  if (availabilityState is FailureState<bool>) {
                    // Backend returned Failure -> Email already exists. This means they are valid for login!
                    setState(() {
                      _isPasswordStep = true;
                    });
                  } else if (availabilityState is SuccessState<bool>) {
                    // Backend returned Success -> Email DOES NOT exist. Seamlessly transition to sign-up flow!
                    context.read<SendOtpCubit>().sendOtp(
                      param: <String, dynamic>{'email': _emailCntrl.text.trim()}
                    );
                  }
                },
                builder: (context, availabilityState) {
                  final bool isAvailabilityLoading = availabilityState is LoadingState<bool>;
                  
                  return BlocConsumer<SendOtpCubit, ATAppState<String>>(
                    listener: (context, sendOtpState) async {
                      if (sendOtpState is SuccessState<String>) {
                        final bool? didVerifyOTP = await context.pushNamed(
                            ATRoutes.ENTER_OTP_SCREEN,
                            extra: VerifyOTPScreenParams(
                                verificationType: OTPVerificationType.email,
                                identifier: _emailCntrl.text.trim(),
                                title: 'Sign Up',
                                otp: sendOtpState.newData)) as bool?;

                        if (context.mounted && didVerifyOTP == true) {
                          RegistrationData().copyWith(email: _emailCntrl.text.trim());
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
                    builder: (context, sendOtpState) {
                      final bool isOtpLoading = sendOtpState is LoadingState<String>;
                      final bool isLoading = !_isPasswordStep ? (isAvailabilityLoading || isOtpLoading) : isLoginLoading;

                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, bottomPadding),
                    child: ValueListenableBuilder<(bool, bool)>(
                      valueListenable: _btnNotifier,
                      builder: (_, (bool, bool) value, __) {
                        final bool enable = !_isPasswordStep ? value.$1 : value.$2;
                        return ATPlainElevatedBtn(
                          isLoading: isLoading,
                          onPressed: enable
                              ? () {
                                  FocusScope.of(context).unfocus();
                                  if (!_isPasswordStep) {
                                    // Step 1: Hit backend to check if email exists
                                    if (_formKey.currentState?.validate() ?? false) {
                                      context.read<CheckIdentityAvailabilityCubit>().checkIdentityAvailability(
                                        param: <String, dynamic>{'email': _emailCntrl.text.trim()},
                                      );
                                    }
                                  } else {
                                    // Step 2: Validate Password and Submit
                                    if (_formKey.currentState?.validate() ?? false) {
                                      context.read<LoginCubit>().loginUser(
                                        param: <String, dynamic>{
                                          'email': _emailCntrl.text.trim(),
                                          'password': _pswrdCntrl.text.trim(),
                                        },
                                      );
                                    }
                                  }
                                }
                              : null,
                          btnTitle: !_isPasswordStep ? 'Next' : ATStrings.SIGN_IN,
                          bgColor: Colors.white,
                          fgColor: Colors.black,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                  );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmailStep() {
    return Column(
      key: const ValueKey('email_step'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ATStrings.email,
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
    );
  }

  Widget _buildPasswordStep() {
    return Column(
      key: const ValueKey('password_step'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Visual indicator of the entered email with an edit button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                _emailCntrl.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isPasswordStep = false;
                });
              },
              child: Text(
                'Edit',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ATColors.hexF91880,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          ATStrings.password,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        ATTextFormField(
          controller: _pswrdCntrl,
          hintText: ATStrings.enterYourPassword,
          validator: (String? val) {
            if (val == null || val.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
          obscureText: _passwordVisible,
          maxLines: 1,
          prefixIcon: const SizedBox(width: 10),
          suffixConstraints: const BoxConstraints(maxWidth: 45),
          suffixIcon: IconButton(
            onPressed: () =>
                setState(() => _passwordVisible = !_passwordVisible),
            icon: Icon(
              _passwordVisible
                  ? CupertinoIcons.eye_slash
                  : CupertinoIcons.eye,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              context.pushNamed(ATRoutes.FORGOT_PASSWORD_SCREEN);
            },
            child: Text(
              ATStrings.forgotPasswrd,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
