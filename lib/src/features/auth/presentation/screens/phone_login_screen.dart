import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/login_cubit.dart';
import 'package:amptive/src/features/post_auth/post_authentication_widgets/cupertino_phone_code_select.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/app_bar_widget.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key, this.title});
  final String? title;

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> with ATValidators {
  final TextEditingController _phoneNumberCntrl = TextEditingController();
  final TextEditingController _pswrdCntrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  final ValueNotifier<(bool, bool)> _btnNotifier =
      ValueNotifier<(bool, bool)>((false, false));
  Country selectedCountry = CountryPickerUtils.getCountryByIsoCode(
    Constants.kDefaultCountrySelected,
  );

  @override
  void initState() {
    super.initState();
    _phoneNumberCntrl.addListener(() {
      if (_phoneNumberCntrl.text.length == 10) {
        _btnNotifier.value = (true, _btnNotifier.value.$2);
      } else {
        _btnNotifier.value = (false, _btnNotifier.value.$2);
      }
    });

    _pswrdCntrl.addListener(() {
      if (_pswrdCntrl.text.length >= 5) {
        _btnNotifier.value = (_btnNotifier.value.$1, true);
      } else {
        _btnNotifier.value = (_btnNotifier.value.$1, false);
      }
    });
  }

  @override
  void dispose() {
    _phoneNumberCntrl.dispose();
    _pswrdCntrl.dispose();
    _btnNotifier.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(),
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar: ATAppBar(
            leading: const ATBackBtn(),
            titleText: widget.title ?? '',
          ),
          body: BlocConsumer<LoginCubit, ATAppState<dynamic>>(
            listener: (BuildContext context, ATAppState<dynamic> state) {
              if (state is SuccessState<dynamic>) {
                context.goNamed(ATRoutes.dashboard);
              } else if (state is FailureState) {
                showAppNotification2(
                  context: context, text: state.message);
              }
            },
            builder: (BuildContext context, ATAppState<dynamic> state) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          ATStrings.WhatIsYourPhoneNumber,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
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
                            const SizedBox(width: 10),
                            Expanded(
                              child: ATTextFormField(
                                  controller: _phoneNumberCntrl,
                                  hintText: ATStrings.phoneNumber,
                                  keyboardType: TextInputType.phone,
                                  validator: validatePhoneNumber,
                                  prefixIcon: const SizedBox(width: 10),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        16, 12, 16, 12),
                                    hintText: ATStrings.phoneNumber,
                                    hintStyle:
                                        Theme.of(context).textTheme.labelMedium,
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
                                          width: 2,
                                          color: ATColors.transparent),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Text(
                          ATStrings.UR_PSWRD,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        ATTextFormField(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Icon(Icons.key_outlined),
                          ),
                          controller: _pswrdCntrl,
                          hintText: ATStrings.enterYourPassword,
                          validator: validatePassword,
                          obscureText: _passwordVisible,
                          maxLines: 1,
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
                              }),
                        ),
                      ]),
                ),
              );
            },
          ),
          bottomSheet: Builder(
            builder: (BuildContext context) {
              final double bottom = MediaQuery.viewInsetsOf(context).bottom;
              final double bottomPadding = bottom == 0 ? 50 : 10;
              final ATAppState<dynamic> cubitState =
                  context.watch<LoginCubit>().state;
              final bool isLoading = cubitState is LoadingState<dynamic>;
              return Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, bottomPadding),
                child: ValueListenableBuilder<(bool, bool)>(
                  valueListenable: _btnNotifier,
                  builder: (_, (bool, bool) value, __) {
                    final bool enable = value.$1 && value.$2;
                    return ATPlainElevatedBtn(
                      isLoading: isLoading,
                      onPressed: enable
                          ? () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context.read<LoginCubit>().loginUser(
                                  param: <String, dynamic>{
                                    'phone_number':
                                        '${ATStrings.plus}${selectedCountry.phoneCode}${_phoneNumberCntrl.text.trim()}',
                                    'password': _pswrdCntrl.text.trim(),
                                  },
                                );
                              }
                            }
                          : null,
                      btnTitle: ATStrings.SIGN_IN,
                    );
                  },
                ),
              );
            },
          ),
        ),
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
