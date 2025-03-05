import 'package:amptive/src/bloc/authentication/general/auth_events.dart';
import 'package:amptive/src/bloc/authentication/password/password_auth_states.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/authentication/general/auth_bloc.dart';
import '../../../bloc/authentication/general/auth_states.dart';
import '../../../bloc/authentication/password/password_auth_bloc.dart';
import '../../../bloc/authentication/password/password_auth_events.dart';
import '../../../utils/constants/strings/other_strings.dart';
import '../../widgets/common_widgets/app_bar_widget.dart';
import '../../widgets/common_widgets/elevated_button_widget.dart';

class PasswordAuthScreen extends StatefulWidget {
  const PasswordAuthScreen({super.key});

  @override
  State<PasswordAuthScreen> createState() => _PasswordAuthScreenState();
}

class _PasswordAuthScreenState extends State<PasswordAuthScreen> {
  bool _passwordVisible = false;
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegionWidget(
      child: Scaffold(
        appBar: const AmptiveAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ATStrings.createPasswordForAccount,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(
                  height: 11.h,
                ),
                BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                    buildWhen: (previous, current) =>
                        current is HideOrShowPasswordAuthState,
                    builder: (_, state) {
                      if (state is HideOrShowPasswordAuthState) {
                        // toggle password visibility
                        _passwordVisible = !_passwordVisible;
                      }
                      return ATTextFormFieldWidget(
                        controller: passwordController,
                        onChanged: (value) {
                          // trigger password changed event
                          context
                              .read<AmptivePasswordAuthBloc>()
                              .add(PasswordChangedAuthEvent(value: value));
                        },
                        obscureText: !_passwordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: ATColors.hex307FE2,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 16.w),
                          hintText: ATStrings.enterYourPassword,
                          hintStyle: Theme.of(context).textTheme.labelMedium,
                          filled: true,
                          fillColor:
                              ATColors.hex9E9E9E.withOpacity(0.3),
                          focusedBorder: buildOutlineInputBorder(),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.w,
                              color: ATColors.transparentColor,
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          suffixIcon: IconButton(
                            icon: Padding(
                              padding: EdgeInsets.only(right: 16.0.w),
                              child: Icon(
                                _passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: ATColors.whiteColor,
                              ),
                            ),
                            onPressed: () {
                              context
                                  .read<AmptiveAuthBloc>()
                                  .add(HideOrShowPasswordAuthEvent());
                            },
                          ),
                        ),
                      );
                    }),
                BlocBuilder<AmptivePasswordAuthBloc, AmptivePasswordAuthState>(
                    builder: (_, state) {
                  var height = state.error != null ? 20.h : 0.h;
                  return Container(
                    height: height,
                    margin: EdgeInsets.symmetric(vertical: 11.h),
                    child: Text(
                      state.error ?? ATStrings.empty,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  );
                }),
                Expanded(
                  child: SizedBox(
                    height: 1.h,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: BlocBuilder<AmptivePasswordAuthBloc, AmptivePasswordAuthState>(
            builder: (context, state) {
              return AmptiveElevatedButtonWidget(
                height: 50.w,
                buttonTitle: ATStrings.NEXT,
                onPressed: state is ValidPasswordAuthState
                    ? () {
                        context.pushNamed(ATRoutes.dobAuth);
                      }
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(width: 2.w, color: ATColors.hex307FE2),
      borderRadius: BorderRadius.circular(14.r),
    );
  }
}
