import 'package:amptive/src/bloc/authentication/email/email_auth_states.dart';
import 'package:amptive/src/services/auth/auth_field_service.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/authentication/email/email_auth_bloc.dart';
import '../../bloc/authentication/email/email_auth_events.dart';
import '../../config/routing/route_strings.dart';
import '../../views/widgets/common_widgets/app_bar_widget.dart';
import '../../views/widgets/common_widgets/common_widgets.dart';

class ATEmailAuthScreen extends StatefulWidget {
  const ATEmailAuthScreen({super.key, this.title});
  final String? title;

  @override
  State<ATEmailAuthScreen> createState() => _ATEmailAuthScreenState();
}

class _ATEmailAuthScreenState extends State<ATEmailAuthScreen> {
  late AuthFieldService service;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    service = GetIt.I<AuthFieldService>();
    
    
  }

  @override
  void dispose() {
    _controller.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          leading: const ATBackBtn(),
          titleText: widget.title ?? ''
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                ATStrings.UR_EMAIL,
                style: Theme.of(context).textTheme.headlineMedium
              ),
              const SizedBox(height: 10),

              Form(
                key: _formKey,
                child: BlocBuilder<ATEmailAuthBloc, ATAuthState>(
                    builder: (_, ATAuthState state) {
                  return ATTextFormField(
                    controller: _controller, maxLines: 1,
                    cursorColor: service.email.error == null
                        ? ATColors.hex307FE2
                        : ATColors.textRedColor,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String currentText) {
                      service.validateEmail(currentText);
                      context.read<ATEmailAuthBloc>().add(
                        EmailFieldChangedAuthEvent(currentTextEntered: currentText)
                      );
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      hintText: ATStrings.ENTER_UR_EMAIL,
                      hintStyle: TextStyle(
                        fontSize: ATFontSizes.size16,
                        color: ATColors.hexB6B6B6,
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
                  builder: (BuildContext context, ATAuthState state) {
                int height = service.customEmailStatus.value != null ? 20 : 0;
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
            listener: (BuildContext context, ATAuthState state) {
              if (state is ValidEmailAuthState && context.mounted) {
                context.pushNamed(
                  ATRoutes.OTP_SCREEN,
                  extra: <String?>[_controller.text.trim(), widget.title]
                );
              }
            },
            builder: (BuildContext context, ATAuthState state) {
              final bool enableBtn = service.isEmailValid;

              return ATPlainElevatedBtn(
                onPressed: !enableBtn ? null:
                  () => context.read<ATEmailAuthBloc>().add(VerifyEmailAuthEvent()),
                btnTitle: ATStrings.VERIFY_EMAIL,
                child: state is LoadingAuthState ? ATLoadingIndicator(
                  color: ATColors.white,
                ) : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
