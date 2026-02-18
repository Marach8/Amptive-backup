import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/check_identity_availability_cubit.dart';
import 'package:amptive/src/features/auth/cubits/send_otp_cubit.dart';
import 'package:amptive/src/features/auth/otp_screen.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import '../../views/widgets/common_widgets/app_bar_widget.dart';

class ATEmailAuthScreen extends StatefulWidget {
  const ATEmailAuthScreen({super.key, this.title});
  final String? title;

  @override
  State<ATEmailAuthScreen> createState() => _ATEmailAuthScreenState();
}

class _ATEmailAuthScreenState extends State<ATEmailAuthScreen> with ATValidators{
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(_) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<CheckIdentityAvailabilityCubit>(
          create:(_) => CheckIdentityAvailabilityCubit(),
        ),
        BlocProvider<SendOtpCubit>(create:(_) => SendOtpCubit()),
      ],
      child: Builder(
        builder: (BuildContext context) {
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
                        keyboardType: TextInputType.emailAddress,
                        autoValidateMode: AutovalidateMode.disabled,
                        validator: validateEmail,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: BlocConsumer<CheckIdentityAvailabilityCubit, ATAppState<bool>>(
                            listener: (_, ATAppState<bool> state) {
                              if(state is FailureState<bool>){
                                showAppNotification2(
                                  context: context,
                                  text: state.message,
                                  type: NotificationType.failure,
                                );
                              }
                            },
                            builder: (_, ATAppState<bool> state) => switch(state){
                              InitialState<bool>() => const SizedBox.shrink(),
                              LoadingState<bool>() => const ATLoadingIndicator(size: 20,),
                              SuccessState<bool>() => Icon(
                                Icons.check, color: ATColors.successColor,
                              ),
                              FailureState<bool>() => Icon(
                                Icons.close, color: ATColors.textRedColor,
                              )
                            }
                          ),
                        ),
                        onChanged: (String text){
                          ATHelperFuncs.callDebouncer(
                            1500,
                            () => context.read<CheckIdentityAvailabilityCubit>()
                              .checkIdentityAvailability(param: <String, dynamic>{'email': text})
                          );
                        }
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
                    child: BlocBuilder<CheckIdentityAvailabilityCubit, ATAppState<bool>>(
                      builder: (_, ATAppState<bool> state) {
                        final bool shouldEnableBtn = state is SuccessState<bool>;
                        return BlocConsumer<SendOtpCubit, ATAppState<String>>(
                          listener: (_, ATAppState<String> sendOtpState) async{
                            if(sendOtpState is SuccessState<String>){
                              final bool? didVerifyOTP = await context.pushNamed(
                                ATRoutes.ENTER_OTP_SCREEN,
                                extra: VerifyOTPScreenParams(
                                  verificationType: OTPVerificationType.email,
                                  identifier: _controller.text.trim(),
                                  title: widget.title,
                                  otp: sendOtpState.newData
                                )
                              ) as bool?;

                              if(context.mounted && didVerifyOTP == true){
                                context.pushNamed(ATRoutes.createPasswordScreen);
                              }
                            }
                            else if(sendOtpState is FailureState<String>){
                              showAppNotification2(
                                context: context,
                                text: sendOtpState.message,
                                type: NotificationType.failure,
                              );
                            }
                          },
                          builder: (BuildContext context, ATAppState<String> sendOtpState) {                   
                            return ATPlainElevatedBtn(
                              isLoading: sendOtpState is LoadingState<String>,
                              onPressed: shouldEnableBtn ? (){
                                if(_formKey.currentState?.validate() ?? false){
                                  context.read<SendOtpCubit>()
                                    .sendOtp(param: <String, dynamic>{'email': _controller.text.trim()});
                                }
                              } : null,
                              btnTitle: ATStrings.verifyEmail,
                            );
                          },
                        );
                      }
                    ),
                  );
                }
              ),
            ),
          );
        }
      ),
    );
  }
}
