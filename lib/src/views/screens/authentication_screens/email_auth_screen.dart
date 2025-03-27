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
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/authentication/email/email_auth_bloc.dart';
import '../../../bloc/authentication/email/email_auth_events.dart';
import '../../../utils/constants/strings/route_strings.dart';
import '../../widgets/common_widgets/app_bar_widget.dart';
import '../../widgets/common_widgets/common_widgets.dart';

class ATEmailAuthScreen extends StatefulWidget {
  const ATEmailAuthScreen({super.key, this.title});
  final String? title;

  @override
  State<ATEmailAuthScreen> createState() => _ATEmailAuthScreenState();
}

class _ATEmailAuthScreenState extends State<ATEmailAuthScreen> {
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
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: AmptiveAppBar(
          title: Text(
            widget.title ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ATStrings.UR_EMAIL,
                style: Theme.of(context).textTheme.headlineMedium
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: BlocBuilder<ATEmailAuthBloc, ATAuthState>(
                    builder: (_, state) {
                  return ATTextFormFieldWidget(
                    controller: _controller,
                    cursorColor: service.email.error == null
                        ? ATColors.hex307FE2
                        : ATColors.textRedColor,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (currentText) {
                      service.validateEmail(currentText);
                      context.read<ATEmailAuthBloc>().add(
                        EmailFieldChangedAuthEvent(currentTextEntered: currentText)
                      );
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      hintText: ATStrings.enterYourEmail,
                      hintStyle: TextStyle(
                        fontSize: ATFontSizes.size16,
                        color: ATColors.authHintColor,
                        fontWeight: ATFontWeights.w400,
                      ),
                      errorText: service.email.error,
                      errorStyle: TextStyle(
                        color: ATColors.textRedColor,
                        fontSize: ATFontSizes.size12,
                        fontWeight: ATFontWeights.w400,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF9E9E9E).withOpacity(0.3),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: service.email.error == null
                              ? ATColors.hex307FE2
                              : ATColors.textRedColor,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: ATColors.trsprnt,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  );
                }),
              ),
              BlocBuilder<ATEmailAuthBloc, ATAuthState>(
                  builder: (context, state) {
                var height = service.customEmailStatus.value != null ? 20 : 0;
                return Container(
                  height: height.toDouble(),
                  margin: const EdgeInsets.symmetric(vertical: 11),
                  child: Text(
                    service.customEmailStatus.value ??
                        ATStrings.empty,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                );
              }),
            ],
          ),
        ),

        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: BlocConsumer<ATEmailAuthBloc, ATAuthState>(
            listener: (context, state) {
              if (state is ValidEmailAuthState && context.mounted) {
                context.pushNamed(
                  ATRoutes.OTP_SCREEN,
                  extra: [_controller.text.trim(), widget.title]
                );
              }
            },
            builder: (context, state) {
              final enableBtn = service.isEmailValid;
        
              return state is LoadingAuthState && context.mounted
                ? const AmptiveLoadingButtonWidget()
                : ATPlainElevatedBtn(
                    height: 50,
                    btnTitle: ATStrings.verifyEmail,
                    onPressed: enableBtn ? (){
                      context.read<ATEmailAuthBloc>()
                        .add(VerifyEmailAuthEvent());
                    }: null
                  );
            },
          ),
        ),
      ),
    );
  }
}
