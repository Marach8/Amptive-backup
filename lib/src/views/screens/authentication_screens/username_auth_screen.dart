import 'package:amptive/src/services/auth/auth_field_service.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/authentication/general/auth_bloc.dart';
import '../../../bloc/authentication/general/auth_events.dart';
import '../../../bloc/authentication/general/auth_states.dart';

class UserNameAuthScreen extends StatefulWidget {
  const UserNameAuthScreen({super.key});

  @override
  State<UserNameAuthScreen> createState() => _UserNameAuthScreenState();
}

class _UserNameAuthScreenState extends State<UserNameAuthScreen> {
  late final AuthFieldService service;

  TextEditingController usernameController = TextEditingController();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    service = GetIt.I<AuthFieldService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegionWidget(
      child: Scaffold(
        backgroundColor: ATColors.brandBlack,
        appBar: const AmptiveAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: BlocListener<AmptiveAuthBloc, AmptiveAuthState>(
            listener: (context, state) {
              if (state is UsernameLoadingAuthState) {
                _isLoading = true;
              } else if (state is UsernameValidatedAuthState) {
                _isLoading = false;
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ATStrings.whatShouldWeCallYou,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: ATFontSizes.size17,
                        ),
                  ),
                  SizedBox(
                    height: 11.h,
                  ),
                  BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                      buildWhen: (p, current) {
                    return true;
                  }, builder: (_, state) {
                    return ATTextFormFieldWidget(
                      controller: usernameController,
                      onChanged: (val) {
                        context
                            .read<AmptiveAuthBloc>()
                            .add(UsernameChangedEvent(val));
                      },
                      keyboardType: TextInputType.text,
                      cursorColor: service.username.error == null
                          ? ATColors.hex307FE2
                          : ATColors.textRedColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 16.w),
                        prefixIcon: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 16.w),
                          child: Text(
                            ATStrings.emailSymbol,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        suffix: _isLoading
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: ATColors.hex307FE2,
                                  backgroundColor: ATColors.hex307FE2
                                      .withOpacity(0.5),
                                  strokeWidth: 3.w,
                                ),
                              )
                            : null,
                        suffixIcon: _isLoading
                            ? null
                            : service.isUsernameValid
                                ? Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 20,
                                    child: Icon(
                                      Icons.check,
                                      color: ATColors.successColor,
                                    ),
                                  )
                                : service.isUsernameInvalid
                                    ? Container(
                                        alignment: Alignment.center,
                                        width: 20,
                                        height: 20,
                                        child: Icon(
                                          Icons.close,
                                          color: ATColors.textRedColor,
                                        ),
                                      )
                                    : null,
                        hintText: ATStrings.username,
                        hintStyle: Theme.of(context).textTheme.labelMedium,
                        filled: true,
                        fillColor: ATColors.hex9E9E9E.withOpacity(0.3),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.w,
                            color: service.username.error == null
                                ? ATColors.hex307FE2
                                : ATColors.textRedColor,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.w,
                            color: ATColors.trspntColor,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                    );
                  }),
                  Visibility(
                    visible: _isLoading,
                    child: Container(
                      height: 20.h,
                      margin: EdgeInsets.symmetric(vertical: 11.h),
                      child: Text(
                        ATStrings.checkerIsLoading,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: AmptiveFontWeights.w500,
                            ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_isLoading && service.isUsernameValid,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 11.h),
                      child: Text(
                        ATStrings.usernameIsAvailable,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: ATColors.successColor,
                            ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_isLoading && !service.isUsernameValid,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 11.h),
                      child: Text(
                        service.username.error ?? ATStrings.empty,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: ATColors.textRedColor,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 1.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
              builder: (context, state) {
            return AmptiveElevatedButtonWidget(
              height: 50.w,
              onPressed: service.isUsernameValid
                  ? () {
                      context.pushNamed(ATRoutes.addName);
                    }
                  : null,
              buttonTitle: ATStrings.NEXT,
            );
          }),
        ),
      ),
    );
  }
}
