import 'package:amptive/src/bloc/authentication/email/email_auth_states.dart';
import 'package:amptive/src/services/auth/auth_field_service.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/authentication/email/email_auth_bloc.dart';
import '../../../bloc/authentication/email/email_auth_events.dart';
import '../../../utils/constants/strings/route_strings.dart';
import '../../widgets/common_widgets/app_bar_widget.dart';
import '../../widgets/common_widgets/common_widgets.dart';

class AmptiveEmailAuthScreen extends StatefulWidget {
  const AmptiveEmailAuthScreen({super.key});

  @override
  State<AmptiveEmailAuthScreen> createState() => _AmptiveEmailAuthScreenState();
}

class _AmptiveEmailAuthScreenState extends State<AmptiveEmailAuthScreen> {
  late AuthFieldService service;
  late TextEditingController _controller;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    service = GetIt.I<AuthFieldService>();
    _controller = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: const AmptiveAppBar(),
        body: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AmptiveOtherStrings.whatIsYourEmail,
                  style: Theme.of(context).textTheme.headlineMedium),
              Gap(10.h),
              Form(
                key: _formKey,
                child: BlocBuilder<AmptiveEmailAuthBloc, AmptiveEmailAuthState>(
                    builder: (_, state) {
                  return AmptiveTextFormFieldWidget(
                    controller: _controller,
                    cursorColor: service.email.error == null
                        ? AmptiveColors.brandBlueColor
                        : AmptiveColors.textRedColor,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (currentText) {
                      service.validateEmail(currentText);
                      context.read<AmptiveEmailAuthBloc>().add(
                          EmailFieldChangedAuthEvent(
                              currentTextEntered: currentText));
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 16.w),
                      hintText: AmptiveOtherStrings.enterYourEmail,
                      hintStyle: TextStyle(
                        fontSize: AmptiveFontSizes.size16,
                        color: AmptiveColors.authHintColor,
                        fontWeight: AmptiveFontWeights.regular,
                      ),
                      errorText: service.email.error,
                      errorStyle: TextStyle(
                        color: AmptiveColors.textRedColor,
                        fontSize: AmptiveFontSizes.size12,
                        fontWeight: AmptiveFontWeights.regular,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF9E9E9E).withOpacity(0.3),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.w,
                          color: service.email.error == null
                              ? AmptiveColors.brandBlueColor
                              : AmptiveColors.textRedColor,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.w,
                          color: AmptiveColors.transparentColor,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  );
                }),
              ),
              BlocBuilder<AmptiveEmailAuthBloc, AmptiveEmailAuthState>(
                  builder: (context, state) {
                var height =
                    service.customEmailStatus.value != null ? 20.h : 0.h;
                return Container(
                  height: height,
                  margin: EdgeInsets.symmetric(vertical: 11.h),
                  child: Text(
                    service.customEmailStatus.value ??
                        AmptiveOtherStrings.empty,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                );
              }),
            ],
          ),
        ),
        bottomSheet: BlocListener<AmptiveEmailAuthBloc, AmptiveEmailAuthState>(
          listener: (context, state) {
            if (state is ValidEmailAuthState && context.mounted) {
              context.pushNamed(AmptiveRoutes.otp,
                  extra: AmptiveOtherStrings.email);
            }
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: BlocBuilder<AmptiveEmailAuthBloc, AmptiveEmailAuthState>(
              builder: (context, state) {
                final enableVerificationButton = service.isEmailValid;

                return state is LoadingAuthState && context.mounted
                    ? const AmptiveLoadingButtonWidget()
                    : AmptiveElevatedButtonWidget(
                        height: 50.w,
                        buttonTitle: AmptiveOtherStrings.verifyEmail,
                        onPressed: enableVerificationButton
                            ? () {
                                context
                                    .read<AmptiveEmailAuthBloc>()
                                    .add(VerifyEmailAuthEvent());
                              }
                            : null,
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
