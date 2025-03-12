import 'package:amptive/src/utils/constants/constants.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
//import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

import '../../../bloc/authentication/general/auth_bloc.dart';
import '../../../bloc/authentication/general/auth_events.dart';
import '../../../bloc/authentication/general/auth_states.dart';
import '../../widgets/other_widgets/post_authentication_widgets/cupertino_phone_code_select.dart';

class AddPhoneScreen extends StatefulWidget {
  const AddPhoneScreen({super.key, this.title});
  final String? title;

  @override
  State<AddPhoneScreen> createState() => _AddPhoneScreenState();
}

class _AddPhoneScreenState extends State<AddPhoneScreen> {
  bool _bottomSheetOpened = false;
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AmptiveAppBar(
          title: Text(
            widget.title ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ATStrings.UR_FON_NUMBER,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: ATFontSizes.size17,
                  ),
                ),
                const SizedBox(height: 11),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                      buildWhen: (_, curr) => curr is SelectCountryCodeState,
                      builder: (_, state) {
                        Country selectedCountry = state is SelectCountryCodeState
                          ? state.selectedCountry : CountryPickerUtils.getCountryByIsoCode(
                              Constants.kDefaultCountrySelected);

                        return ATContainer(
                          onTap: () => _selectCountry(),
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          color: ATColors.hex9E9E9E.withOpacity(0.3),
                          radius: 14,
                          border: Border.all(
                            color: _bottomSheetOpened ? ATColors.hex307FE2 : ATColors.trspntColor,
                            width: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 13, width: 17,
                                child: Image.asset(
                                  CountryPickerUtils.getFlagImageAssetPath(selectedCountry.isoCode),
                                  fit: BoxFit.fill,
                                  package: ATStrings.countryPickers,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                ATStrings.plus + selectedCountry.phoneCode,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: ATColors.whiteColor
                                ),
                              ),
                              Icon(
                                _bottomSheetOpened ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ATTextFormFieldWidget(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        cursorColor: ATColors.hex307FE2,
                        onChanged: (val) {
                          context.read<AmptiveAuthBloc>().add(AddPhoneNumberEvent(value: val));
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          hintText: ATStrings.FONE_NO,
                          hintStyle: Theme.of(context).textTheme.labelMedium,
                          errorStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: ATColors.textRedColor,
                          ),
                          filled: true,
                          fillColor: ATColors.hex9E9E9E.withOpacity(0.3),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(width: 2, color: ATColors.hex307FE2),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: ATColors.trspntColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Text(
                  ATStrings.NO_WILL_BE_VERIFIED,
                  style: Theme.of(context).textTheme.titleSmall,
                )
              ],
            ),
          ),
        ),

        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
            buildWhen: (_, curr) => curr is AddPhoneNumberState,
            builder: (context, state) {
              Country selectedCountry = state is SelectCountryCodeState
                ? state.selectedCountry : CountryPickerUtils.getCountryByIsoCode(
                    Constants.kDefaultCountrySelected);
              return AmptivePlainElevatedBtnWidget(
                height: 50,
                buttonTitle: ATStrings.VERIFY_FONE,
                onPressed: state is AddPhoneNumberState && state.isPhoneValid
                  ? () {
                    final phoneNo = ATStrings.plus + selectedCountry.phoneCode + _phoneController.text.trim();
                    context.pushNamed(
                      ATRoutes.OTP_SCREEN,
                      extra: [phoneNo, widget.title ?? '']
                    );
                  } : null,
              );
            }
          ),
        ),
      ),
    );
  }

  _selectCountry() async {
    _bottomSheetOpened = true;
    context.read<AmptiveAuthBloc>().add(OpenCountryBottomSheetEvent());

    await showModalBottomSheet<Country>(
      context: context,
      builder: (context) {
        return const CupertinoPhoneCodeSelectWidget();
      },
    ).whenComplete(() => _bottomSheetOpened = false);
  }
}
