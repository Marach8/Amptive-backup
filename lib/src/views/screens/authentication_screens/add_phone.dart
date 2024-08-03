import 'package:amptive/src/services/auth/auth_field_service.dart';
import 'package:amptive/src/utils/constants/constants.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_cupertino.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

import '../../../bloc/authentication/general/auth_bloc.dart';
import '../../../bloc/authentication/general/auth_states.dart';

class AddPhoneScreen extends StatefulWidget {
  const AddPhoneScreen({super.key});

  @override
  State<AddPhoneScreen> createState() => _AddPhoneScreenState();
}

class _AddPhoneScreenState extends State<AddPhoneScreen> {
  late Country _selectedCountry;
  bool _isBottomSheetOpened = false;
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AuthFieldService service;

  @override
  void initState() {
    service = GetIt.I<AuthFieldService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectedCountry = service.country;
    var bottomSheetHeight = 252.h;

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
                    IntrinsicWidth(
                      child: GestureDetector(
                        onTap: () {
                          _selectCountry(bottomSheetHeight);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.h, horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: AmptiveColors.fillGreyColor.withOpacity(0.3),
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
                                  CountryPickerUtils.getFlagImageAssetPath(
                                      _selectedCountry.isoCode),
                                  fit: BoxFit.fill,
                                  height: 12.75.h,
                                  width: 17.w,
                                  package: AmptiveOtherStrings.countryPickers,
                                ),
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                              Text(
                                AmptiveOtherStrings.plus +
                                    _selectedCountry.phoneCode,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: AmptiveColors.whiteColor),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 7.43.w,
                                    top: 10.4.h,
                                    bottom:
                                        _isBottomSheetOpened ? 3.8.h : 12.4.h),
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
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        maxLines: 1,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        cursorColor: AmptiveColors.brandBlueColor,
                        onChanged: service.validatePhoneNumber,
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
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: AmptiveColors.whiteColor),
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
              builder: (context, state) {
            return AmptiveElevatedButtonWidget(
              height: 50.w,
              buttonTitle: AmptiveOtherStrings.verifyPhoneNumber,
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (service.isPhoneValid) {
                  context.pushNamed(AmptiveRoutes.otp,
                      extra: AmptiveOtherStrings.phoneNumber);
                }
              },
            );
          }),
        ),
      ),
    );
  }

  _selectCountry(bottomSheetHeight) async {
    _onBottomSheetOpened();

    Country? pickedCountry = await showModalBottomSheet<Country>(
      context: context,
      builder: (context) {
        Country temp = CountryPickerUtils.getCountryByIsoCode(
            Constants.kDefaultCountrySelected);
        return SizedBox(
          height: bottomSheetHeight,
          child: Column(
            children: <Widget>[
              Container(
                color: const Color(0xFF434343),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text(
                        AmptiveOtherStrings.done,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: AmptiveFontWeights.medium,
                            ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(temp);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                color: AmptiveColors.brandBlackColor,
                height: 0.h,
                thickness: 1.h,
              ),
              Expanded(
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    brightness: Brightness.dark,
                  ),
                  child: Container(
                    color: AmptiveColors.brandBlackColor,
                    child: CountryPickerCupertino(
                      backgroundColor: AmptiveColors.brandBlackColor,
                      diameterRatio: 3.r,
                      pickerItemHeight: 65.h,
                      itemBuilder: _buildCupertinoSelectedItem,
                      onValuePicked: (Country country) {
                        temp = country;
                      },
                      initialCountry: _selectedCountry,
                      itemFilter: (c) =>
                          Constants.kCountryList.contains(c.isoCode),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() => _onBottomSheetClosed());

    if (pickedCountry != null && pickedCountry != _selectedCountry) {
      setState(() {});
      service.setCountry(pickedCountry);
    }
  }

  Widget _buildCupertinoSelectedItem(Country country) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.0.w, vertical: 9.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            CountryPickerUtils.getFlagImageAssetPath(country.isoCode),
            height: 30.0.h,
            width: 41.0.w,
            fit: BoxFit.fill,
            package: AmptiveOtherStrings.countryPickers,
          ),
          SizedBox(width: 23.0.w),
          Text(
            country.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: AmptiveFontSizes.size23,
                ),
          ),
          Expanded(child: SizedBox(width: 8.0.w)),
          Text(
            AmptiveOtherStrings.plus + country.phoneCode,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: AmptiveFontSizes.size23,
                ),
          ),
        ],
      ),
    );
  }

  void _onBottomSheetClosed() {
    setState(() {
      _isBottomSheetOpened = false;
    });
  }

  void _onBottomSheetOpened() {
    setState(() {
      _isBottomSheetOpened = true;
    });
  }
}
