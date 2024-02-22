import 'package:amptive/providers/form_providers.dart';
import 'package:amptive/routers/amptive_routes.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class DateOfBirthScreen extends StatefulWidget {
  const DateOfBirthScreen({super.key});

  @override
  State<DateOfBirthScreen> createState() => _DateOfBirthScreenState();
}

class _DateOfBirthScreenState extends State<DateOfBirthScreen> {
  TextEditingController _dobController = TextEditingController();
  late FormProvider _formProvider;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _formProvider = Provider.of<FormProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AmpColors.brandBlack,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What is your date of birth?",
                  style: GoogleFonts.inter(
                    color: AmpColors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                TextFormField(
                  controller: _dobController,
                  onChanged: _formProvider.validateDOB,
                  onTap: () {
                    _selectDate();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  maxLines: 1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.none,
                  cursorColor: AmpColors.brandBlue,
                  decoration: InputDecoration(
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
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.w,
                        color: AmpColors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.sp,
                      color: AmpColors.white),
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
                    margin: EdgeInsets.only(bottom: 29.h),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate() &&
                            model.isDOBValid) {
                          context.goNamed(AmptiveRoutes.preference);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: model.isEmailValid
                              ? AmpColors.brandBlue
                              : const Color(0xFF2F2F2F)),
                      child: Text(
                        "Next",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: model.isEmailValid
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

  void _selectDate() {
    BottomPicker.date(
      layoutOrientation: LayoutOrientation.rtl,
        dateOrder: DatePickerDateOrder.mdy,
        displayCloseIcon: false,
        displaySubmitButton: false,
        dismissable: true,
        title:  "Done",
        titleStyle: GoogleFonts.inter(
          backgroundColor: const Color(0xFF434343),
            color: AmpColors.white,
            fontWeight: FontWeight.normal,
            fontSize: 16.sp
        ),
        pickerTextStyle: GoogleFonts.inter(
          color: AmpColors.white,
          fontWeight: FontWeight.normal,
          fontSize: 24.sp
        ),
        backgroundColor: AmpColors.brandBlack,
        onChange: (index) {
          setState(() {
            _dobController.text = index.toString();
          });
        },
        bottomPickerTheme:  BottomPickerTheme.temptingAzure
    ).show(context);
  }
}
