import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/check_identity_availability_cubit.dart';
import 'package:amptive/src/features/auth/cubits/register_user_cubit.dart';
import 'package:amptive/src/features/auth/cubits/send_otp_cubit.dart';
import 'package:amptive/src/features/auth/otp_screen.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';

import '../post_auth/post_authentication_widgets/cupertino_phone_code_select.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key, this.title});
  final String? title;

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen>
    with ATValidators {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Country selectedCountry = CountryPickerUtils.getCountryByIsoCode(
    Constants.kDefaultCountrySelected,
  );

  @override
  void dispose() {
    _phoneController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<CheckIdentityAvailabilityCubit>(
          create: (_) => CheckIdentityAvailabilityCubit(),
        ),
        BlocProvider<SendOtpCubit>(create: (_) => SendOtpCubit()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          return ATAnnotatedRegion(
            child: Scaffold(
              appBar: ATAppBar(
                leading: const ATBackBtn(),
                titleText: widget.title,
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
                        ATStrings.UR_FON_NUMBER,
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontSize: ATSizes.size17,
                                ),
                      ),
                      const SizedBox(height: 11),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ATContainer(
                            onTap: () => _selectCountry(),
                            padding:
                                const EdgeInsets.fromLTRB(16, 12, 16, 12),
                            color: ATColors.hex9E9E9E.withOpacity(0.3),
                            radius: 14,
                            border: Border.all(
                              color: ATColors.hex307FE2,
                              width: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 13,
                                  width: 17,
                                  child: Image.asset(
                                    CountryPickerUtils.getFlagImageAssetPath(
                                      selectedCountry.isoCode,
                                    ),
                                    fit: BoxFit.fill,
                                    package: ATStrings.countryPickers,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  ATStrings.plus + selectedCountry.phoneCode,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(color: ATColors.white),
                                ),
                                const Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                       Expanded(
                            child: ATTextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              cursorColor: ATColors.hex307FE2,
                              maxLines: 1,
                              fillColor: ATColors.hex9E9E9E.withValues(alpha: 0.3),
                              prefixIcon: const SizedBox(width: 10),
                              autoValidateMode: AutovalidateMode.disabled,
                              validator: validatePhoneNumber,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: BlocConsumer<
                                    CheckIdentityAvailabilityCubit,
                                    ATAppState<bool>>(
                                  listener:
                                      (_, ATAppState<bool> state) {
                                    if (state is FailureState<bool>) {
                                      showAppNotification2(
                                        context: context,
                                        text: state.message,
                                        type: NotificationType.failure,
                                      );
                                    }
                                  },
                                  builder: (_, ATAppState<bool> state) =>
                                      switch (state) {
                                    InitialState<bool>() =>
                                      const SizedBox.shrink(),
                                    LoadingState<bool>() =>
                                      const ATLoadingIndicator(size: 20),
                                    SuccessState<bool>() => Icon(
                                      Icons.check,
                                      color: ATColors.successColor,
                                    ),
                                    FailureState<bool>() => Icon(
                                      Icons.close,
                                      color: ATColors.textRedColor,
                                    )
                                  },
                                ),
                              ),
                              onChanged: (String text) {
                                ATHelperFuncs.callDebouncer(
                                  1500,
                                  () => context
                                      .read<CheckIdentityAvailabilityCubit>()
                                      .checkIdentityAvailability(
                                        param: <String, dynamic>{
                                          'phone_number': text
                                        },
                                      ),
                                );
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(16, 12, 16, 12),
                                hintText: ATStrings.phoneNumber,
                                hintStyle:
                                    Theme.of(context).textTheme.labelMedium,
                                errorStyle: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: ATColors.textRedColor,
                                    ),
                                filled: true,
                                fillColor:
                                    ATColors.hex9E9E9E.withOpacity(0.3),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      width: 2, color: ATColors.hex307FE2),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: ATColors.transparent),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ATStrings.no_will_be_verified,
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                    ],
                  ),
                ),
              ),
              bottomSheet: Builder(
                builder: (BuildContext context) {
                  final double bottom =
                      MediaQuery.viewInsetsOf(context).bottom;
                  final double bottomPad = bottom > 0 ? 10 : 50;
                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, bottomPad),
                    child: BlocBuilder<
                        CheckIdentityAvailabilityCubit,
                        ATAppState<bool>>(
                      builder: (_, ATAppState<bool> state) {
                        final bool shouldEnableBtn =
                            state is SuccessState<bool>;
                        return BlocConsumer<SendOtpCubit, ATAppState<String>>(
                          listener:
                              (_, ATAppState<String> sendOtpState) async {
                            if (sendOtpState is SuccessState<String>) {
                              final  bool? didVerifyOTP = await context.pushNamed(
                                ATRoutes.enterOtpScreen,
                                extra: VerifyOTPScreenParams(
                                  verificationType:
                                      OTPVerificationType.phoneNumber,
                                  identifier: ATStrings.plus +
                                      selectedCountry.phoneCode +
                                      _phoneController.text.trim(),
                                  title: widget.title,
                                  otp: sendOtpState.newData,
                                ),
                              ) as bool?;

                              if (context.mounted && didVerifyOTP == true) {
                                context
                                    .pushNamed(ATRoutes.createPasswordScreen);
                              }
                            } else if (sendOtpState is FailureState<String>) {
                              showAppNotification2(
                                context: context,
                                text: sendOtpState.message,
                                type: NotificationType.failure,
                              );
                            }
                          },
                          builder: (BuildContext context,
                              ATAppState<String> sendOtpState) {
                            return ATPlainElevatedBtn(
                              isLoading: sendOtpState is LoadingState<String>,
                              onPressed: shouldEnableBtn
                                  ? () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                            context.read<RegisterUserCubit>().setPhoneNumber(
                                              ATStrings.plus +
                                                  selectedCountry.phoneCode +
                                                  _phoneController.text.trim(),
                                            );
                                        context
                                            .read<SendOtpCubit>()
                                            .sendOtp(
                                              param: <String, dynamic>{
                                                'phone_number':
                                                    ATStrings.plus +
                                                        selectedCountry
                                                            .phoneCode +
                                                        _phoneController.text
                                                            .trim(),
                                              },
                                            );
                                      }
                                    }
                                  : null,
                              btnTitle: ATStrings.verify_fone,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectCountry() async {
    await showModalBottomSheet<Country>(
      context: context,
      builder: (BuildContext context) {
        return const CupertinoPhoneCodeSelectWidget();
      },
    ).then((Country? country) {
      if (country != null) {
        setState(() {
          selectedCountry = country;
        });
      }
    });
  }
}
