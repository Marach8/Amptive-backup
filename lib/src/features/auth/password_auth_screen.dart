import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/features/auth/cubits/register_user_cubit.dart';
import 'package:amptive/src/features/auth/data/models/user_data.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../config/utils/other_strings.dart';
import '../../views/widgets/common_widgets/app_bar_widget.dart';
import '../../shared/elevated_button_widget.dart';

class PasswordAuthScreen extends StatefulWidget {
  const PasswordAuthScreen({super.key});

  @override
  State<PasswordAuthScreen> createState() => _PasswordAuthScreenState();
}

class _PasswordAuthScreenState extends State<PasswordAuthScreen> with ATValidators{
  bool _passwordVisible = false;
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ATAppState<UserData> state = context.watch<RegisterUserCubit>().state;
  
    final bool isError = state is FailureState<UserData>;
    final bool isSuccess = state is SuccessState<UserData>;

    return ATAnnotatedRegion(
      child: Scaffold(
        backgroundColor: ATColors.hex0D0D0D,
        appBar: const ATAppBar(
          leading: ATBackBtn(),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ATStrings.createPasswordForAccount,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 11.h),
                ATTextFormField(
                  controller: passwordController,
                  validator: validatePassword,
                  onChanged: (String value) {
                    context.read<RegisterUserCubit>().setPassword(value);
                  },
                  obscureText: !_passwordVisible,
                  maxLines: 1,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: isError ? ATColors.textRedColor : ATColors.hex307FE2,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12.h, horizontal: 16.w),
                    hintText: ATStrings.ENTER_UR_PSWRD,
                    hintStyle: Theme.of(context).textTheme.labelMedium,
                    filled: true,
                    fillColor: ATColors.hex9E9E9E.withOpacity(0.3),
                    focusedBorder: buildOutlineInputBorder(isError),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.w,
                        color: ATColors.transparent,
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
                          color: ATColors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: isError,
                  child: Container(
                    height: 20.h,
                    margin: EdgeInsets.symmetric(vertical: 11.h),
                    child: Text(
                      isError ? state.message : ATStrings.empty,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: ATColors.textRedColor,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: ATPlainElevatedBtn(
            onPressed: (_formKey.currentState?.validate() ?? false)
        ? ()  => context.pushNamed(ATRoutes.DOB_AUTH_SCREEN)
                : null,
            btnTitle: ATStrings.next,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder(bool isError) {
    return OutlineInputBorder(
      borderSide: BorderSide(
          width: 2.w,
          color: isError ? ATColors.textRedColor : ATColors.hex307FE2),
      borderRadius: BorderRadius.circular(14.r),
    );
  }
}