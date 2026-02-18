import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/login_cubit.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../views/widgets/common_widgets/app_bar_widget.dart';

class TempLoginScreen extends StatefulWidget {
  const TempLoginScreen({super.key, this.title});
  final String? title;

  @override
  State<TempLoginScreen> createState() => _TempLoginScreenState();
}

class _TempLoginScreenState extends State<TempLoginScreen> with ATValidators {
  final TextEditingController _emailCntrl = TextEditingController();
  final TextEditingController _pswrdCntrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<(bool, bool)> _btnNotifier = ValueNotifier<(bool, bool)>((false, false));
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(),
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar: ATAppBar(
            leading: const ATBackBtn(),
            titleText: widget.title ?? '',
          ),
          body: BlocConsumer<LoginCubit, ATAppState<dynamic>>(
            listener: (BuildContext context, ATAppState<dynamic> state) {
              if (state is SuccessState<dynamic>) {
                context.goNamed(ATRoutes.MAIN_APP_SHELL);
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
                          ATStrings.whatIsYourEmail,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        ATTextFormField(
                          controller: _emailCntrl,
                          hintText: ATStrings.enterYourEmail,
                          validator: validateEmail,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          ATStrings.UR_PSWRD,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        ATTextFormField(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Icon(Icons.key_outlined),
                          ),
                          controller: _pswrdCntrl,
                          hintText: ATStrings.ENTER_UR_PSWRD,
                          validator: validatePassword,
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
                      }
                      )
                        
                          ),
                        
                      ]
                      ),
                ),
              );
            },
          ),
          bottomSheet: Builder(
            builder: (BuildContext context) {
              final double bottom = MediaQuery.viewInsetsOf(context).bottom;
              final double bottomPadding = bottom == 0 ? 50 : 10;
              final ATAppState<dynamic> cubitState = context.watch<LoginCubit>().state;
              final bool isLoading = cubitState is LoadingState<dynamic>;

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
