import 'package:amptive/src/utils/constants/constants.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

import '../../../bloc/authentication/general/auth_bloc.dart';
import '../../../bloc/authentication/general/auth_events.dart';
import '../../../bloc/authentication/general/auth_states.dart';
import '../../widgets/other_widgets/post_authentication_widgets/cupertino_phone_code_select.dart';

class AddPhoneScreen extends StatefulWidget {
  const AddPhoneScreen({super.key});

  @override
  State<AddPhoneScreen> createState() => _AddPhoneScreenState();
}

class _AddPhoneScreenState extends State<AddPhoneScreen> {
  bool _isBottomSheetOpened = false;
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        backgroundColor: AmptiveColors.brandBlackColor,
        appBar: const AmptiveAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AmptiveOtherStrings.whatIsYourPhoneNumber,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: AmptiveFontSizes.size17,
                      ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                        buildWhen: (_, curr) => curr is SelectCountryCodeState,
                        builder: (context, state) {
                          Country selectedCountry =
                              state is SelectCountryCodeState
                                  ? state.selectedCountry
                                  : CountryPickerUtils.getCountryByIsoCode(
                                      Constants.kDefaultCountrySelected);
                          return IntrinsicWidth(
                            child: GestureDetector(
                              onTap: () {
                                _selectCountry();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.h, horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: AmptiveColors.fillGreyColor
                                      .withOpacity(0.3),
                                  border: Border.all(
                                    color: _isBottomSheetOpened
                                        ? AmptiveColors.brandBlueColor
                                        : AmptiveColors.transparentColor,
                                    width: 2.w,
                                  ),
                                  borderRadius: SmoothBorderRadius(
                                    cornerRadius: 14.r,
                                    cornerSmoothing: 1.0,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 17.h,
                                      width: 17.w,
                                      child: Image.asset(
                                        CountryPickerUtils
                                            .getFlagImageAssetPath(
                                                selectedCountry.isoCode),
                                        fit: BoxFit.fill,
                                        height: 12.75.h,
                                        width: 17.w,
                                        package:
                                            AmptiveOtherStrings.countryPickers,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7.w,
                                    ),
                                    Text(
                                      AmptiveOtherStrings.plus +
                                          selectedCountry.phoneCode,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              color: AmptiveColors.whiteColor),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 7.43.w,
                                          top: 10.4.h,
                                          bottom: _isBottomSheetOpened
                                              ? 3.8.h
                                              : 12.4.h),
                                      // add padding to adjust icon
                                      child: Transform.rotate(
                                        angle: math.pi / 2,
                                        child: Icon(
                                          _isBottomSheetOpened
                                              ? Icons.arrow_back_ios
                                              : Icons.arrow_forward_ios_rounded,
                                          color: AmptiveColors.whiteColor,
                                          size: 22.13.h,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: AmptiveTextFormFieldWidget(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        cursorColor: AmptiveColors.brandBlueColor,
                        onChanged: (val) {
                          context
                              .read<AmptiveAuthBloc>()
                              .add(AddPhoneNumberEvent(value: val));
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 16.w),
                          hintText: AmptiveOtherStrings.phoneNumber,
                          hintStyle: Theme.of(context).textTheme.labelMedium,
                          errorStyle: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: AmptiveColors.textRedColor,
                              ),
                          filled: true,
                          fillColor:
                              AmptiveColors.fillGreyColor.withOpacity(0.3),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.w,
                              color: AmptiveColors.brandBlueColor,
                            ),
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 14.r,
                              cornerSmoothing: 1.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.w,
                              color: AmptiveColors.transparentColor,
                            ),
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 14.r,
                              cornerSmoothing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
        bottomSheet: Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
              buildWhen: (_, curr) => curr is AddPhoneNumberState,
              builder: (context, state) {
                return AmptiveElevatedButtonWidget(
                  height: 50.w,
                  buttonTitle: AmptiveOtherStrings.verifyPhoneNumber,
                  onPressed: state is AddPhoneNumberState && state.isPhoneValid
                      ? () {
                          context.pushNamed(AmptiveRoutes.otp,
                              extra: AmptiveOtherStrings.phoneNumber);
                        }
                      : null,
                );
              }),
        ),
      ),
    );
  }

  _selectCountry() async {
    _isBottomSheetOpened = true;
    context.read<AmptiveAuthBloc>().add(OpenCountryBottomSheetEvent());

    await showModalBottomSheet<Country>(
      context: context,
      builder: (context) {
        return const CupertinoPhoneCodeSelectWidget();
      },
    ).whenComplete(() => _isBottomSheetOpened = false);
  }
}
