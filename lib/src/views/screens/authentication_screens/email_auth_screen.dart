import 'package:amptive/src/bloc/authentication_bloc/auth_bloc.dart';
import 'package:amptive/src/bloc/authentication_bloc/auth_events.dart';
import 'package:amptive/src/bloc/authentication_bloc/auth_states.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/extensions/extensions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/constants/strings/route_strings.dart';

class AmptiveEmailAuthScreen extends StatefulWidget {
  const AmptiveEmailAuthScreen({super.key});

  @override
  State<AmptiveEmailAuthScreen> createState() => _AmptiveEmailAuthScreenState();
}

class _AmptiveEmailAuthScreenState extends State<AmptiveEmailAuthScreen> {
  late TextEditingController _controller;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
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
                child: AmptiveTextFormFieldWidget(
                  controller: _controller,
                  hintText: AmptiveOtherStrings.enterYourEmail,
                  onChanged: (currentText) => context
                      .read<AmptiveAuthBloc>()
                      .add(GetTheCurrentTextOnTheEmailFieldAuthEvent(
                          currentTextOnTheEmailField: currentText)),
                ),
              ),
              Gap(10.h),
              Text(
                AmptiveOtherStrings.thisEmailWillBeVerified,
                style: Theme.of(context).textTheme.titleSmall,
              )
            ],
          ),
        ),
        bottomSheet: BlocListener<AmptiveAuthBloc, AmptiveAuthState>(
          listener: (context, state) {
            if (state is LoadedAuthState && context.mounted) {
              context.pushNamed(AmptiveRoutes.otp,
                  extra: AmptiveOtherStrings.email);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                buildWhen: (previous, current) =>
                    previous.userEmail != current.userEmail,
                builder: (context, state) {
                  final enableVerificationButton =
                      state.userEmail?.emailContainsEmailSymbol ?? false;

                  return state is LoadingAuthState
                      ? ElevatedButton(
                          onPressed: () {},
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          ),
                        )
                      : AmptiveElevatedButtonWidget(
                          buttonTitle: AmptiveOtherStrings.verifyEmail,
                          onPressed: enableVerificationButton
                              ? () {
                                  context.read<AmptiveAuthBloc>().add(
                                      VerifyEmailAuthEvent(
                                          userEmail: state.userEmail!));
                                }
                              : null);
                }),
          ),
        ),
      ),
    );
  }
}
