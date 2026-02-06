import 'package:amptive/src/bloc/authentication/email/email_auth_states.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ATStrings.whatIsYourEmail,
                  style: context.textTheme.headlineMedium
                ),
                const SizedBox(height: 10),

                ATTextFormField(
                  controller: _controller,
                  maxLines: 1,
                  hintText: ATStrings.enterYourEmail,
                  fillColor: ATColors.hex9E9E9E.withValues(alpha: 0.3),
                  prefixIcon: const SizedBox(width: 10,),
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: ATLoadingIndicator(size: 20,),
                  ),
                ),
                const SizedBox(height: 6,),
                Text(
                  "This email will be verified in the next step.",
                  style: context.textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),

        bottomSheet: Builder(
          builder: (BuildContext context) {
            final double bottom = MediaQuery.viewInsetsOf(context).bottom;
            final double bottomPad = bottom > 0 ? 10 : 50;
            return Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, bottomPad),
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
            );
          }
        ),
      ),
    );
  }
}
