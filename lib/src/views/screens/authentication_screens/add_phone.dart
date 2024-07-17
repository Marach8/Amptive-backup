import 'package:amptive/src/providers/form_providers.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/common_widgets.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_cupertino.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

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

  late FormProvider _formProvider;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    _formProvider = Provider.of<FormProvider>(context);
    _selectedCountry = _formProvider.country;
    var bottomSheetHeight = 252.h;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AmpColors.brandBlack,
        appBar: BuildAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What is your phone number?",
                  style: GoogleFonts.inter(
                    color: AmpColors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
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
                            color: const Color(0xFF9E9E9E).withOpacity(0.3),
                            border: Border.all(
                              color: _isBottomSheetOpened
                                  ? AmpColors.brandBlue
                                  : AmpColors.transparent,
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
                                  package: "country_pickers",
                                ),
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                              Text(
                                "+${_selectedCountry.phoneCode}",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.sp,
                                    color: AmpColors.white),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 7.43.w,
                                    top: 10.4.h,
                                    bottom: _isBottomSheetOpened ? 3.8.h : 12.4
                                        .h),
                                // add padding to adjust icon
                                child: Transform.rotate(
                                  angle: math.pi / 2,
                                  child: Icon(
                                    _isBottomSheetOpened
                                        ? Icons.arrow_back_ios
                                        : Icons.arrow_forward_ios_rounded,
                                    color: AmpColors.white,
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
                        cursorColor: AmpColors.brandBlue,
                        onChanged: _formProvider.validatePhoneNumber,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 16.w),
                          hintText: "Phone number",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: AmpColors.authHintColor,
                            fontWeight: FontWeight.normal,
                          ),
                          errorStyle: GoogleFonts.inter(
                            color: AmpColors.textRed,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF9E9E9E).withOpacity(0.3),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.w,
                              color: AmpColors.brandBlue,
                            ),
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 14.r,
                              cornerSmoothing: 1.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.w,
                              color: AmpColors.transparent,
                            ),
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 14.r,
                              cornerSmoothing: 1.0,
                            ),
                          ),
                        ),
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.sp,
                            color: AmpColors.white),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    height: 1.h,
                  ),
                ),
                Consumer<FormProvider>(builder: (context, model, _) {
                  return Container(
                    width: 350.w,
                    height: 50.w,
                    margin: EdgeInsets.only(
                        bottom: _isBottomSheetOpened
                            ? bottomSheetHeight
                            : 29.h),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (model.isPhoneValid) {
                          context.pushNamed(AmptiveRoutes.otp, extra: "phone number");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: model.isPhoneValid
                              ? AmpColors.brandBlue
                              : const Color(0xFF2F2F2F)),
                      child: Text(
                        "Verify phone number",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: model.isPhoneValid
                                ? AmpColors.white
                                : const Color(0xFF666666)),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectCountry(bottomSheetHeight) async {
    _onBottomSheetOpened();

    Country? pickedCountry = await showModalBottomSheet<Country>(
      context: context,
      builder: (context) {
        Country temp = CountryPickerUtils.getCountryByIsoCode('NG');
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
                        'Done',
                        style: GoogleFonts.inter(
                            color: AmpColors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(temp);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                color: AmpColors.brandBlack,
                height: 0.h,
                thickness: 1.h,
              ),
              Expanded(
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    brightness: Brightness.dark,
                  ),
                  child: Container(
                    color: AmpColors.brandBlack,
                    child: CountryPickerCupertino(
                      backgroundColor: AmpColors.brandBlack,
                      diameterRatio: 3.r,
                      pickerItemHeight: 65.h,
                      itemBuilder: _buildCupertinoSelectedItem,
                      onValuePicked: (Country country) {
                        temp = country;
                      },
                      initialCountry: _selectedCountry,
                      itemFilter: (c) =>
                          ['AR', 'DE', 'GB', 'NG', 'CN'].contains(c.isoCode),
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
      _formProvider.setCountry(pickedCountry);
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
            package: "country_pickers",
          ),
          SizedBox(width: 23.0.w),
          Text(
            country.name,
            style: GoogleFonts.inter(
              fontSize: 23.sp,
              fontWeight: FontWeight.normal,
            ),
          ),
          Expanded(child: SizedBox(width: 8.0.w)),
          Text(
            "+${country.phoneCode}",
            style: GoogleFonts.inter(
              fontSize: 23.sp,
              fontWeight: FontWeight.normal,
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
