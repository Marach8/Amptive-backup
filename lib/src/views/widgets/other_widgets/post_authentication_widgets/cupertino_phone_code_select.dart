import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_cupertino.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/authentication/general/auth_bloc.dart';
import '../../../../bloc/authentication/general/auth_events.dart';
import '../../../../bloc/authentication/general/auth_states.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/constants.dart';
import '../../../../utils/constants/font_sizes.dart';
import '../../../../utils/constants/font_weights.dart';
import '../../../../utils/constants/strings/other_strings.dart';

class CupertinoPhoneCodeSelectWidget extends StatelessWidget {
  const CupertinoPhoneCodeSelectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 252.h,
      child: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
          buildWhen: (_, curr) => curr is OpenCountryBottomSheetState,
          builder: (context, state) {
            Country? selectedCountry =
                state is SelectCountryCodeState ? state.selectedCountry : null;

            return state is SelectCountryCodeState
                ? Column(
                    children: <Widget>[
                      Container(
                        color: ATColors.grey3Color,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            CupertinoButton(
                              child: Text(
                                ATStrings.done,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: AmptiveFontWeights.w500,
                                    ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                context.read<AmptiveAuthBloc>().add(
                                  PickCountryCodeEvent(country: selectedCountry!)
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: ATColors.brandBlack,
                        height: 0.h,
                        thickness: 1.h,
                      ),
                      Expanded(
                        child: CupertinoTheme(
                          data: const CupertinoThemeData(
                            brightness: Brightness.dark,
                          ),
                          child: Container(
                            color: ATColors.brandBlack,
                            child: CountryPickerCupertino(
                              backgroundColor: ATColors.brandBlack,
                              diameterRatio: 3.r,
                              pickerItemHeight: 65.h,
                              itemBuilder: (country) =>
                                  _buildCupertinoSelectedItem(context, country),
                              onValuePicked: (Country country) {
                                selectedCountry = country;
                              },
                              initialCountry: state.selectedCountry,
                              itemFilter: (c) =>
                                  Constants.kCountryList.contains(c.isoCode),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Column();
          }),
    );
  }

  Widget _buildCupertinoSelectedItem(BuildContext context, Country country) {
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
            package: ATStrings.countryPickers,
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
            ATStrings.plus + country.phoneCode,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: AmptiveFontSizes.size23,
            ),
          ),
        ],
      ),
    );
  }
}
