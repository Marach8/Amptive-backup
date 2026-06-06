import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/login_cubit.dart';
import 'package:amptive/src/features/auth/data/models/response/auth_success_response_model.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController _emailCntrl = TextEditingController(
    text: kDebugMode ? 'nnannamarach4@gmail.com' : '',
  );
  final TextEditingController _pswrdCntrl = TextEditingController(
    text: kDebugMode ? 'Amptive@Developer123' : '',
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<(bool, bool)> _btnNotifier =
      ValueNotifier<(bool, bool)>((false, false));
  bool _passwordVisible = false;

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
    return BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(),
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar: ATAppBar(
            leading: const ATBackBtn(),
            titleText: widget.params?.title ?? '',
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
                      ATStrings.emailOrUsername,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    ATTextFormField(
                      controller: _emailCntrl,
                      hintText: ATStrings.enterYourEmailOrUsername,
                      validator: validateEmail,
                      prefixIcon: const SizedBox(width: 10),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      ATStrings.password,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    ATTextFormField(
                        controller: _pswrdCntrl,
                        hintText: ATStrings.enterYourPassword,
                        validator: validatePassword,
                        obscureText: _passwordVisible,
                        maxLines: 1,
                        prefixIcon: const SizedBox(width: 10),
                        suffixIcon: IconButton(
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 16),
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
                    const SizedBox(height: 5),
                    TextButton(
                        onPressed: () {
                          context.pushNamed(ATRoutes.FORGOT_PASSWORD_SCREEN);
                        },
                        child: Text(
                          ATStrings.forgotPasswrd,
                          style: Theme.of(context).textTheme.bodySmall,
                        ))
                  ]),
            ),
          ),
          bottomSheet: BlocConsumer<LoginCubit, ATAppState<ATUser>>(
            listener: (BuildContext context, ATAppState<ATUser> state) {
              if (state is SuccessState<ATUser>) {
                context.goNamed(ATRoutes.dashboard);
              } else if (state is FailureState<ATUser>) {
                showAppNotification2(context: context, text: state.message);
              }
            },
            builder: (BuildContext context, ATAppState<ATUser> state) {
              final double bottom = MediaQuery.viewInsetsOf(context).bottom;
              final double bottomPadding = bottom == 0 ? 50 : 10;
              final ATAppState<ATUser> cubitState =
                  context.watch<LoginCubit>().state;
              final bool isLoading = cubitState is LoadingState<ATUser>;

              return Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, bottomPadding),
                child: ValueListenableBuilder<(bool, bool)>(
                  valueListenable: _btnNotifier,
                  builder: (_, (bool, bool) value, __) {
                    final bool enable = value.$1 && value.$2;
                    return ATPlainElevatedBtn(
                      isLoading: isLoading,
                      onPressed: enable
                          ? () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context.read<LoginCubit>().loginUser(
                                  param: <String, dynamic>{
                                    'email': _emailCntrl.text.trim(),
                                    'password': _pswrdCntrl.text.trim(),
                                  },
                                );
                              }
                            }
                          : null,
                      btnTitle: ATStrings.SIGN_IN,
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
